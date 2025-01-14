local mod	= DBM:NewMod(1817, "DBM-Party-Legion", 11, 860)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17700 $"):sub(12, -3))
mod:SetCreatureID(114350)
mod:SetEncounterID(1965)
mod:SetZone()
mod:SetUsedIcons(8, 7)
--mod:SetHotfixNoticeRev(14922)
--mod.respawnTime = 30

mod.noNormal = true

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 227592 227779 228269 228334 227615 228991",
	"SPELL_CAST_SUCCESS 227628 227779 228269",
	"SPELL_AURA_APPLIED 227592 228261 228249 227644 227806",
	"SPELL_AURA_APPLIED_DOSE 227644 227806",
	"SPELL_AURA_REMOVED 227592 228261",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"
)

--Тень Медива https://ru.wowhead.com/npc=114350/тень-медива/эпохальный-журнал-сражений
local warnArcaneMissiles			= mod:NewStackAnnounce(227644, 1) --Пронзающие стрелы
local warnInfernoBolt				= mod:NewTargetAnnounce(227615, 3) --Инфернальная стрела
local warnFlameWreath				= mod:NewCastAnnounce(228269, 4) --Венец пламени
local warnFlameWreathTargets		= mod:NewTargetAnnounce(228269, 4) --Венец пламени
local warnFrostbite					= mod:NewTargetAnnounce(227592, 4) --Обморожение

local specWarnArcaneMissiles		= mod:NewSpecialWarningDefensive(227628, "Tank", nil, nil, 2, 2) --Пронзающие стрелы
local specWarnArcaneMissiles2		= mod:NewSpecialWarningStack(227644, nil, 2, nil, nil, 3, 6) --Пронзающие стрелы
local specWarnCeaselessWinter2		= mod:NewSpecialWarningStack(227779, nil, 2, nil, nil, 3, 5) --Бесконечная зима
local specWarnFrostbite				= mod:NewSpecialWarningInterrupt(227592, "HasInterrupt", nil, nil, 3, 3) --Обморожение
local specWarnInfernoBolt			= mod:NewSpecialWarningInterrupt(227615, "HasInterrupt", nil, nil, 1, 2) --Инфернальная стрела
local specWarnArcaneBolt			= mod:NewSpecialWarningInterrupt(228991, "HasInterrupt", nil, nil, 3, 3) --Чародейская стрела
local specWarnInfernoBoltMoveTo		= mod:NewSpecialWarningMoveTo(227615, nil, nil, nil, 1, 2) --Инфернальная стрела
local specWarnInfernoBoltMoveAway	= mod:NewSpecialWarningMoveAway(227615, nil, nil, nil, 1, 2) --Инфернальная стрела
local specWarnInfernoBoltNear		= mod:NewSpecialWarningClose(227615, nil, nil, nil, 1, 2) --Инфернальная стрела
local specWarnCeaselessWinter		= mod:NewSpecialWarningDontStand(227779, nil, nil, nil, 2, 3) --Бесконечная зима
local specWarnFlameWreath			= mod:NewSpecialWarningYouDontMove(228269, nil, nil, nil, 3, 6) --Венец пламени
local specWarnFlameWreath2			= mod:NewSpecialWarningDontMove(228269, nil, nil, nil, 2, 5) --Венец пламени
local specWarnFlameWreath3			= mod:NewSpecialWarningMoveAway(228269, nil, nil, nil, 3, 5) --Венец пламени
local specWarnFlameWreath4			= mod:NewSpecialWarningYouDefensive(228269, nil, nil, nil, 5, 6) --Венец пламени
local specWarnGuardiansImage		= mod:NewSpecialWarningSwitch(228334, "-Healer", nil, nil, 1, 2) --Проекция Хранителя

local timerSpecialCD				= mod:NewCDSpecialTimer(30)
local timerArcaneMissiles			= mod:NewTargetTimer(20, 227644, nil, nil, nil, 3, nil, DBM_CORE_TANK_ICON..DBM_CORE_DEADLY_ICON) --Пронзающие стрелы
local timerCeaselessWinter			= mod:NewBuffActiveTimer(20, 227779, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON) --Бесконечная зима
local timerFlameWreath				= mod:NewBuffActiveTimer(20, 228269, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON) --Венец пламени

local yellFlameWreath				= mod:NewYell(228261, nil, nil, nil, "YELL") --Венец пламени
local yellFlameWreath2				= mod:NewFadesYell(228261, nil, nil, nil, "YELL") --Венец пламени
local yellFrostbite					= mod:NewYellHelp(227592, nil, nil, nil, "YELL") --Обморожение

local countdownSpecial				= mod:NewCountdown(30, 228582)
local countdownCeaselessWinter		= mod:NewCountdownFades("Alt20", 227779, nil, nil, 5) --Бесконечная зима
local countdownFlameWreath			= mod:NewCountdownFades("Alt20", 228269, nil, nil, 5) --Венец пламени

mod:AddSetIconOption("SetIconOnWreath", 228261, true, false, {8, 7}) --Венец пламени

mod.vb.wreathIcon = 8
mod.vb.playersFrozen = 0
mod.vb.imagesActive = false
local frostBiteName, flameWreathName = DBM:GetSpellInfo(227592), DBM:GetSpellInfo(228261)

function mod:OnCombatStart(delay)
	self.vb.wreathIcon = 8
	self.vb.playersFrozen = 0
	self.vb.imagesActive = false
	timerSpecialCD:Start(32.9)
	countdownSpecial:Start(32.9)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 227592 and self:CheckInterruptFilter(args.sourceGUID, false, true) then --Обморожение
		specWarnFrostbite:Show()
		specWarnFrostbite:Play("kickcast")
	elseif spellId == 227615 and self:CheckInterruptFilter(args.sourceGUID, false, true) then --Инфернальная стрела
		specWarnInfernoBolt:Show()
		specWarnInfernoBolt:Play("kickcast")
	elseif spellId == 228991 and self:CheckInterruptFilter(args.sourceGUID, false, true) then --Чародейская стрела
		if self:AntiSpam(1, "ArcaneBolt") then
			specWarnArcaneBolt:Show()
			specWarnArcaneBolt:Play("kickcast")
		end
	elseif spellId == 227779 then --Бесконечная зима
		if not UnitIsDeadOrGhost("player") then
			specWarnCeaselessWinter:Show()
			specWarnCeaselessWinter:Play("keepjump")
		end
		timerSpecialCD:Start(32.5)
		countdownSpecial:Start(32.5)
	elseif spellId == 228269 then --Венец пламени
		warnFlameWreath:Show()
		if not UnitIsDeadOrGhost("player") then
			specWarnFlameWreath3:Show()
			specWarnFlameWreath3:Play("runaway")
		end
		timerSpecialCD:Start(31.5)
		countdownSpecial:Start(31.5)
	elseif spellId == 228334 then --Проекция Хранителя
		self.vb.imagesActive = true
		if not UnitIsDeadOrGhost("player") then
			specWarnGuardiansImage:Show()
			specWarnGuardiansImage:Play("mobkill")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 227779 then --Бесконечная зима
		timerCeaselessWinter:Start()
		countdownCeaselessWinter:Start()
	elseif spellId == 228269 then --Венец пламени
		timerFlameWreath:Start()
		countdownFlameWreath:Start()
	elseif spellId == 227628 then --Пронзающие стрелы
		specWarnArcaneMissiles:Show()
		specWarnArcaneMissiles:Play("defensive")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 227592 then --Обморожение
		self.vb.playersFrozen = self.vb.playersFrozen + 1
		if args:IsPlayer() then
			yellFrostbite:Yell()
		else
			warnFrostbite:Show(args.destName)
		end
	elseif spellId == 228261 then --Венец пламени
		self.vb.wreathIcon = self.vb.wreathIcon - 1
		warnFlameWreathTargets:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnFlameWreath:Show()
			specWarnFlameWreath:Play("dontmove")
			specWarnFlameWreath4:Schedule(2)
			specWarnFlameWreath4:ScheduleVoice(2, "defensive")
			yellFlameWreath:Yell()
			yellFlameWreath2:Countdown(20, 3)
		elseif self:AntiSpam(2, "flamewreath") then
			specWarnFlameWreath2:Show()
			specWarnFlameWreath2:Play("dontmove")
		end
		if self.Options.SetIconOnWreath then
			self:SetIcon(args.destName, self.vb.wreathIcon)
		end
	elseif spellId == 228249 then
		if args:IsPlayer() then
			if self.vb.playersFrozen == 0 then
				specWarnInfernoBoltMoveAway:Show()
				specWarnInfernoBoltMoveAway:Play("scatter")
			else
				specWarnInfernoBoltMoveTo:Show(frostBiteName)
				specWarnInfernoBoltMoveTo:Play("gather")
			end
		elseif self:CheckNearby(8, args.destName) and not UnitDebuff("player", frostBiteName) and not UnitDebuff("player", flameWreathName) then
			specWarnInfernoBoltNear:Show(args.destName)
			specWarnInfernoBoltNear:Play("scatter")
		else
			warnInfernoBolt:Show(args.destName)
		end
	elseif spellId == 227644 then --Пронзающие стрелы
		local amount = args.amount or 1
		warnArcaneMissiles:Show(args.destName, amount)
		timerArcaneMissiles:Start(args.destName)
		if self:IsHeroic() then
			if amount >= 3 then
				if args:IsPlayer() then
					specWarnArcaneMissiles2:Show(amount)
					specWarnArcaneMissiles2:Play("stackhigh")
				end
			end
		else
			if amount >= 2 then
				if args:IsPlayer() then
					specWarnArcaneMissiles2:Show(amount)
					specWarnArcaneMissiles2:Play("stackhigh")
				end
			end
		end
	elseif spellId == 227806 then --Бесконечная зима
		local amount = args.amount or 1
		if amount >= 3 and amount % 2 == 0 then
			if args:IsPlayer() then
				specWarnCeaselessWinter2:Show(amount)
				specWarnCeaselessWinter2:Play("stackhigh")
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 227592 then --Обморожение
		self.vb.playersFrozen = self.vb.playersFrozen - 1
	elseif spellId == 228261 then --Венец пламени
		self.vb.wreathIcon = self.vb.wreathIcon + 1
		if self.Options.SetIconOnWreath then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 227644 then --Пронзающие стрелы
		timerArcaneMissiles:Cancel(args.destName)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, bfaSpellId, _, legacySpellId)
	local spellId = legacySpellId or bfaSpellId
	if spellId == 228582 and self.vb.imagesActive then--Mana Regen
		self.vb.imagesActive = false
		timerSpecialCD:Start()
		countdownSpecial:Start()
	end
end
