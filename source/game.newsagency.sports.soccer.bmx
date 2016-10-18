SuperStrict
Import "game.newsagency.sports.bmx"
Import "game.stationmap.bmx"
Import "Dig/base.util.persongenerator.bmx"
Import "Dig/base.util.mersenne.bmx"


'=== SOCCER ===
Type TNewsEventSport_Soccer extends TNewsEventSport
	Global teamsPerLeague:int = 4
	'name | abbreviation | singular/plural 
	Global teamPrefixes:string[] = ["Fussballverein|FV|s",..
	                                "Fussballfreunde|FF|p", ..
	                                "Hallenkicker|HK|p", ..
	                                "Freizeitkicker|FK|p", ..
	                                "Spielvereinigung|SpVgg|p", ..
	                                "1. Fussballclub|1.FC|s", ..
	                                "2. Fussballclub|2.FC|s", ..
	                                "Ballsportfreunde|BSV|p", ..
	                                "Sportverein|SV|s", ..
	                                "Kickers|K|p", ..
	                                "Dynamo|D|s", ..
	                                "Barfuss|Bf|s", ..
	                                "Bolzclub|BC|s", ..
	                                "Fussballclub|FC|s", ..
	                                "Fussballsportverein|FSV|s", ..
	                                "Werksportverein|WSV|s" ..
	                               ]

	Method New()
		name = "SOCCER"
	End Method


	Method Initialize:TNewsEventSport_Soccer()
		Super.Initialize()
		return self
	End Method


	Method CreateDefaultLeagues:int()
		local soccerConfig:TData = GetStationMapCollection().GetSportData("soccer", new TData)
		'create 4 leagues (if not overridden)
		local leagueCount:Int = soccerConfig.GetInt("leagueCount", 4)

		CreateLeagues( leagueCount )

		for local i:int = 1 to leagueCount
			local l:TNewsEventSportLeague_Soccer = TNewsEventSportLeague_Soccer(GetLeagueAtIndex(i-1))
			l.name = soccerConfig.GetData("league"+i).GetString("name", i+". Liga")
			l.nameShort = soccerConfig.GetData("league"+i).GetString("nameShort", i+". L")
		Next
	End Method


	Function CreateMatch:TNewsEventSportMatch_Soccer()
		return new TNewsEventSportMatch_Soccer
	End Function


	Method CreateTeam:TNewsEventSportTeam(prefix:String="", cityName:string="", teamName:string="", teamNameInitials:string="")
		if not prefix then prefix = teamPrefixes[RandRange(0, teamPrefixes.length-1)]

		local team:TNewsEventSportTeam = new TNewsEventSportTeam
		local teamPrefix:string[] = prefix.Split("|")


		if cityName 
			team.city = cityName
		else
			'fall back to teamname if someone forgot to define a city
			team.city = teamName
		endif
		if teamName
			team.name = teamName
		else
			team.name = team.city
		endif

		local capitalLetters:string = teamNameInitials
		if capitalLetters = ""
			'method 1 - only capital letters
			rem
			For local ch:int = EachIn teamNames[i]
				if (ch>=Asc("A") And ch<=Asc("Z")) then capitalLetters :+ Chr(ch)
			Next
			endrem
			'method 2 - name-parts ("Bad |Klein|grunda" = "BKG")
			For local part:string = EachIn team.name.split("|")
				capitalLetters :+ Chr(StringHelper.UCFirst(part)[0])
			Next
		endif

		team.nameInitials = capitalLetters
		'clean potential "splitters" (now we created "capital letters")
		team.city = team.city.replace("|","")
		team.name = team.name.replace("|","")

		team.clubName = teamPrefix[0]
		team.clubNameInitials = teamPrefix[1]
		if teamPrefix.length < 2 or teamPrefix[2] = "s" 
			team.clubNameSingular = True
		else
			team.clubNameSingular = False
		endif

		return team
	End Method


	Method CreateLeagues(leagueCount:int)
		'select and fill teams
		local allUsedCityNames:string[]
		local countryCodes:string[] = GetPersonGenerator().GetCountryCodes()
		local emptyData:TData = new TData
		local predefinedSportData:TData = GetStationMapCollection().GetSportData("soccer", emptyData)
'print predefinedSportData.ToString()
		
		For local leagueIndex:int = 0 until leagueCount
			local cityNames:string[]
			local predefinedLeagueData:TData = predefinedSportData.GetData("league"+(leagueIndex+1), emptyData)

			For local i:int = 0 until teamsPerLeague
				local cityName:string
				'skip random name generation, if a team is defined already
				local predefinedTeamData:TData = predefinedLeagueData.GetData("team"+(i+1), emptyData)
				cityName = predefinedTeamData.GetString("name")
				

				if cityName = ""
					local tries:int = 0
					repeat
						cityName = GetStationMapCollection().GenerateCity("|") 'split parts
						tries :+ 1
					until not StringHelper.InArray(cityName, allUsedCityNames) or tries > 1000
					if tries > 1000 then cityName = "unknown-"+Millisecs()+"-" + RandRange(0,100000)
				endif
				cityNames :+ [cityName]
				allUsedCityNames :+ [cityName]
			Next


			local teams:TNewsEventSportTeam[]
			For local i:int = 0 until cityNames.length
				'use predefined data if possible
				local predefinedTeamData:TData = predefinedLeagueData.GetData("team"+(i+1), emptyData)

				local team:TNewsEventSportTeam
				team = CreateTeam(predefinedTeamData.GetString("prefix", ""), ..
				                  predefinedTeamData.GetString("city", cityNames[i]), ..
				                  predefinedTeamData.GetString("name", ""), ..
				                  predefinedTeamData.GetString("nameInitials", "") ..
				                 )
				teams :+ [team]
print "league="+(leagueIndex+1)+"  team="+(i+1)+"  name=" + team.name+"  city="+team.city+"  nameInitials="+team.nameInitials+"  clubName="+team.clubName+"  clubNameInitials="+team.clubNameInitials

				For local j:int = 0 to 12 '0 is trainer
					local cCode:string = "de"
					if RandRange(0, 10) < 3 then cCode = countryCodes[ RandRange(0, countryCodes.length-1) ]

					local p:TPersonGeneratorEntry = GetPersonGenerator().GetUniqueDataset(cCode, TPersonGenerator.GENDER_MALE)
					local member:TNewsEventsportTeamMember = new TNewsEventsportTeamMember.Init( p.firstName, p.lastName, p.countryCode, p.gender, True)
					if j <> 0
						team.AddMember( member )
					else
						team.SetTrainer( member )
					endif
				Next
			Next
			

			local league:TNewsEventSportLeague_Soccer = new TNewsEventSportLeague_Soccer
			league.Init((leagueIndex+1) + ". " + GetLocale("SOCCER_LEAGUE"), leagueIndex+".", teams)
			league.matchesPerTimeSlot = 2
			if leagueIndex = 0
				league.timeSlots = [ ..
				                    "0_16", "0_20", ..
				                    "2_16", "2_20", ..
				                    "4_16", "4_20", ..
				                    "5_16", "5_20" ..
				                   ]
				league.seasonStartDay = 14
				league.seasonStartMonth = 8
			elseif leagueIndex > 0
				league.timeSlots = [ ..
				                    "0_14", "0_18", ..
				                    "2_14", "2_18", ..
				                    "4_14", "4_18", ..
				                    "5_14", "5_18" ..
				                   ]
				league.seasonStartDay = 29
				league.seasonStartMonth = 7
			endif

			AddLeague( league )
		Next
	End Method
End Type



Type TNewsEventSportLeague_Soccer extends TNewsEventSportLeague
	Field seasonJustBegun:int = False
	'0 = monday, 2 = wednesday ...
	Field timeSlots:string[] = [ ..
	                            "0_14", "0_20", ..
	                            "2_14", "2_20", ..
	                            "4_14", "4_20", ..
	                            "5_14", "5_20" ..
	                           ]
    Field seasonStartMonth:int = 8
    Field seasonStartDay:int = 14
	Field matchesPerTimeSlot:int = 2
	Field startDay:int = 9


	Method Custom_CreateUpcomingMatches:int()
		TNewsEventSport_Soccer.CreateMatchSets(GetCurrentSeason().GetMatchCount(), GetCurrentSeason().GetTeams(), GetCurrentSeason().data.matchPlan, TNewsEventSport_Soccer.CreateMatch)
	End Method
	

	Method StartSeason:int(time:Long = 0)
		seasonJustBegun = True
		return Super.StartSeason(time)
	End Method


	Method GetFirstMatchTime:Long(time:Long)
		'take year of the given time and use the defined months for a
		'soccer season
		'match time: 14. 8. - 14.5. (1. Liga)
		'match time: 29. 7. -       (3. Liga)
		Return GetWorldTime().MakeRealTime(GetWorldTime().GetYear(time), seasonStartMonth, seasonStartDay, 0, 0)
	End Method


	'override
	'2 matches per "time slot" instead of 1
	Method AssignMatchTimes(season:TNewsEventSportSeason, time:Long = 0, isPlayoffSeason:int=0)
		'time = GetNextMatchStartTime(time)

		if not season then season = GetCurrentSeason()
if isPlayoffSeason
	print "AssignMatchTimes PLAYOFFS: " + GetWorldTime().GetFormattedDate(time)
else
	print "AssignMatchTimes: " + GetWorldTime().GetFormattedDate(time)
endif
		local matches:int = 1
		For local m:TNewsEventSportMatch = EachIn season.data.matchPlan
			m.SetMatchTime(time)
			if GetWorldTime().GetTimeGone() < time
				print "   "+ name+ "  match: "+GetWorldTime().GetFormattedDate(m.matchTime) + "  gameday="+ (GetWorldTime().GetDaysRun(m.matchTime)+1) + "  " + m.GetNameShort()
			endif

			'every x-th match we increase time - so matches get "grouped"
			if isPlayoffSeason or (matches > 1 and matches mod matchesPerTimeSlot = 0)
				'also append some minutes, es we would not move forward
				'without (same time returned again and again)
				'print "      get next time"
				time = GetNextMatchStartTime(time + 10 * 60)
			endif

			matches :+1
		Next
	End Method


	Method GetNextMatchStartTime:Long(time:Long = 0, ignoreSeasonBreaks:int = False)
		if time = 0 then time = GetWorldTime().GetTimeGone()
		local weekday:int = GetWorldTime().GetWeekday( time )
		'playtimes:
		'0 monday:    x
		'1 tuesday:   -
		'2 wednesday: x
		'3 thursday:  -
		'4 friday:    x
		'5 saturday:  x
		'6 sunday:    -
		local matchDay:int = 0
		local matchHour:int = -1

'if name = "Regionalliga" then print "find next possible for day " + GetWorldTime().GetDay(time)+"  "+GetWorldTime().GetDayName(weekday)+" ["+weekday+"]  at "+GetWorldTime().GetFormattedTime(time)
		'search the next possible time slot
		For local t:string = EachIn timeSlots
			local information:string[] = t.Split("_")
			local weekdayIndex:int = int(information[0])
			local hour:int = 0
			if information.length > 1 then hour = int(information[1])

			'the same day => next possible hour
			if GetWorldTime().GetWeekday(time) = weekdayIndex
				'earlier or at least before xx:05
				if GetWorldTime().GetDayHour(time) < hour or (GetWorldTime().GetDayHour(time) = hour and GetWorldTime().GetDayMinute(time) < 5)
					matchDay = 0
					matchHour = hour
'if name = "Regionalliga" then print "  same day at " + matchHour
					exit
				endif
			endif

			'future day => earliest hour that day
			if GetWorldTime().GetWeekday(time) < weekdayIndex
				matchDay = weekdayIndex - GetWorldTime().GetWeekday(time)
				matchHour = hour
'if name = "Regionalliga" then print "  future day "+matchDay+" at " + matchHour+":00"+ "   " + t +"  weekdayIndex="+weekdayIndex +"  weekday="+GetWorldTime().GetWeekday(time)
				exit
			endif
				
			if matchHour <> -1 then exit
		Next
		'if nothing was found yet, we might have had a time after the
		'last time slot -- so use the first one
		if matchHour = -1 and timeSlots.length > 0
			local information:string[] = timeSlots[0].Split("_")
			matchDay = GetWorldTime().GetDaysPerWeek() + int(information[0]) - GetWorldTime().GetWeekday(time)
			matchHour = 0
			if information.length > 1 then matchHour = int(information[1])
'if name = "Regionalliga" then print "  next week at day "+matchDay+" at " + matchHour+":00"
		endif



		local matchTime:Long = 0
		'match time: 14. 8. - 14.5.
		'winter break: 21.12. - 21.1.


		local firstDayStartHour:int = 0
		if timeSlots.length > 0
			local firstTime:string[] = timeSlots[0].Split("_")
			if firstTime.length > 1 then firstDayStartHour = int(firstTime[1])
		endif


		matchTime = GetWorldTime().MakeTime(0, GetWorldTime().GetDay(time) + matchDay, matchHour, 0)

		'check if we are in winter now
		if not ignoreSeasonBreaks
			local winterBreak:int = False
			local monthCode:int = int((RSet(GetWorldTime().GetMonth(matchTime),2) + RSet(GetWorldTime().GetDayOfMonth(matchTime),2)).Replace(" ", 0))
			'from 5th of december
			if 1220 < monthCode then winterBreak = True
			'disabled - else we start maybe in april because 22th of january
			'might be right after the latest hour of the game day
			'till 22th of january
			'if  122 > monthCode then winterBreak = True

			if winterBreak and not seasonJustBegun
				local t:Long
				'next match starts in february
				'take time of 2 months later (either february or march - so
				'guaranteed to be the "next" year - when still in december)
				t = matchTime + GetWorldTime().MakeRealTime(0, 2, 0, 0, 0)
				'set time to "next year" begin of february - use "MakeRealTime"
				'to get the time of the ingame "5th february" (or the next
				'possible day)
				t = GetWorldTime().MakeRealTime(GetWorldTime().GetYear(t), 2, 5, 0, 0)
				'calculate next possible match time (after winter break)
				matchTime = GetNextMatchStartTime(t)
'if name = "Regionalliga" then print "   -> winterbreak delay"
			endif
		endif
		
		seasonJustBegun = False

'if name = "Regionalliga" then print "   -> day="+GetWorldTime().GetDay(matchTime) +"  " +GetWorldTime().GetDayName(GetWorldTime().GetWeekday(matchTime))+" ["+GetWorldTime().GetWeekday(matchTime)+"]  at "+GetWorldTime().GetFormattedTime(matchTime)

		return matchTime
	End Method
End Type




Type TNewsEventSportMatch_Soccer extends TNewsEventSportMatch
	Field halfTimePoints:int[2]

	Function CreateMatch:TNewsEventSportMatch_Soccer()
		return new TNewsEventSportMatch_Soccer
	End Function


	Method Run:int()
		Super.Run()

		For local i:int = 0 until points.length
			halfTimePoints[i] = BiasedRandRange(0, points[i], 0.5)
		Next

		if GetWorldTime().GetTimeGone() <= matchTime
			print "RUN MATCH:  now="+GetWorldTime().GetFormattedDate()+"  time="+GetWorldTime().GetFormattedDate(matchTime) + "  gameday="+ (GetWorldTime().GetDaysRun(matchTime)+1) + "  " + GetNameShort()
		endif
	End Method


	Method GetReport:string()
		local singularPlural:string = "P"
		if teams[0].clubNameSingular then singularPlural = "S"
			
		local matchResultText:string = ""
		if points[0] > points[1]
			matchResultText = GetRandomLocale("SPORT_TEAMREPORT_MATCHWIN_" + singularPlural)
		elseif points[0] < points[1]
			matchResultText = GetRandomLocale("SPORT_TEAMREPORT_MATCHLOOSE_" + singularPlural)
		else
			matchResultText = GetRandomLocale("SPORT_TEAMREPORT_MATCHDRAW_" + singularPlural)
		endif
		
			
		local matchText:string = GetLocale("SPORT_TEAMREPORT_MATCHRESULT")
		matchText = matchText.Replace("%MATCHRESULT%", matchResultText)
		if RandRange(0,10) < 7
			matchText = matchText.Replace("%MATCHKIND%", GetRandomLocale("SPORT_TEAMREPORT_MATCHKIND"))
		else
			matchText = matchText.Replace("%MATCHKIND%", "")
		endif
		if RandRange(0,100) < 75
			matchText = matchText.Replace("%TEAM1%", teams[0].GetTeamName())
		else
			matchText = matchText.Replace("%TEAM1%", teams[0].clubNameInitials +" "+ teams[0].name)
		endif
		matchText = matchText.Replace("%TEAM1SHORT%", teams[0].GetTeamNameShort())
		matchText = matchText.Replace("%TEAM1LONG%", teams[0].GetTeamName())

		if RandRange(0,100) < 75
			matchText = matchText.Replace("%TEAM2%", teams[1].GetTeamName())
		else
			matchText = matchText.Replace("%TEAM2%", teams[1].clubNameInitials +" "+ teams[1].name)
		endif
		matchText = matchText.Replace("%TEAM2SHORT%", teams[1].GetTeamNameShort())
		matchText = matchText.Replace("%TEAM2LONG%", teams[1].GetTeamName())
		if points[0] <> 0 or points[1] <> 0
			matchText = matchText.Replace("%FINALSCORE%", points[0]+":"+points[1]+" ("+halfTimePoints[0]+":"+halfTimePoints[1]+")")
		else
			matchText = matchText.Replace("%FINALSCORE%", points[0]+":"+points[1])
		endif
		matchText = matchText.Replace("%TEAMARTICLE1%", GetLocale("SPORT_TEAMNAME_"+singularPlural+"_VARIANT_A") )
		matchText = matchText.Replace("%TEAMARTICLE2%", GetLocale("SPORT_TEAMNAME_"+singularPlural+"_VARIANT_B") )
		matchText = matchText.Replace("%TEAM1STAR%", teams[0].GetMemberAtIndex(-1).GetFullName() )
		matchText = matchText.Replace("%TEAM2STAR%", teams[1].GetMemberAtIndex(-1).GetFullName() )
		matchText = matchText.Replace("%TEAM1STARSHORT%", teams[0].GetMemberAtIndex(-1).GetLastName() )
		matchText = matchText.Replace("%TEAM2STARSHORT%", teams[1].GetMemberAtIndex(-1).GetLastName() )
		matchText = matchText.Replace("%TEAM1KEEPER%", teams[0].GetMemberAtIndex(0).GetFullName() )
		matchText = matchText.Replace("%TEAM2KEEPER%", teams[1].GetMemberAtIndex(0).GetFullName() )
		matchText = matchText.Replace("%TEAM1KEEPERSHORT%", teams[0].GetMemberAtIndex(0).GetLastName() )
		matchText = matchText.Replace("%TEAM2KEEPERSHORT%", teams[1].GetMemberAtIndex(0).GetLastName() )
		matchText = matchText.Replace("%PLAYTIMEMINUTES%", int(duration / 60) )
		matchText = matchText.Trim().Replace("  ", " ") 'remove space if no team article...
		matchText = StringHelper.UCFirst(matchText) 'make first char uppercase
		return matchText
	End Method


	Method GetNameShort:string()
		local result:string
		for local i:int = 0 until points.length
			if result <> "" then result :+ " - "
			result :+ teams[i].GetTeamNameShort()
		Next
		return result
	End Method



	Method GetReportShort:string(mode:string="")
		local result:string
		for local i:int = 0 until points.length
			if result <> ""
				result :+ " : "
				if mode = "INITIALS"
					result :+ points[i] + " " + teams[i].GetTeamInitials()
				else
					result :+ points[i] + " " + teams[i].GetTeamNameShort()
				endif
			else
				if mode = "INITIALS"
					result :+ teams[i].GetTeamInitials() + " " + points[i]
				else
					result :+ teams[i].GetTeamNameShort() + " " + points[i]
				endif
			endif
		Next
		return result

		'return teams[0].nameInitials + " " + points[0]+" : " + points[1] + " " + teams[1].nameInitials
	End Method
	
End Type