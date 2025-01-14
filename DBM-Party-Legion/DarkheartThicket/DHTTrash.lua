local mod	= DBM:NewMod("DHTTrash", "DBM-Party-Legion", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17700 $"):sub(12, -3))
--mod:SetModelID(47785)
mod:SetZone()

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 201226 200580 200630 200768 201399 200658",
	"SPELL_CAST_SUCCESS 201272",
	"SPELL_SUMMON 198910",
	"SPELL_AURA_APPLIED 204243 225568 198904 200684 200642",
	"SPELL_AURA_APPLIED_DOSE 200642",
	"SPELL_AURA_REMOVED 225568 198904 200684",
	"SPELL_PERIODIC_DAMAGE 200822 198408",
	"SPELL_PERIODIC_MISSED 200822 198408"
)

--Треш Чащи Темного Сердца
local warnNightmareToxin				= mod:NewTargetAnnounce(200684, 3) --Ядовитый кошмар
local warnCurseofIsolation				= mod:NewTargetAnnounce(225568, 3) --Проклятие уединения
local warnPoisonSpear					= mod:NewTargetAnnounce(198904, 3) --Отравленное копье
local warnUnnervingScreech				= mod:NewCastAnnounce(200630, 4) --Ошеломляющий визг
local warnDreadInferno					= mod:NewCastAnnounce(201399, 4) --Жуткое пекло
local warnStarShower					= mod:NewCastAnnounce(200658, 4) --Звездный дождь

local specWarnStarShower				= mod:NewSpecialWarningInterrupt(200658, "HasInterrupt", nil, nil, 1, 3) --Звездный дождь
local specWarnNightfall					= mod:NewSpecialWarningYouMove(198408, nil, nil, nil, 1, 2) --Сумерки
local specWarnDespair					= mod:NewSpecialWarningStack(200642, nil, 5, nil, nil, 1, 2) --Отчаяние
local specWarnNightmareToxin			= mod:NewSpecialWarningYouMoveAway(200684, nil, nil, nil, 3, 6) --Ядовитый кошмар
local specWarnNightmareToxin2			= mod:NewSpecialWarningYouDispel(200684, nil, nil, nil, 3, 6) --Ядовитый кошмар
local specWarnPropellingCharge			= mod:NewSpecialWarningDodge(200768, nil, nil, nil, 2, 3) --Рывок вперед
local specWarnCurseofIsolation2			= mod:NewSpecialWarningYou(225568, nil, nil, nil, 2, 3) --Проклятие уединения
local specWarnCurseofIsolation3			= mod:NewSpecialWarningYouDispel(225568, "CurseDispeller", nil, nil, 2, 3) --Проклятие уединения
local specWarnCurseofIsolation			= mod:NewSpecialWarningDispel(225568, "CurseDispeller", nil, nil, 1, 3) --Проклятие уединения
local specWarnPoisonSpear2				= mod:NewSpecialWarningYou(198904, nil, nil, nil, 2, 3) --Отравленное копье
local specWarnPoisonSpear3				= mod:NewSpecialWarningYouDispel(198904, "PoisonDispeller", nil, nil, 2, 3) --Отравленное копье
--local specWarnPoisonSpear				= mod:NewSpecialWarningDispel(198904, "PoisonDispeller", nil, nil, 1, 3) --Отравленное копье
--
local specWarnVileMushroom				= mod:NewSpecialWarningDodge(198910, nil, nil, nil, 2, 2) --Злогриб
local specWarnBloodBomb					= mod:NewSpecialWarningDodge(201272, nil, nil, nil, 2, 2) --Кровавая бомба
local specWarnBloodAssault				= mod:NewSpecialWarningDodge(201226, nil, nil, nil, 2, 2) --Кровавая атака
local specWarnMaddeningRoar				= mod:NewSpecialWarningDefensive(200580, nil, nil, nil, 3, 5) --Безумный рев
local specWarnRottingEarth				= mod:NewSpecialWarningYouMove(200822, nil, nil, nil, 1, 2) --Гниющая земля
local specWarnTormentingEye				= mod:NewSpecialWarningInterrupt(204243, "HasInterrupt", nil, nil, 1, 2) --Истязающий глаз
local specWarnUnnervingScreech			= mod:NewSpecialWarningInterrupt(200630, "HasInterrupt", nil, nil, 1, 2) --Ошеломляющий визг

local timerCurseofIsolation				= mod:NewTargetTimer(12, 225568, nil, "Tank|CurseDispeller", nil, 3, nil, DBM_CORE_CURSE_ICON..DBM_CORE_HEALER_ICON) --Проклятие уединения
local timerVileMushroomCD				= mod:NewCDTimer(14, 198910, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON) --Злогриб

local yellNightmareToxin				= mod:NewYellMoveAway(200684, nil, nil, nil, "YELL") --Ядовитый кошмар
--local yellNightmareToxin2				= mod:NewFadesYell(200684, nil, nil, nil, "YELL") --Ядовитый кошмар
local yellCurseofIsolation				= mod:NewYell(225568, nil, nil, nil, "YELL") --Проклятие уединения
local yellPoisonSpear					= mod:NewYell(198904, nil, nil, nil, "YELL") --Отравленное копье

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 201226 and self:AntiSpam(2, 1) then --Кровавая атака
		if not self:IsNormal() then
			specWarnBloodAssault:Show()
			specWarnBloodAssault:Play("chargemove")
		end
	elseif spellId == 200580 and self:AntiSpam(2, "maddeningroar") then --Безумный рев
		if not self:IsNormal() then
			specWarnMaddeningRoar:Show()
			specWarnMaddeningRoar:Play("defensive")
		end
	elseif spellId == 200630 then --Ошеломляющий визг
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnUnnervingScreech:Show()
			specWarnUnnervingScreech:Play("kickcast")
		else
			warnUnnervingScreech:Show()
			warnUnnervingScreech:Play("kickcast")
		end
	elseif spellId == 200768 and self:AntiSpam(2, "propellingcharge") then --Рывок вперед
		specWarnPropellingCharge:Show()
		specWarnPropellingCharge:Play("watchstep")
	elseif spellId == 201399 and self:AntiSpam(2, "dreadinferno") then --Жуткое пекло
		if not self:IsNormal() then
			warnDreadInferno:Show()
			warnDreadInferno:Play("kickcast")
		end
	elseif spellId == 200658 and self:AntiSpam(2, "starshower") then --Звездный дождь
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnStarShower:Show()
			specWarnStarShower:Play("kickcast")
		else
			warnStarShower:Show()
			warnStarShower:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 201272 and self:AntiSpam(2, 3) then --Кровавая бомба
		specWarnBloodBomb:Show()
		specWarnBloodBomb:Play("watchstep")
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 198910 then --Злогриб
		if not self:IsNormal() then
			if self:AntiSpam(2, 4) then
				specWarnVileMushroom:Show()
				specWarnVileMushroom:Play("watchstep")
			end
			timerVileMushroomCD:Start(args.sourceGUID)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 204243 and self:AntiSpam(2, 5) then --Истязающий глаз
		if not self:IsNormal() then
			specWarnTormentingEye:Show()
			specWarnTormentingEye:Play("kickcast")
		end
	elseif spellId == 225568 then --Проклятие уединения
		timerCurseofIsolation:Start(args.destName)
		if not self:IsNormal() then
			if args:IsPlayer() and not self:IsCurseDispeller() and self:AntiSpam(2, "curseofisolation") then
				specWarnCurseofIsolation2:Show()
				specWarnCurseofIsolation2:Play("watchstep")
				yellCurseofIsolation:Yell()
			elseif args:IsPlayer() and self:IsCurseDispeller() and self:AntiSpam(2, "curseofisolation") then
				specWarnCurseofIsolation3:Show()
				specWarnCurseofIsolation3:Play("dispelnow")
				yellCurseofIsolation:Yell()
			elseif self:IsCurseDispeller() then
				if not UnitIsDeadOrGhost("player") then
					specWarnCurseofIsolation:CombinedShow(0.5, args.destName)
					specWarnCurseofIsolation:ScheduleVoice(0.5, "dispelnow")
				end
			else
				warnCurseofIsolation:CombinedShow(0.5, args.destName)
			end
		end
	elseif spellId == 198904 then --Отравленное копье
		if not self:IsNormal() then
			if args:IsPlayer() and not self:IsPoisonDispeller() and self:AntiSpam(2, "poisonspear") then
				specWarnPoisonSpear2:Show()
				specWarnPoisonSpear2:Play("defensive")
				yellPoisonSpear:Yell()
			elseif args:IsPlayer() and self:IsPoisonDispeller() and self:AntiSpam(2, "poisonspear") then
				specWarnPoisonSpear3:Show()
				specWarnPoisonSpear3:Play("dispelnow")
				yellPoisonSpear:Yell()
			else
				warnPoisonSpear:CombinedShow(0.5, args.destName)
			end
		end
	elseif spellId == 200684 then --Ядовитый кошмар (с новым прошляпом Прошляпенко)
		if not self:IsNormal() then
			if args:IsPlayer() and not self:IsPoisonDispeller() and self:AntiSpam(2, "nightmaretoxin") then
				specWarnNightmareToxin:Show()
				specWarnNightmareToxin:Play("runaway")
				yellNightmareToxin:Yell()
			elseif args:IsPlayer() and self:IsPoisonDispeller() and self:AntiSpam(2, "nightmaretoxin") then
				specWarnNightmareToxin2:Show()
				specWarnNightmareToxin2:Play("dispelnow")
				yellNightmareToxin:Yell()
			else
				warnNightmareToxin:CombinedShow(0.5, args.destName)
			end
		end
	elseif spellId == 200642 then --Отчаяние
		local amount = args.amount or 1
		if args:IsPlayer() and amount >= 5 and amount % 5 == 0 then
			specWarnDespair:Show(amount)
			specWarnDespair:Play("stackhigh")
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 225568 then --Проклятие уединения
		timerCurseofIsolation:Cancel(args.destName)
--[[	elseif spellId == 200684 then --Ядовитый кошмар
		if args:IsPlayer() then
			yellNightmareToxin2:Cancel()
		end]]
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 200822 and destGUID == UnitGUID("player") and self:AntiSpam(2, "rottingearth") then
		if not self:IsNormal() then
			specWarnRottingEarth:Show()
			specWarnRottingEarth:Play("runaway")
		end
	elseif spellId == 198408 and destGUID == UnitGUID("player") and self:AntiSpam(2, "nightfall") then --Сумерки
		if not self:IsNormal() then
			specWarnNightfall:Show()
			specWarnNightfall:Play("runaway")
		end
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
