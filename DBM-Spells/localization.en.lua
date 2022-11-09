local L

--Прошляпанное очко Мурчаля ✔✔

------------
-- Spells --
------------
L= DBM:GetModLocalization("Spells")

L:SetGeneralLocalization({
	name = "Raid Spells"
})

L:SetOptionLocalization({
	YellOnHeroism = "Announce when someone is casting a spell $spell:32182 or equivalent",
	YellOnResurrect = "Announce when someone has been subjected to $spell:20484 or equivalent",
	YellOnPortal = "Announce when someone opens $spell:224871 or equivalent",
	YellOnSoulwell = "Announce when someone is casting a spell $spell:29893",
	YellOnSoulstone = "Announce when someone has been subjected to $spell:20707",
	YellOnRitualofSummoning = "Announce when someone is casting a spell $spell:698",
	YellOnSpiritCauldron = "Announce when someone puts $spell:188036",
	YellOnLavish = "Announce when someone puts $spell:201352 or equivalent",
	YellOnRepair = "Announce when someone puts $spell:199109 or equivalent",
	YellOnPylon = "Announce when someone puts $spell:199115"
})

L:SetMiscLocalization{
	HeroismYell = "%s %s uses %s!",
	PortalYell = "%s %s opens %s!",
	SoulwellYell = "%s %s puts %s!",
	SoulstoneYell = "%s %s applies %s to %s!",
	SummoningYell = "%s %s begins %s!"
}
