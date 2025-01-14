local mod	= DBM:NewMod("TrialofValorTrash", "DBM-TrialofValor")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 17204 $"):sub(12, -3))
--mod:SetModelID(47785)
mod:SetZone()
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 228845 228371 228395",
	"CHAT_MSG_MONSTER_SAY"
)

local specWarnShatterboneShield		= mod:NewSpecialWarningReflect(228845, nil, nil, nil, 1, 2)
local specWarnBreathOfDread			= mod:NewSpecialWarningMove(228371, nil, nil, nil, 1, 2)
local specWarnBindSpirit			= mod:NewSpecialWarningDispel(228395, "MagicDispeller2", nil, nil, 1, 2)

local timerRoleplay					= mod:NewTimer(49.5, "timerRoleplay", "Interface\\Icons\\Spell_Holy_BorrowedTime", nil, nil, 7)

local countdownRoleplay				= mod:NewCountdown(49.5, 91344, nil, nil, 5)

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 228845 and self:AntiSpam(3, 1) then
		specWarnShatterboneShield:Show(args.destName)
		specWarnShatterboneShield:Play("stopattack")
	elseif spellId == 228371 and args:IsPlayer() and self:AntiSpam(2.5, 1) then
		specWarnBreathOfDread:Show(args.destName)
		specWarnBreathOfDread:Play("runaway")
	elseif spellId == 228395 and self:AntiSpam(2.5, 2) then
		specWarnBindSpirit:CombinedShow(0.5, args.destName)
		specWarnBindSpirit:Play("dispelnow")
	end
end

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if msg == L.RP1 then
		self:SendSync("RP1")
	end
end

function mod:OnSync(msg)
	if msg == "RP1" then
		timerRoleplay:Start()
		countdownRoleplay:Start()
	end
end
