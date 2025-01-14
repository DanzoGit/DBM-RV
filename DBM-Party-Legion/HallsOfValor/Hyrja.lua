local mod	= DBM:NewMod(1486, "DBM-Party-Legion", 4, 721)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17742 $"):sub(12, -3))
mod:SetCreatureID(95833)
mod:SetEncounterID(1806)
mod:SetZone()
mod:SetUsedIcons(8, 7)
mod:SetReCombatTime(120, 5)
mod:RegisterCombat("combat")
mod:SetWipeTime(120)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 192158 192018 192307 200901 191976",
	"SPELL_CAST_SUCCESS 200901",
	"SPELL_AURA_APPLIED 192048 192133 192132",
	"SPELL_AURA_APPLIED_DOSE 192048 192133 192132",
	"SPELL_AURA_REMOVED 192048 192133 192132"
)

--Хирья https://ru.wowhead.com/npc=95833/хирья/эпохальный-журнал-сражений
local warnMysticEmpowermentHoly		= mod:NewStackAnnounce(192133, 4, nil, nil, 2) --Мистическое усиление: Свет
local warnMysticEmpowermentThunder	= mod:NewStackAnnounce(192132, 4, nil, nil, 2) --Мистическое усиление: гром
local warnExpelLight				= mod:NewTargetAnnounce(192048, 4) --Световое излучение
local warnArcingBolt				= mod:NewTargetAnnounce(191976, 3) --Дуговая молния

local specWarnShieldOfLight			= mod:NewSpecialWarningYouDefensive(192018, "Tank", nil, nil, 3, 3) --Щит Света
local specWarnSanctify				= mod:NewSpecialWarningDodge(192158, "Ranged", nil, nil, 2, 5) --Освящение
local specWarnSanctify2				= mod:NewSpecialWarningRun(192158, "Melee", nil, nil, 4, 6) --Освящение
local specWarnEyeofStorm			= mod:NewSpecialWarningMoveTo(200901, nil, nil, nil, 4, 3) --Око шторма
local specWarnEyeofStorm2			= mod:NewSpecialWarningDefensive(200901, nil, nil, nil, 3, 3) --Око шторма
local specWarnExpelLight			= mod:NewSpecialWarningYouMoveAway(192048, nil, nil, nil, 1, 3) --Световое излучение
local specWarnExpelLight2			= mod:NewSpecialWarningYouDefensive(192048, nil, nil, nil, 3, 5) --Световое излучение
local specWarnArcingBolt			= mod:NewSpecialWarningYouMoveAway(191976, nil, nil, nil, 1, 3) --Дуговая молния
local specWarnArcingBolt2			= mod:NewSpecialWarningYouDefensive(191976, nil, nil, nil, 3, 5) --Дуговая молния

local timerArcingBoltCD				= mod:NewCDTimer(28, 191976, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON) --Дуговая молния+++
local timerShieldOfLightCD			= mod:NewCDTimer(28, 192018, nil, "Tank", nil, 3, nil, DBM_CORE_TANK_ICON..DBM_CORE_DEADLY_ICON) --Щит Света 28-34
local timerExpelLightCD				= mod:NewCDTimer(24.5, 192048, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON) --Световое излучение+++
local timerSpecialCD				= mod:NewNextTimer(30, 200736, nil, nil, nil, 2, 143497, DBM_CORE_DEADLY_ICON) --Особый спелл

local yellExpelLight				= mod:NewYellMoveAway(192048, nil, nil, nil, "YELL") --Световое излучение
local yellExpelLight2				= mod:NewShortFadesYell(192048, nil, nil, nil, "YELL") --Световое излучение
local yellArcingBolt				= mod:NewYell(191976, nil, nil, nil, "YELL") --Дуговая молния

local countdownSpecial				= mod:NewCountdown(30, 200736, nil, nil, 5) --Особый спелл
local countdownShieldOfLight		= mod:NewCountdown("Alt27.5", 192018, "Tank", nil, 5) --Щит Света

mod:AddSetIconOption("SetIconOnExpelLight", 192048, true, false, {8}) --Световое излучение
mod:AddSetIconOption("SetIconOnArcingBolt", 191976, true, false, {7}) --Дуговая молния
mod:AddRangeFrameOption(8, 192048) --Световое излучение

mod.vb.ShieldCount = 0

local MEH = false
local MET = false
local firstpull = false
local meh2s = false
local met2s = false
local MurchalProshlyap1 = false
local MurchalProshlyap2 = false
local debugvars = { --debug
	["RunTime"] = {0}, --Время запуска
	["SpecialCounter"] = {0, 0, "Выбрать особенность"}, --Выбрать особенность
	["ArcingBoltCounter"] = {0, 0, "Дуговая молния"}, --Дуговая молния
	["ExpelLightCounter"] = {0, 0, "Световое излучение"}, --Световое излучение
	["ShieldofLightCounter"] = {0, 0, "Щит Света"} --Щит Света
}

local function debugTimers(counter)
	local CurrentTime = GetTime()
	if debugvars[counter][1] > 0 then
		debugvars[counter][1] = debugvars[counter][1] + 1
		DBM:Debug(debugvars[counter][3] .. " [" .. debugvars[counter][1] .. "] " .. CurrentTime - debugvars[counter][2])
	else
		debugvars[counter][1] = debugvars[counter][1] + 1
		DBM:Debug(debugvars[counter][3] .. " [" .. debugvars[counter][1] .. "] " .. CurrentTime - debugvars["RunTime"][1])
	end
	debugvars[counter][2] = CurrentTime
end

function mod:ArcingBoltTarget(targetname, uId) --Дуговая молния (✔)
	if not targetname then return end
	if targetname == UnitName("player") then
		if met2s then
			specWarnArcingBolt2:Show()
			specWarnArcingBolt2:Play("defensive")
			yellArcingBolt:Yell()
		else
			specWarnArcingBolt:Show()
			specWarnArcingBolt:Play("runout")
			yellArcingBolt:Yell()
		end
	else
		warnArcingBolt:Show(targetname)
	end
	if self.Options.SetIconOnArcingBolt then
		self:SetIcon(targetname, 7, 5)
	end
end

local function UpdateTimers(self)
	if MurchalProshlyap1 then
		--Щит Света--
		if self.vb.ShieldCount == 0 then
			timerShieldOfLightCD:Start(15.5)
			countdownShieldOfLight:Start(15.5)
		else
			timerShieldOfLightCD:Start(11.8)
			countdownShieldOfLight:Start(11.8)
		end
		--Дуговая молния--
		if timerArcingBoltCD:GetTime() < 12 and MET then
			timerArcingBoltCD:Cancel()
			timerArcingBoltCD:Start(12)
		end
		--Световое излучение--
		if timerExpelLightCD:GetTime() < 12 and MEH then
			timerExpelLightCD:Cancel()
			timerExpelLightCD:Start(12)
		end
	elseif MurchalProshlyap2 then
		--Щит Света--
		if self.vb.ShieldCount == 0 then
			timerShieldOfLightCD:Start(17)
			countdownShieldOfLight:Start(17)
		else
			timerShieldOfLightCD:Start(13.4)
			countdownShieldOfLight:Start(13.4)
		end
		--Дуговая молния--
		if timerArcingBoltCD:GetTime() < 13 and MET then
			timerArcingBoltCD:Cancel()
			timerArcingBoltCD:Start(13)
		end
		--Световое излучение--
		if timerExpelLightCD:GetTime() < 12 and MEH then
			timerExpelLightCD:Cancel()
			timerExpelLightCD:Start(12)
		end
	end
end

function mod:OnCombatStart(delay)
	for k, v in pairs(debugvars) do
		if type(v) == "table" then
			v[1] = 0
			if #v > 1 then
				v[2] = 0
			end
		end
	end
	debugvars["RunTime"][1] = GetTime()
	self.vb.ShieldCount = 0
	MEH = false
	MET = false
	firstpull = false
	meh2s = false
	met2s = false
	MurchalProshlyap1 = false
	MurchalProshlyap2 = false
	timerSpecialCD:Start(10.5)
	countdownSpecial:Start(10.5)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 192158 or spellId == 192307 then --Освящение

		debugTimers("SpecialCounter")

		MurchalProshlyap1 = true
		MurchalProshlyap2 = false
		if not UnitIsDeadOrGhost("player") then
			specWarnSanctify:Show()
			specWarnSanctify:Play("watchorb")
			specWarnSanctify2:Show()
			specWarnSanctify2:Play("watchorb")
		end
		if spellId == 192307 then
			timerSpecialCD:Start()
			countdownSpecial:Cancel()
			countdownSpecial:Start()
		end
		UpdateTimers(self)
	elseif spellId == 192018 then --Щит Света

		debugTimers("ShieldofLightCounter")

		self.vb.ShieldCount = self.vb.ShieldCount + 1
		specWarnShieldOfLight:Show()
		specWarnShieldOfLight:Play("defensive")
	elseif spellId == 200901 then --Око шторма

		debugTimers("SpecialCounter")

		MurchalProshlyap1 = false
		MurchalProshlyap2 = true
		if not UnitIsDeadOrGhost("player") then
			specWarnEyeofStorm:Show(args.sourceName)
			specWarnEyeofStorm:Play("findshelter")
		end
		timerSpecialCD:Start()
		countdownSpecial:Cancel()
		countdownSpecial:Start()
		UpdateTimers(self)
	elseif spellId == 191976 then --Дуговая молния

		debugTimers("ArcingBoltCounter")

		self:BossTargetScanner(args.sourceGUID, "ArcingBoltTarget", 0.1, 2)
		timerArcingBoltCD:Start(15)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 200901 then --Око шторма
		if not UnitIsDeadOrGhost("player") then
			specWarnEyeofStorm2:Show()
			specWarnEyeofStorm2:Play("defensive")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 192048 then --Световое излучение

		debugTimers("ExpelLightCounter")

		if not self:IsNormal() then
			if args:IsPlayer() then
				if meh2s then
					specWarnExpelLight2:Show()
					specWarnExpelLight2:Play("defensive")
					yellExpelLight:Yell()
					yellExpelLight2:Countdown(3)
				else
					specWarnExpelLight:Show()
					specWarnExpelLight:Play("runout")
					yellExpelLight:Yell()
					yellExpelLight2:Countdown(3)
				end
			else
				warnExpelLight:Show(args.destName)
			end
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
		if self.Options.SetIconOnExpelLight then
			self:SetIcon(args.destName, 8, 5)
		end
		timerExpelLightCD:Start()
	elseif spellId == 192133 then --Мистическое усиление: Свет
		local amount = args.amount or 1
		MEH = true
		if not firstpull then
			firstpull = true
		end
		if not self:IsNormal() then
			if amount == 1 then
				timerExpelLightCD:Start(2)
			elseif amount >= 2 then
				meh2s = true
			elseif amount < 2 then
				meh2s = false
			elseif amount >= 2 and amount % 2 == 0 then
				warnMysticEmpowermentHoly:Show(args.destName, amount)
			end
		end
	elseif spellId == 192132 then --Мистическое усиление: гром
		local amount = args.amount or 1
		MET = true
		if not firstpull then
			firstpull = true
		end
		if not self:IsNormal() then
			if amount == 1 then
				timerArcingBoltCD:Start(2.8)
			elseif amount >= 2 then
				met2s = true
			elseif amount < 2 then
				met2s = false
			elseif amount >= 2 and amount % 2 == 0 then
				warnMysticEmpowermentThunder:Show(args.destName, amount)
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 192048 then --Световое излучение
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 192133 then --Мистическое усиление: Свет
		timerExpelLightCD:Stop()
		MEH = false
	elseif spellId == 192132 then --Мистическое усиление: гром
		timerArcingBoltCD:Stop()
		MET = false
	end
end
