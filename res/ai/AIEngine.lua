-- File: AIEngine
-- ============================
-- === AI Engine ===
-- ============================
-- Autor: Manuel V�gele (STARS_crazy@gmx.de)
-- Version: 22.02.2014
-- Erstellt: 12.12.2007

-- ##### INCLUDES #####
dofile("res/ai/SLF.lua")

-- ##### GLOBALS #####
globalPlayer = nil
unitTestMode = true

-- ##### KONSTANTEN #####
TASK_STATUS_OPEN	= "T_open"
TASK_STATUS_PREPARE	= "T_prepare"
TASK_STATUS_RUN		= "T_run"
TASK_STATUS_WAIT	= "T_wait"
TASK_STATUS_DONE	= "T_done"
TASK_STATUS_CANCEL	= "T_cancel"

JOB_STATUS_NEW		= "J_new"
JOB_STATUS_REDO		= "J_redo"
JOB_STATUS_RUN		= "J_run"
JOB_STATUS_DONE		= "J_done"
JOB_STATUS_CANCEL	= "J_cancel"

-- ##### KLASSEN #####
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_G["KIObjekt"] = class(SLFObject, function(c)		-- Erbt aus dem Basic-Objekt des Frameworks
	SLFObject.init(c)	-- must init base!
end)
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_G["KIDataObjekt"] = class(SLFDataObject, function(c)	-- Erbt aus dem DataObjekt des Frameworks
	SLFDataObject.init(c)	-- must init base!
end)
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_G["AIPlayer"] = class(KIDataObjekt, function(c)
	KIDataObjekt.init(c)	-- must init base!
	--c.CurrentTask = nil
end)

function AIPlayer:typename()
	return "AIPlayer"
end

function AIPlayer:initialize()
	math.randomseed(TVT.GetMillisecs())

	self:initializePlayer()

	self.TaskList = {}
	self:initializeTasks()
end

function AIPlayer:initializePlayer()
	--Zum �berschreiben
end

function AIPlayer:initializeTasks()
	--Zum �berschreiben
end

function AIPlayer:ValidateRound()
	--Zum �berschreiben
end

function AIPlayer:Tick()
	self:TickAnalyse()

	if (self.CurrentTask == nil)  then
		self:BeginNewTask()
	else
		if self.CurrentTask.Status == TASK_STATUS_DONE or self.CurrentTask.Status == TASK_STATUS_CANCEL then
			self:BeginNewTask()
		else
			self.CurrentTask:Tick()
		end
	end
end

function AIPlayer:TickAnalyse()
	--Zum �berschreiben
end

function AIPlayer:BeginNewTask()
	--TODO: Warte-Task einf�gen, wenn sich ein Task wiederholt
	self.CurrentTask = self:SelectTask()
	if self.CurrentTask == nil then
		debugMsg("AIPlayer:BeginNewTask - task is nil... " )
	else
		self.CurrentTask:CallActivate()
		self.CurrentTask:StartNextJob()
	end
end

function AIPlayer:SelectTask()
	local BestPrio = -1
	local BestTask = nil

	for k,v in pairs(self.TaskList) do
		v:RecalcPriority()
		if (BestPrio < v.CurrentPriority) then
			BestPrio = v.CurrentPriority
			BestTask = v
		end
	end

	return BestTask
end

function AIPlayer:OnDayBegins()
	--Zum �berschreiben
end

function AIPlayer:OnReachRoom(roomId)
	self.CurrentTask:OnReachRoom(roomId)
end
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Ein Task repr�sentiert eine zu erledigende KI-Aufgabe die sich �blicherweise wiederholt. Diese kann wiederum aus verschiedenen Jobs bestehen
_G["AITask"] = class(KIDataObjekt, function(c)
	KIDataObjekt.init(c)	-- must init base!
	c.Id = nil -- Der eindeutige Name des Tasks
	c.Status = TASK_STATUS_OPEN -- Der Status der Aufgabe
	c.CurrentJob = nil -- Welcher Job wird aktuell bearbeitet und bei jedem Tick benachrichtigt
	c.BasePriority = 0 -- Grundlegende Priorit�t der Aufgabe (zwischen 1 und 10)
	c.SituationPriority = 0 -- Dieser Wert kann sich �ndern, wenn besondere Ereignisse auftreten, die von einer bestimmen Aufgabe eine h�here Priorit�t erfordert. �blicherweise zwischen 0 und 10. Hat aber kein Maximum
	c.CurrentPriority = 0 -- Berechnet: Aktuelle Priorit�t dieser Aufgabe
	c.LastDone = 0 -- Zeit, wann der Task zuletzt abgeschlossen wurde
	c.StartTask = 0 -- Zeit, wann der Task zuletzt gestartet wurde
	c.TickCounter = 0 -- Gibt die Anzahl der Ticks an seit dem der Task l�uft
	c.MaxTicks = 30 --Wie viele Ticks darf der Task maximal laufen?
	c.TargetRoom = -1 -- Wie lautet die ID des Standard-Zielraumes? !!! Muss �berschrieben werden !!!
	c.CurrentBudget = 0 -- Wie viel Geld steht der KI noch zur Verf�gung um diese Aufgabe zu erledigen.
	
	c.BudgetWholeDay = 0 -- Wie hoch war das Budget das die KI f�r diese Aufgabe an diesem Tag einkalkuliert hat.
	c.BudgetWeigth = 0 -- Wie viele Budgetanteile verlangt diese Aufgabe vom Gesamtbudget?
	
	c.InvestmentWeigth = 0 -- Wie viele Budgetanteile werden gespart
	c.InvestmentSavings = 0 -- Wie viel wurde bereits gespart?
	c.NeededInvestmentBudget = -1 -- Wie viel Geld ben�tigt die KI f�r eine Gro�investition
	c.UseInvestment = false
end)

function AITask:typename()
	return "AITask"
end

function AITask:getBudgetUnits()
	return self.BudgetWeigth + self.InvestmentWeigth
end

function AITask:PayFromBudget(value)
	if self.UseInvestment then
		self.InvestmentWeigthSum = 0
	end
	
	self.CurrentBudget = self.CurrentBudget - value
end

function AITask:resume()
	if self.InvalidDataObject then
		if self.Status == TASK_STATUS_PREPARE or self.Status == TASK_STATUS_RUN then
			infoMsg(type(self) .. ": InvalidDataObject resume => TASK_STATUS_OPEN")
			self.Status = TASK_STATUS_OPEN
		end
		self.InvalidDataObject = false
		table.removeKey(self, "InvalidDataObject");
	end
end

function AITask:CallActivate()
	self.MaxTicks = math.random(9, 17)
	self.TickCounter = 0
	self:Activate()
end

function AITask:Activate()
	debugMsg("Implementiere mich... " .. type(self))
end

function AITask:OnDayBegins()
	--kann �berschrieben werden
end

--Wird aufgerufen, wenn der Task zur Bearbeitung ausgewaehlt wurde (NICHT UEBERSCHREIBEN!)
function AITask:StartNextJob()
	--debugMsg("StartNextJob")
	local roomNumber = TVT.GetPlayerRoom()
	--debugMsg("Player-Raum: " .. roomNumber .. " - Target-Raum: " .. self.TargetRoom)
	if TVT.GetPlayerRoom() ~= self.TargetRoom then --sorgt daf�r, dass der Spieler in den richtigen Raum geht!
		self.Status = TASK_STATUS_PREPARE
		self.CurrentJob = self:getGotoJob()
	else
		self.Status = TASK_STATUS_RUN
		self.StartTask = WorldTime.GetTimeGone()
		self.CurrentJob = self:GetNextJobInTargetRoom()

		if (self.Status == TASK_STATUS_DONE) or (self.Status == TASK_STATUS_CANCEL) then
			return
		end
	end

	if self.CurrentJob ~= null then
		self.CurrentJob:Start()
	end
end

function AITask:Tick()
	if ((self.Status == TASK_STATUS_RUN) or (self.Status == TASK_STATUS_WAIT)) then
		self.TickCounter = self.TickCounter + 1
		--debugMsg("MaxTickCount: " .. self.TickCounter .. " > " .. self.MaxTicks)
		if (self.TickCounter > self.MaxTicks) then
			self:TooMuchTicks()
		end
	end

	if (self.Status == TASK_STATUS_RUN or (self.Status == TASK_STATUS_PREPARE)) then
		if (self.CurrentJob == nil) then
			--debugMsg("----- Kein Job da - Neuen Starten")
			self:StartNextJob() --Von vorne anfangen
		else
			if self.CurrentJob.Status == JOB_STATUS_CANCEL then
				self.CurrentJob = nil
				self:SetCancel()
				return
			elseif self.CurrentJob.Status == JOB_STATUS_DONE then
				self.CurrentJob = nil
				--debugMsg("----- Alter Job ist fertig - Neuen Starten")
				self:StartNextJob() --Von vorne anfangen
			else
				--debugMsg("----- Job-Tick")
				self.CurrentJob:CallTick() --Fortsetzen
			end
		end
	end
end

function AITask:GetNextJobInTargetRoom()
	--return self:getGotoJob()
	error("Muss noch implementiert werden")
end

function AITask:getGotoJob()
	local aJob = AIJobGoToRoom()
	aJob.Task = self
	aJob.TargetRoom = self.TargetRoom
	return aJob
end

function AITask:RecalcPriority()
	if (self.LastDone == 0) then self.LastDone = WorldTime.GetTimeGone() end

	local Ran1 = math.random(75, 125) / 100
	local TimeDiff = math.round(WorldTime.GetTimeGone() - self.LastDone)
	local player = _G["globalPlayer"]
	local requisitionPriority = player:GetRequisitionPriority(self.Id)

	local calcPriority = (self.BasePriority + self.SituationPriority) * Ran1 + requisitionPriority
	local timeFactor = (20 + TimeDiff) / 20

	self.CurrentPriority = calcPriority * timeFactor

	debugMsg("Task: " .. self:typename() .. " - Prio: " .. self.CurrentPriority .. " - TimeDiff:" .. TimeDiff .. " (c: " .. calcPriority .. ")")
end

function AITask:TooMuchTicks()
	debugMsg("<<< TooMuchTicks / Warten zuende!")
	self:SetDone()
end

function AITask:SetWait()
	debugMsg("<<< Task wait!")
	self.Status = TASK_STATUS_WAIT
end

function AITask:SetDone()
	debugMsg("<<< Task abgeschlossen!")
	self.Status = TASK_STATUS_DONE
	self.SituationPriority = 0
	self.LastDone = WorldTime.GetTimeGone()
end

function AITask:SetCancel()
	debugMsg("<<< Task abgebrochen!")
	self.Status = TASK_STATUS_CANCEL
	self.SituationPriority = self.SituationPriority / 2
end

function AITask:OnReachRoom(roomId)
	--debugMsg("OnReachRoom!")
	if (self.CurrentJob ~= nil) then
		self.CurrentJob:OnReachRoom(roomId)
	end
end

function AITask:BudgetSetup()
end

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_G["AIJob"] = class(KIDataObjekt, function(c)
	KIDataObjekt.init(c)	-- must init base!
	c.Id = ""
	c.Status = JOB_STATUS_NEW
	c.StartJob = 0
	c.LastCheck = 0
	c.Ticks = 0
	c.StartParams = nil
end)

function AIJob:typename()
	return "AIJob"
end

function AIJob:resume()
	if self.InvalidDataObject then
		if self.Status == JOB_STATUS_REDO or self.Status == JOB_STATUS_RUN then
			infoMsg(self:typename() .. ": InvalidDataObject resume => JOB_STATUS_NEW")
			self.Status = JOB_STATUS_NEW
		end
		self.InvalidDataObject = false
		table.removeKey(self, "InvalidDataObject");
	end
end

function AIJob:Start(pParams)
	self.StartParams = pParams
	self.StartJob = WorldTime.GetTimeGone()
	self.LastCheck = WorldTime.GetTimeGone()
	self.Ticks = 0
	self:Prepare(pParams)
end

function AIJob:Prepare(pParams)
	debugMsg("Implementiere mich: " .. type(self))
end

function AIJob:CallTick()
	self.Ticks = self.Ticks + 1
	self:Tick()
end

function AIJob:Tick()
	--Kann ueberschrieben werden
end

function AIJob:ReDoCheck(pWait)
	if ((self.LastCheck + pWait) < WorldTime.GetTimeGone()) then
		--debugMsg("ReDoCheck")
		self.Status = JOB_STATUS_REDO
		self.LastCheck = WorldTime.GetTimeGone()
		self:Prepare(self.StartParams)
	end
end

function AIJob:OnReachRoom(roomId)
	--Kann �berschrieben werden
end
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_G["AIJobGoToRoom"] = class(AIJob, function(c)
	AIJob.init(c)	-- must init base!
	c.Task = nil
	c.TargetRoom = 0
	c.IsWaiting = false
	c.WaitSince = -1
	c.WaitTill = -1
end)

function AIJobGoToRoom:typename()
	return "AIJobGoToRoom"
end

function AIJobGoToRoom:OnReachRoom(roomId)
	if (roomId == "-32" or roomId == -32) then --RESULT_INUSE
		if (self.IsWaiting) then
			debugMsg("Okay... aber nur noch 'n kleines bisschen...")
		elseif (self:ShouldIWait()) then
			debugMsg("Dann wart ich eben...")
			self.IsWaiting = true
			self.WaitSince = WorldTime.GetTimeGone()
			self.WaitTill = self.WaitSince + 3 + (self.Task.CurrentPriority / 6)
			if ((self.WaitTill - self.WaitSince) > 20) then
				self.WaitTill = self.WaitSince + 20
			end
			local rand = math.random(50, 75)
			debugMsg("Gehe etwas zur Seite: " .. rand)
			TVT.doGoToRelative(rand)
		else
			debugMsg("Ne ich warte nicht!")
			self.Status = JOB_STATUS_CANCEL
		end
	else
		--debugMsg("AIJobGoToRoom DONE!")
		self.Status = JOB_STATUS_DONE
	end
end

function AIJobGoToRoom:ShouldIWait()
	debugMsg("ShouldIWait Prio: " .. self.Task.CurrentPriority)
	if (self.Task.CurrentPriority >= 60) then
		return true
	elseif (self.Task.CurrentPriority >= 30) then
		local randVal = math.random(0, self.Task.CurrentPriority)
		if (randVal >= 20) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function AIJobGoToRoom:Prepare(pParams)
	if ((self.Status == JOB_STATUS_NEW) or (self.Status == TASK_STATUS_PREPARE) or (self.Status == JOB_STATUS_REDO)) then
		TVT.DoGoToRoom(self.TargetRoom)
		self.Status = JOB_STATUS_RUN
	end
end

function AIJobGoToRoom:Tick()
	if (self.IsWaiting) then
		--TODO: Einfach versuchen, wenn der Raum leer wurde
		if (TVT.isRoomUnused(self.TargetRoom) == 1) then
			debugMsg("Jetzt ist frei!")
			TVT.DoGoToRoom(self.TargetRoom)
		elseif ((self.WaitTill - WorldTime.GetTimeGone()) <= 0) then
			debugMsg("Ach... ich geh...")
			self.Status = JOB_STATUS_CANCEL
		end
	elseif (self.Status ~= JOB_STATUS_DONE) then
		self:ReDoCheck(10)
	end
end
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_G["StatisticEvaluator"] = class(SLFDataObject, function(c)
	SLFDataObject.init(c)	-- must init base!
	c.MinValue = -1
	c.AverageValue = -1
	c.MaxValue = -1

	c.MinValueTemp = 100000000000000
	c.AverageValueTemp = -1
	c.MaxValueTemp = -1

	c.TotalSum = 0
	c.Values = 0
end)

function StatisticEvaluator:typename()
	return "StatisticEvaluator"
end

function StatisticEvaluator:Adjust()
	self.MinValueTemp = 100000000000000
	self.AverageValueTemp = -1
	self.MaxValueTemp = -1
	self.Values = 0
end

function StatisticEvaluator:AddValue(value)
	self.Values = self.Values + 1

	if value < self.MinValueTemp then
		self.MinValue = value
		self.MinValueTemp = value
	end
	if value > self.MaxValueTemp then
		self.MaxValue = value
		self.MaxValueTemp = value
	end

	self.TotalSum = self.TotalSum + value
	self.AverageValueTemp = math.round(self.TotalSum / self.Values, 0)
	self.AverageValue = self.AverageValueTemp
end
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_G["Requisition"] = class(SLFDataObject, function(c)
	SLFDataObject.init(c)	-- must init base!
	c.TaskId = nil
	c.TaskOwnerId = nil
	c.Priority = 0 -- 10 = hoch 1 = gering
	c.Done = false
end)

function Requisition:typename()
	return "Requisition"
end

function Requisition:CheckActuality()
	return true
end

function Requisition:Complete()
	self.Done = true
end
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


function debugMsg(pMessage)
	if TVT.ME == 2 then --Nur Debugausgaben von Spieler 2
		--TVT.PrintOutDebug(pMessage)
		TVT.PrintOut(pMessage)
		--TVT.SendToChat(TVT.ME .. ": " .. pMessage)
	end
end

function infoMsg(pMessage)
	if TVT.ME == 2 then --Nur Debugausgaben von Spieler 2
		TVT.PrintOut(pMessage)
		--TVT.SendToChat(TVT.ME .. ": " .. pMessage)
	end
end

function CutFactor(factor, minValue, maxValue)
	if (factor > maxValue) then
		return maxValue
	elseif (factor < minValue) then
		return minValue
	else
		return factor
	end
end