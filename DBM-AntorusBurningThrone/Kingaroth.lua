local mod	= DBM:NewMod(2004, "DBM-AntorusBurningThrone", nil, 946)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17742 $"):sub(12, -3))
mod:SetCreatureID(122578)
mod:SetEncounterID(2088)
mod:SetZone()
--mod:SetBossHPInfoToHighest()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)
mod:SetHotfixNoticeRev(17742)
mod:SetMinSyncRevision(17742)
mod:DisableIEEUCombatDetection()
mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 244312 254926 245807 252758 246692 246833 246516 257978 254919",
	"SPELL_CAST_SUCCESS 252758 246692 248214",
	"SPELL_AURA_APPLIED 254919 257978 246687 249680 246698 252760 249740",
	"SPELL_AURA_APPLIED_DOSE 254919 257978 249740",
	"SPELL_AURA_REMOVED 246687 249680 246516 246698 252760",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED",
	"RAID_BOSS_WHISPER",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4 boss5"
)

--Stage: Deployment
local warnOvercharge					= mod:NewStackAnnounce(249740, 4) --Перегрузка
local warnShatteringStrike				= mod:NewSpellAnnounce(248375, 2) --Разбивающий удар
local warnDiabolicBomb					= mod:NewSpellAnnounce(246779, 3, nil, nil, nil, nil, nil, 2) --Демоническая бомба
local warnReverberatingStrike			= mod:NewTargetAnnounce(254926, 3) --Гулкий удар
--Reavers (or empowered boss from reaver deaths)
local warnDecimation					= mod:NewTargetAnnounce(246687, 3) --Децимация (на 5 игроков)
local warnDecimation2					= mod:NewTargetAnnounce(249680, 3) --Резонансное истребление (на 5 игрока)
local warnDemolish						= mod:NewTargetAnnounce(246692, 4) --Разрушение (на 3 игрока)
local warnForgingStrike					= mod:NewStackAnnounce(244312, 2, nil, "Tank|Healer") --Прессование
--Stage: Deployment
--local specWarnGTFO					= mod:NewSpecialWarningGTFO(238028, nil, nil, nil, 1, 2)
local specWarnForgingStrike				= mod:NewSpecialWarningDefensive(244312, nil, nil, nil, 3, 6) --Прессование
local specWarnForgingStrike2			= mod:NewSpecialWarningStack(244312, nil, 2, nil, nil, 3, 6) --Прессование
local specWarnForgingStrikeOther		= mod:NewSpecialWarningTaunt(244312, nil, nil, nil, 3, 6) --Прессование
local specWarnReverberatingStrike		= mod:NewSpecialWarningYou(254926, nil, nil, nil, 1, 2) --Гулкий удар
local specWarnReverberatingStrikeNear	= mod:NewSpecialWarningClose(254926, nil, nil, nil, 1, 2) --Гулкий удар
local specWarnRuiner					= mod:NewSpecialWarningDodge(246840, nil, nil, nil, 3, 6) --Разрушитель
--Stage: Construction
local specWarnInitializing				= mod:NewSpecialWarningCount(246504, "Healer", nil, nil, 1, 6) --Инициализация
local specWarnInitializing2				= mod:NewSpecialWarningSwitchCount(246504, "-Healer", nil, nil, 1, 6) --Инициализация
--Reavers (or empowered boss from reaver deaths)
local specWarnDecimation				= mod:NewSpecialWarningYouMoveAway(246687, nil, nil, nil, 4, 5) --Децимация
local specWarnAnnihilation				= mod:NewSpecialWarningSoak(245807, nil, nil, nil, 2, 2) --Аннигиляция
local specWarnDemolish					= mod:NewSpecialWarningYouShare(246692, nil, nil, nil, 3, 5) --Разрушение
local specWarnDemolishOther				= mod:NewSpecialWarningMoveTo(246692, nil, nil, nil, 1, 2) --Разрушение

--Stage: Deployment
mod:AddTimerLine(BOSS)
local timerForgingStrikeCD				= mod:NewCDTimer(14.3, 244312, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON..DBM_CORE_DEADLY_ICON) --Прессование+
local timerReverberatingStrikeCD		= mod:NewCDCountTimer(30, 254926, nil, nil, nil, 3) --Гулкий удар+
local timerDiabolicBombCD				= mod:NewCDTimer(20, 246779, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON..DBM_CORE_HEALER_ICON) --Демоническая бомба+
local timerRuiner						= mod:NewCastTimer(6, 246840, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON) --Разрушитель+
local timerRuinerCD						= mod:NewCDCountTimer(30, 246840, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON) --Разрушитель+
--local timerShatteringStrikeCD			= mod:NewCDTimer(30, 248375, nil, nil, nil, 2) --Разбивающий удар
local timerApocProtocolCD				= mod:NewCDCountTimer(77.5, 246516, nil, nil, nil, 6, nil, DBM_CORE_HEALER_ICON) --Протокол Апокалипсис+
local timerApocProtocol					= mod:NewCastTimer(42.3, 246516, nil, nil, nil, 6, nil, DBM_CORE_HEALER_ICON) --Протокол Апокалипсис
--Stage: Construction
mod:AddTimerLine(DBM_ADDS)
local timerInitializing					= mod:NewCastTimer(30, 246504, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON..DBM_CORE_TANK_ICON) --Инициализация
local timerDecimationCD					= mod:NewCDTimer(10.9, 246687, nil, nil, nil, 3) --Децимация
local timerAnnihilationCD				= mod:NewCDTimer(15.4, 245807, nil, nil, nil, 3) --Аннигиляция
local timerDemolishCD					= mod:NewCDTimer(15.8, 246692, nil, nil, nil, 3) --Разрушение

local yellForgingStrike					= mod:NewYell(244312, nil, nil, nil, "YELL") --Прессование
local yellReverberatingStrike			= mod:NewYell(254926, nil, nil, nil, "YELL") --Гулкий удар
local yellDecimation					= mod:NewYell(246687, nil, nil, nil, "YELL") --Децимация
local yellDecimation2					= mod:NewShortFadesYell(246687, nil, nil, nil, "YELL") --Децимация
local yellDemolish						= mod:NewPosYell(246692, nil, nil, nil, "YELL") --Разрушение
local yellDemolishFades					= mod:NewIconFadesYell(246692, nil, nil, nil, "YELL") --Разрушение

local berserkTimer						= mod:NewBerserkTimer(600)

--Stage: Deployment
local countdownApocProtocol				= mod:NewCountdown(77.5, 246516, nil, nil, 5) --Протокол Апокалипсис
local countdownForgingStrike			= mod:NewCountdown("AltTwo14", 244312, "Tank", nil, 5) --Прессование
local countdownRuiner					= mod:NewCountdown("Alt29", 246840, nil, nil, 5) --Разрушитель
local countdownInitializing				= mod:NewCountdown("Alt30", 246504, nil, nil, 5) --Инициализация

mod:AddSetIconOption("SetIconOnDemolish", 246692, true, false, {3, 2, 1}) --Разрушение
mod:AddSetIconOption("SetIconOnDecimation", 246687, true, false, {8, 7, 6, 5, 4}) --Децимация
mod:AddBoolOption("InfoFrame", true)
mod:AddBoolOption("UseAddTime", true)
mod:AddRangeFrameOption(5, 254926) --Гулкий удар

mod.vb.apocProtocolCount = 0
mod.vb.ruinerCast = 0
mod.vb.forgingStrikeCast = 0
mod.vb.reverbStrikeCast = 0
mod.vb.apocProtoCount = 0
mod.vb.ruinerTimeLeft = 0
mod.vb.reverbTimeLeft = 0
mod.vb.forgingTimeLeft = 0
mod.vb.bombTimeLeft = 0
mod.vb.decimationIcon = 8

local ProshlyapMurchal = false
local DemolishTargets = {}
local playerName = DBM:GetMyPlayerInfo()

function mod:ForgingStrikeTarget(targetname, uId) --прошляпанное очко Мурчаля Прошляпенко ✔
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnForgingStrike:Show()
		specWarnForgingStrike:Play("defensive")
		yellForgingStrike:Yell()
	end
end
		
function mod:ReverberatingTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnReverberatingStrike:Show()
		specWarnReverberatingStrike:Play("targetyou")
		yellReverberatingStrike:Yell()
	elseif self:CheckNearby(7, targetname) then
		specWarnReverberatingStrikeNear:Show(targetname)
		specWarnReverberatingStrikeNear:Play("runaway")
	else
		warnReverberatingStrike:Show(targetname)
	end
end

local function warnDemolishTargets(self, spellId)
--	table.sort(DemolishTargets)
	warnDemolish:Show(table.concat(DemolishTargets, "<, >"))
	for i = 1, #DemolishTargets do
		--local icon = i == 1 and 6 or i == 2 and 4 or i == 3 and 3--Because I'm sure bigwigs will do something funky with icons
		local icon = i
		local name = DemolishTargets[i]
		if name == playerName then
			yellDemolish:Yell(icon, icon, icon)
			local _, _, _, _, _, _, expires = DBM:UnitDebuff("player", spellId)
			local remaining = expires-GetTime()
			yellDemolishFades:Countdown(remaining, nil, icon)
		end
		if self.Options.SetIconOnDemolish then
			self:SetIcon(name, icon)
		end
	end
	if not DBM:UnitDebuff("player", spellId) and not self:IsTank() then
		specWarnDemolishOther:Show(DBM_ALLY)
		specWarnDemolishOther:Play("gathershare")
	end
end

local demolishDebuff = DBM:GetSpellInfo(246692)
local updateInfoFrame
do
	local lines = {}
	local sortedLines = {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	updateInfoFrame = function()
		table.wipe(lines)
		table.wipe(sortedLines)
		--TODO, fel reaver construction status info
		if #DemolishTargets == 0 then--None found, hide infoframe because all broke
			DBM.InfoFrame:Hide()
		end
		for i = 1, #DemolishTargets do
			local name = DemolishTargets[i]
			addLine(name, i)
		end
		return lines, sortedLines
	end
end

--/run DBM:GetModByName("2004"):TestFunction(20)
function mod:TestFunction(time)
	timerForgingStrikeCD:AddTime(time, 1)
	timerDiabolicBombCD:AddTime(time)
	timerRuinerCD:AddTime(time, self.vb.ruinerCast+1)
	timerReverberatingStrikeCD:AddTime(time, 1)
end

function mod:OnCombatStart(delay)
	self.vb.apocProtocolCount = 0
	self.vb.ruinerCast = 0
	self.vb.forgingStrikeCast = 0
	self.vb.reverbStrikeCast = 0
	self.vb.apocProtoCount = 0
	self.vb.ruinerTimeLeft = 0
	self.vb.reverbTimeLeft = 0
	self.vb.forgingTimeLeft = 0
	self.vb.bombTimeLeft = 0
	self.vb.decimationIcon = 8
	table.wipe(DemolishTargets)
	berserkTimer:Start(-delay)
	if self:IsHeroic() then
		timerDiabolicBombCD:Start(14-delay) --Демоническая бомба было
		timerForgingStrikeCD:Start(7-delay, 1) --Прессование было 6
		countdownForgingStrike:Start(7-delay) --Прессование было 6
		timerApocProtocolCD:Start(35-delay, 1) --Протокол Апокалипсис было 31.8
		countdownApocProtocol:Start(35) --Протокол Апокалипсис было 31.8
		timerReverberatingStrikeCD:Start(14-delay, 1)--14-15
	elseif self:IsMythic() then
		timerDiabolicBombCD:Start(14.5-delay) --Демоническая бомба было 11
		timerForgingStrikeCD:Start(6-delay, 1) --Прессование было
		countdownForgingStrike:Start(7-delay) --Прессование было 6
		timerApocProtocolCD:Start(35-delay, 1) --Протокол Апокалипсис было 31.8
		countdownApocProtocol:Start(35) --Протокол Апокалипсис было 31.8
	else -- всё оригинал, кроме протокола
		timerDiabolicBombCD:Start(11-delay) --Демоническая бомба
		timerForgingStrikeCD:Start(6-delay, 1) --Прессование
		countdownForgingStrike:Start(6-delay) --Прессование
		timerApocProtocolCD:Start(35-delay, 1) --Протокол Апокалипсис +++
		countdownApocProtocol:Start(35) --Протокол Апокалипсис +++
	end
	timerRuinerCD:Start(26.1-delay, 1) --было 21.1
	countdownRuiner:Start(26.1-delay) --было 21.1
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(5)
	end
end

function mod:OnCombatEnd()
	timerReverberatingStrikeCD:Cancel()
	timerRuinerCD:Cancel()
	timerRuiner:Cancel()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 244312 or spellId == 257978 or spellId == 254919 then --Прессование
		self.vb.forgingStrikeCast = self.vb.forgingStrikeCast + 1
		self:BossTargetScanner(args.sourceGUID, "ForgingStrikeTarget", 0.1, 2)
		if self:IsMythic() then
			timerForgingStrikeCD:Start(14, self.vb.forgingStrikeCast+1)
			countdownForgingStrike:Start(14)
		elseif self:IsHeroic() then
			timerForgingStrikeCD:Start(14.4, self.vb.forgingStrikeCast+1)
			countdownForgingStrike:Start(14.4)
		else
			timerForgingStrikeCD:Start(14.6, self.vb.forgingStrikeCast+1)
			countdownForgingStrike:Start(14.6)
		end
	elseif spellId == 254926 or spellId == 257997 then --Гулкий удар
		self:BossTargetScanner(args.sourceGUID, "ReverberatingTarget", 0.1, 2)
		if self:AntiSpam(5, 3) then--Sometimes stutter casts
			self.vb.reverbStrikeCast = self.vb.reverbStrikeCast + 1
			timerReverberatingStrikeCD:Start(28, self.vb.reverbStrikeCast+1)--More work needed
		end
	elseif spellId == 245807 then --Аннигиляция
		if not UnitIsDeadOrGhost("player") then
			specWarnAnnihilation:Show()
			specWarnAnnihilation:Play("helpsoak")
		end
	elseif spellId == 252758 or spellId == 246692 then
		table.wipe(DemolishTargets)
	elseif spellId == 246833 then --Разрушитель
		self.vb.ruinerCast = self.vb.ruinerCast + 1
		timerForgingStrikeCD:Cancel()
		countdownForgingStrike:Cancel()
		if not UnitIsDeadOrGhost("player") then
			specWarnRuiner:Show()
			specWarnRuiner:Play("farfromline")
			specWarnRuiner:ScheduleVoice(1.5, "keepmove")
		end
		timerRuiner:Start(3)
		timerRuiner:Schedule(3)
		timerRuinerCD:Start(nil, self.vb.ruinerCast+1)--28-30 depending on difficulty
		countdownRuiner:Start(30)
		timerForgingStrikeCD:Start(10, self.vb.forgingStrikeCast+1)
		countdownForgingStrike:Start(10)
	elseif spellId == 246516 and self:IsInCombat() then --Протокол Апокалипсис
		self.vb.apocProtocolCount = self.vb.apocProtocolCount + 1
		ProshlyapMurchal = true
		self.vb.ruinerTimeLeft = timerRuinerCD:GetRemaining(self.vb.ruinerCast+1)
		self.vb.reverbTimeLeft = timerReverberatingStrikeCD:GetRemaining(self.vb.reverbStrikeCast+1)
		self.vb.forgingTimeLeft = timerForgingStrikeCD:GetRemaining(self.vb.forgingStrikeCast+1)
		self.vb.bombTimeLeft = timerDiabolicBombCD:GetRemaining()
		countdownForgingStrike:Cancel()
		countdownRuiner:Cancel()
		if self.Options.UseAddTime then
			timerDiabolicBombCD:AddTime(42.3) --Демоническая бомба
			timerRuinerCD:AddTime(43, self.vb.ruinerCast+1) --Разрушитель
			countdownRuiner:Start(self.vb.ruinerTimeLeft+43) --Разрушитель
			timerReverberatingStrikeCD:AddTime(51.3, self.vb.reverbStrikeCast+1) --гулкий удар
			timerForgingStrikeCD:AddTime(42.3, self.vb.forgingStrikeCast+1) --Прессование
			countdownForgingStrike:Start(self.vb.forgingTimeLeft+42.3) --Прессование
		else--times are stored in variables so can stop timers now
			timerForgingStrikeCD:Stop()
			timerReverberatingStrikeCD:Stop()
			timerRuinerCD:Stop()
			timerDiabolicBombCD:Stop()
		end
		--timerDiabolicBombCD:Stop()
		--timerShatteringStrikeCD:Stop()
		if not UnitIsDeadOrGhost("player") then
			if self:IsHealer() then
				specWarnInitializing:Show(self.vb.apocProtocolCount)
				specWarnInitializing:Play("healall")
			else
				specWarnInitializing2:Show(self.vb.apocProtocolCount)
				specWarnInitializing2:Play("mobkill")
			end
		end
		if self:IsLFR() then
			timerInitializing:Start(42.3)
			countdownInitializing:Start(42.3)
		elseif self:IsMythic() then
			timerApocProtocol:Start()
			timerInitializing:Start(32.3)
			countdownInitializing:Start(32.3)
			countdownApocProtocol:Start(42.3)
		else
			timerApocProtocol:Start()
			timerInitializing:Start(32.3)
			countdownInitializing:Start(32.3)
			countdownApocProtocol:Start(42.3)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 252758 or spellId == 246692 then
		timerDemolishCD:Start(nil, args.sourceGUID)
	elseif spellId == 248214 then
		warnDiabolicBomb:Show()
		warnDiabolicBomb:Play("bombsoon")
		timerDiabolicBombCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 254919 or spellId == 257978 then --Прессование
	--	local uId = DBM:GetRaidUnitId(args.destName)
	--	if uId and self:IsTanking(uId) then
		local amount = args.amount or 1
		if amount >= 2 then
			if args:IsPlayer() then
				specWarnForgingStrike2:Show(amount)
				specWarnForgingStrike2:Play("stackhigh")
			else
				local _, _, _, _, _, _, expireTime = DBM:UnitDebuff("player", spellId)
				local remaining
				if expireTime then
					remaining = expireTime-GetTime()
				end
				if not UnitIsDeadOrGhost("player") and (not remaining or remaining and remaining < 14) then
					specWarnForgingStrikeOther:Show(args.destName)
					specWarnForgingStrikeOther:Play("tauntboss")
				else
					warnForgingStrike:Show(args.destName, amount)
				end
			end
		else
			warnForgingStrike:Show(args.destName, amount)
		end
	elseif spellId == 246687 then --Децимация 1 (от моба)
		if args:IsPlayer() then
			specWarnDecimation:Schedule(5)
			specWarnDecimation:ScheduleVoice(5, "runaway")
			yellDecimation:Yell()
			yellDecimation2:Countdown(8.5, 3)
		else
			warnDecimation:CombinedShow(0.3, args.destName)
		end
		if self.Options.SetIconOnDecimation then
			self:SetIcon(args.destName, self.vb.decimationIcon, 9)
		end
		self.vb.decimationIcon = self.vb.decimationIcon - 1
	elseif spellId == 249680 then --Децимация 2 (от босса) 4.5 сек +5
		if args:IsPlayer() then
			specWarnDecimation:Schedule(5)
			specWarnDecimation:ScheduleVoice(5, "runaway")
			yellDecimation:Yell()
			yellDecimation2:Countdown(9, 3)
		else
			warnDecimation2:CombinedShow(0.3, args.destName)
		end
		if self.Options.SetIconOnDecimation then
			self:SetIcon(args.destName, self.vb.decimationIcon, 9)
		end
		self.vb.decimationIcon = self.vb.decimationIcon - 1
	elseif spellId == 246698 or spellId == 252760 then
		if not tContains(DemolishTargets, args.destName) then
			DemolishTargets[#DemolishTargets+1] = args.destName
		end
		self:Unschedule(warnDemolishTargets)
		--if #DemolishTargets == 3 then--(uncomment when upper camp known)
			--warnDemolishTargets(self, args.spellName)
		--else
			self:Schedule(0.8, warnDemolishTargets, self, spellId)--At least 0.8, maybe bigger needed if warning still splits
		--end
		if args:IsPlayer() then
			specWarnDemolish:Show()
			specWarnDemolish:Play("targetyou")
		end
		if self.Options.InfoFrame then
			if #DemolishTargets == 1 then
				DBM.InfoFrame:SetHeader(args.spellName)
				DBM.InfoFrame:Show(5, "function", updateInfoFrame, false, false, true)
			else
				DBM.InfoFrame:Update()
			end
		end
	elseif spellId == 249740 then --Перегрузка
		local amount = args.amount or 1
		if amount >= 1 then
			warnOvercharge:Show(args.destName, amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 246687 then --Децимация 1 (от моба)
		self.vb.decimationIcon = self.vb.decimationIcon + 1
		if args:IsPlayer() and not ProshlyapMurchal then
			specWarnDecimation:Cancel()
			specWarnDecimation:CancelVoice()
			yellDecimation2:Cancel()
		end
	elseif spellId == 249680 then --Децимация 2 (от босса)
		self.vb.decimationIcon = self.vb.decimationIcon + 1
	elseif spellId == 246516 and self:IsInCombat() then --Протокол Апокалипсис
		self.vb.apocProtoCount = self.vb.apocProtoCount + 1
		if self.vb.apocProtoCount % 2 == 1 then
			DBM:Debug("Reverb first", 2)
		else
			DBM:Debug("Ruiner first", 2)
		end
		if not self.Options.UseAddTime then
			--Restore timers with stored times
			if self.vb.ruinerTimeLeft > 0 then
				timerRuinerCD:Start(self.vb.ruinerTimeLeft, self.vb.ruinerCast+1)
				countdownRuiner:Start(self.vb.ruinerTimeLeft)
			end
			if self.vb.reverbTimeLeft > 0 then
				timerReverberatingStrikeCD:Start(self.vb.reverbTimeLeft-1, self.vb.reverbStrikeCast+1)
			end
			if self.vb.forgingTimeLeft > 0 then
				timerForgingStrikeCD:Start(self.vb.forgingTimeLeft, self.vb.forgingStrikeCast+1)
				countdownForgingStrike:Start(self.vb.forgingTimeLeft)
			end
			if self.vb.bombTimeLeft > 0 then
				timerDiabolicBombCD:Start(self.vb.bombTimeLeft)
			end
		end
		--timerDiabolicBombCD:Start(2)
		--timerShatteringStrikeCD:Start(42)
		timerApocProtocolCD:Start(77.5, self.vb.apocProtoCount+1)--77
		countdownApocProtocol:Start(77.5)
	elseif spellId == 246698 or spellId == 252760 then
		tDeleteItem(DemolishTargets, args.destName)
		if args:IsPlayer() then
			yellDemolishFades:Cancel()
		end
		if self.Options.SetIconOnDemolish then
			self:RemoveIcon(args.destName)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 228007 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show()
		specWarnGTFO:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
--]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 127235 then --Уничтожитель Кин'гарота
		timerDemolishCD:Stop(args.destGUID)
	elseif cid == 127231 then --Крушитель Кин'гарота
		ProshlyapMurchal = false
		timerDecimationCD:Stop(args.destGUID)
	elseif cid == 127230 then --Аннигилятор Кин'гарота
		timerAnnihilationCD:Stop(args.destGUID)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, bfaSpellId, _, legacySpellId)
	local spellId = legacySpellId or bfaSpellId
	if spellId == 248319 then--Consume Energy 100% (reaver fully charged and activated)
		--Info Frame usage situation?
	elseif spellId == 246686 then--Decimation (ignore 246691 I'm pretty sure)
		--specWarnDecimation:Show()
		--specWarnDecimation:Play("scatter")
		timerDecimationCD:Start(nil, UnitGUID(uId))
	elseif spellId == 246657 and self:AntiSpam(2, 1) then--Annihilation
		if not UnitIsDeadOrGhost("player") then
			specWarnAnnihilation:Show()
			specWarnAnnihilation:Play("helpsoak")
		end
		timerAnnihilationCD:Start(nil, UnitGUID(uId))
	elseif spellId == 248375 and self:AntiSpam(5, 2) then--Shattering Strike
		warnShatteringStrike:Show()
		--timerShatteringStrikeCD:Start()
	end
end
