﻿Rem
	====================================================================
	code for advertisement-objects in programme planning
	====================================================================

	As we have to know broadcast states (eg. "this spot failed/run OK"),
	we have to create individual "TAdvertisement"/spots.
	This way these objects can store that states.

	Another benefit is: TAdvertisement is "TBroadcastMaterial" which would
	make it exchangeable with other material... This could be eg. used
	to make them placeable as "programme" - which creates shoppingprogramme
	or other things. (while programme as advertisement could generate Trailers)
End Rem
SuperStrict
Import "game.broadcastmaterial.base.bmx"
Import "game.programme.adcontract.bmx"
Import "game.publicimage.bmx"
Import "game.broadcast.genredefinition.movie.bmx"
Import "game.broadcast.base.bmx"


'ad spot
Type TAdvertisement Extends TBroadcastMaterialDefaultImpl {_exposeToLua="selected"}
	Field contract:TAdContract	= Null
	'Eventuell den "state" hier als reine visuelle Hilfe nehmen.
	'Dinge wie "Spot X von Y" koennen auch dynamisch erfragt werden
	'
	'Auch sollte ein AdContract einen Event aussenden, wenn erfolgreich
	'gesendet worden ist ... dann koennen die "GUI"-Bloecke darauf reagieren
	'und ihre Werte aktualisieren


	Method Create:TAdvertisement(contract:TAdContract)
		self.contract = contract

		self.setMaterialType(TVTBroadcastMaterialType.ADVERTISEMENT)
		'by default a freshly created programme is of its own type
		self.setUsedAsType(TVTBroadcastMaterialType.ADVERTISEMENT)

		self.owner = self.contract.owner

		Return self
	End Method


	'override default getter to make contract id the reference id
	Method GetReferenceID:int() {_exposeToLua}
		return self.contract.id
	End Method


	'override default getter
	Method GetDescription:string() {_exposeToLua}
		Return contract.GetDescription()
	End Method


	'get the title
	Method GetTitle:string() {_exposeToLua}
		Return contract.GetTitle()
	End Method


	Method GetBlocks:int(broadcastType:int=0) {_exposeToLua}
		Return contract.GetBlocks()
	End Method


rem
	Method GetAudienceAttraction:TAudienceAttraction(hour:Int, block:Int, lastMovieBlockAttraction:TAudienceAttraction, lastNewsBlockAttraction:TAudienceAttraction, withSequenceEffect:Int=False, withLuckEffect:Int=False )
		'TODO: @Manuel - hier brauchen wir eine geeignete Berechnung :D
		If lastMovieBlockAttraction then return lastMovieBlockAttraction

		Local result:TAudienceAttraction = New TAudienceAttraction
		result.BroadcastType = 1
		result.Genre = 20 'paid programming
		Local genreDefinition:TMovieGenreDefinition = GetMovieGenreDefinitionCollection().Get(result.Genre)

		'copied and adjusted from "programme"
		If block = 1 Then
			'1 - Qualität des Programms
			result.Quality = GetQuality()

			'2 - Mod: Genre-Popularität / Trend
			result.GenrePopularityMod = (genreDefinition.Popularity.Popularity / 100) 'Popularity => Wert zwischen -50 und +50

			'3 - Genre <> Zielgruppe
			result.GenreTargetGroupMod = genreDefinition.AudienceAttraction.Copy()
			result.GenreTargetGroupMod.SubtractFloat(0.5)

			'4 - Image
			result.PublicImageMod = GetPublicImageCollection().Get(owner).GetAttractionMods()
			result.PublicImageMod.SubtractFloat(1)

			'5 - Trailer - gibt es nicht fuer Werbesendungen (die
			'              waeren ja dann wieder Werbung)

			'6 - Flags
			result.MiscMod = TAudience.CreateAndInit(1, 1, 1, 1, 1, 1, 1, 1, 1)
			result.MiscMod.SubtractFloat(1)

			'result.CalculateBaseAttraction()
		Else
			result.CopyBaseAttractionFrom(lastMovieBlockAttraction)
		Endif

		'8 - Stetige Auswirkungen der Film-Quali. Gute Filme bekommen mehr Attraktivität, schlechte Filme animieren eher zum Umschalten
		result.QualityOverTimeEffectMod = ((result.Quality - 0.5)/2.5) * (block - 1)

		'9 - Genres <> Sendezeit
		result.GenreTimeMod = genreDefinition.TimeMods[hour] - 1 'Genre/Zeit-Mod

		'10 - News-Mod
		'result.NewsShowBonus = lastNewsBlockAttraction.Copy().MultiplyFloat(0.2)

		'result.CalculateBlockAttraction()

		'result.SequenceEffect = genreDefinition.GetSequence(lastNewsBlockAttraction, result, 0.1, 0.5)

		result.Recalculate()

		Return result
	End Method
endrem

	'override
	Method FinishBroadcasting:int(day:int, hour:int, minute:int, audienceData:object)
		Super.FinishBroadcasting(day,hour,minute, audienceData)

		if usedAsType = TVTBroadcastMaterialType.PROGRAMME
			FinishBroadcastingAsProgramme(day, hour, minute, audienceData)
'			GetBroadcastInformationProvider().SetInfomercialAired(licence.owner, GetBroadcastInformationProvider().GetInfomercialAired(licence.owner) + 1, GetWorldTime.MakeTime(0,day,hour,minute) )

			'inform others
			EventManager.triggerEvent(TEventSimple.Create("broadcast.advertisement.FinishBroadcastingAsProgramme", New TData.addNumber("day", day).addNumber("hour", hour).addNumber("minute", minute).add("audienceData", audienceData), Self))
		elseif usedAsType = TVTBroadcastMaterialType.ADVERTISEMENT
			'nothing happening - ads get paid on "beginBroadcasting"

			'inform others
			EventManager.triggerEvent(TEventSimple.Create("broadcast.advertisement.FinishBroadcasting", New TData.addNumber("day", day).addNumber("hour", hour).addNumber("minute", minute).add("audienceData", audienceData), Self))
		endif

		return TRUE
	End Method


	'ad got send as infomercial
	Method FinishBroadcastingAsProgramme:int(day:int, hour:int, minute:int, audienceData:object)
		self.SetState(self.STATE_OK)
		
		'give money
		local audienceResult:TAudienceResult = TAudienceResult(audienceData)
		Local earn:Int = audienceResult.Audience.GetSum() * contract.GetPerViewerRevenue()
		if earn > 0
			TLogger.Log("TAdvertisement.FinishBroadcastingAsProgramme", "Infomercial sent, earned "+earn+CURRENCYSIGN+" with an audience of " + audienceResult.Audience.GetSum(), LOG_DEBUG)
			GetPlayerFinance(owner).EarnInfomercialRevenue(earn, contract)
		else
			Notify "FinishBroadcastingAsProgramme: earn value is negative: "+earn 
		endif
		'adjust topicality relative to possible audience 
		contract.base.CutInfomercialTopicality(GetInfomercialTopicalityCutModifier( audienceResult.GetWholeMarketAudienceQuotePercentage()))
	End Method


	Method BeginBroadcasting:int(day:int, hour:int, minute:int, audienceData:object)
		Super.BeginBroadcasting(day,hour,minute, audienceData)
		'run as infomercial
		if self.usedAsType = TVTBroadcastMaterialType.PROGRAMME
			'no need to do further checks
			return TRUE
		endif

		local audienceResult:TAudienceResult = TAudienceResult(audienceData)

		'check if the ad satisfies all requirements
		local successful:int = False
		if "OK" = IsPassingRequirements(audienceResult, GetBroadcastManager().GetCurrentProgrammeBroadcastMaterial(owner))
			successful = True
		endif


		if not successful
			setState(STATE_FAILED)
		Else
			setState(STATE_OK)
			'successful sent - so increase the value the contract
			contract.spotsSent:+1
			'TLogger.Log("TAdvertisement.BeginBroadcasting", "Player "+contract.owner+" sent SUCCESSFUL spot "+contract.spotsSent+"/"+contract.GetSpotCount()+". Title: "+contract.GetTitle()+". Time: day "+(day-GetWorldTime().GetStartDay())+", "+hour+":"+minute+".", LOG_DEBUG)
		EndIf
		return TRUE
	End Method


	'checks if the contract/ad passes specific requirements
	'-> min audience, target groups, ...
	'returns "OK" when passing, or another String with the reason for failing
	Method IsPassingRequirements:String(audienceResult:TAudienceResult, previouslyRunningBroadcastMaterial:TBroadcastMaterial = Null)
		'checks against audience
		If audienceResult
			'programme broadcasting outage = ad fails too!
			If audienceResult.broadcastOutage
				return "OUTAGE"
			'condition not fulfilled
			ElseIf audienceResult.Audience.GetSum() < contract.GetMinAudience()
				return "SUM"
			'limited to a specific target group - and not fulfilled
			ElseIf contract.GetLimitedToTargetGroup() > 0 and audienceResult.Audience.GetValue(contract.GetLimitedToTargetGroup()) < contract.GetMinAudience()
				return "TARGETGROUP"
			EndIf
		EndIf

		'limited to a specific genre - and not fulfilled
		If contract.GetLimitedToGenre() >= 0 or contract.GetLimitedToProgrammeFlag() > 0
			'check current programme of the owner
			'TODO: check if that has flaws playing with high speed
			'      (check if current broadcast is correctly set at this
			'      time)
			'if no previous material was given, use the currently running one
			if not previouslyRunningBroadcastMaterial then previouslyRunningBroadcastMaterial = GetBroadcastManager().GetCurrentProgrammeBroadcastMaterial(owner)

			'should not happen - as it else is a broadcastOutage
			if not previouslyRunningBroadcastMaterial
				Return "OUTAGE"
			else
				local genreDefinition:TGenreDefinitionBase = previouslyRunningBroadcastMaterial.GetGenreDefinition()
				if contract.GetLimitedToGenre() >= 0
					if genreDefinition and genreDefinition.referenceId <> contract.GetLimitedToGenre()
						Return "GENRE"
					endif
				endif
				if contract.GetLimitedToProgrammeFlag() > 0
					if not (contract.GetLimitedToProgrammeFlag() & previouslyRunningBroadcastMaterial.GetProgrammeFlags())
						Return "FLAGS"
					endif
				endif
			endif
		EndIf

		return "OK"
	End Method


	Method GetInfomercialTopicalityCutModifier:float( audienceQuote:float = 0.5 ) {_exposeToLua}
		'by default, all infomercials would cut their topicality by
		'100% when broadcasted on 100% audience watching
		'but instead of a linear growth, we use the logistical influence
		'to grow fast at the beginning (near 0%), and
		'to grow slower at the end (near 100%)
		return 1.0 - THelper.LogisticalInfluence_Euler(audienceQuote, 1)
	End Method


	Method GetQuality:Float() {_exposeToLua}
		return contract.GetQuality()
	End Method


	Method ShowSheet:int(x:int,y:int,align:int)
		self.contract.ShowSheet(x, y, align, self.usedAsType)
	End Method
End Type