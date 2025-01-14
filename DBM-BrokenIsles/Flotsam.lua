local mod	= DBM:NewMod(1795, "DBM-BrokenIsles", nil, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17603 $"):sub(12, -3))
mod:SetCreatureID(99929)
mod:SetEncounterID(1951)
mod:SetReCombatTime(20)
mod:SetZone()
--mod:SetMinSyncRevision(11969)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 220340 223317 223373",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnYaksam				= mod:NewCastAnnounce(223373, 3) --Отрыжка
--local warnJetsam				= mod:NewTargetAnnounce(220295, 2) --Мусор

local specWarnGetsam			= mod:NewSpecialWarningDodge(220340, "-Tank", nil, nil, 1, 2) --Мусорка
local specWarnBreakSam			= mod:NewSpecialWarningSpell(223317, "Melee", nil, nil, 1, 2) --Мусоробой

local timerGetsamCD				= mod:NewCDTimer(53, 220340, nil, nil, nil, 5, nil, DBM_CORE_DEADLY_ICON) --Мусорка
local timerYaksamCD				= mod:NewCDTimer(50, 223373, nil, nil, nil, 1, nil, DBM_CORE_TANK_ICON) --50-55 Отрыжка

--mod:AddReadyCheckOption(37460, false)

--[[
function mod:JetsamTarget(targetname, uId)
	if not targetname then return end
	warnJetsam:Show(targetname)
end]]

--[[
function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end
--]]

function mod:OnCombatEnd()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 223317 then
		specWarnBreakSam:Show()
		specWarnBreakSam:Play("carefly")
	elseif spellId == 220340 then
		specWarnGetsam:Show()
		specWarnGetsam:Play("shockwave")
		timerGetsamCD:Start()
	elseif spellId == 223373 then
		warnYaksam:Show()
		timerYaksamCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, bfaSpellId, _, legacySpellId)
	local spellId = legacySpellId or bfaSpellId
	if spellId == 220295 and self:AntiSpam(4, 1) then---220277-Summon Jetsam Stalker/220295-Jetsam
	--	self:BossTargetScanner(99929, "JetsamTarget", 0.2, 5)
	end
end
