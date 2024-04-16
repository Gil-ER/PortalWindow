local addon, ns = ...



ns.garHearth = { ["icon"] = 1041860, ["id"] = 110560, ["itemType"] = "toy", 
					["name"] = "Garrison Hearthstone", ["command"] = "Garrison Hearthstone" };
ns.dalHearth = { ["icon"] = 1444943, ["id"] = 140192, ["itemType"] = "toy", 
					["name"] = "Dalaran Hearthstone", ["command"] = "Dalaran Hearthstone" };
ns.rndHearth = { ["icon"] = 134414, ["id"] = 6948, ["itemType"] = "toy", 
					["name"] = "Hearthstone", ["command"] = "Hearthstone" };	
					
					
ns.ports = {
	{"Cataclysm", "Mist of Pandaria", "Warlords Of Draenor", "Legion", "Battle for Azeroth", 
		"Shadowlands", "Dragonflight"},
	{"Cata", "Mist", "WoD", "Legion", "BfA", "Shadowlands", "Dragonflight"}
}						
ns.Cata = {
	{ ["id"] = 410080, ["name"] = "The Vortex Pinnacle" },
	{ ["id"] = 424142, ["name"] = "Throne of the Tides" },
}
ns.Mist = {
	{ ["id"] = 131204, ["name"] = "Temple of the Jade Serpent" },
	{ ["id"] = 131205, ["name"] = "Stormstout Brewery" },
	{ ["id"] = 131206, ["name"] = "Shado-Pan Monastery" },
	{ ["id"] = 131222, ["name"] = "Mogu'shan Palace" },
	{ ["id"] = 131225, ["name"] = "Gate of the Setting Sun" },
	{ ["id"] = 131231, ["name"] = "Scarlet Halls" },
	{ ["id"] = 131229, ["name"] = "Scarlet Monastery" },
	{ ["id"] = 131232, ["name"] = "Scholomance" },
	{ ["id"] = 131228, ["name"] = "Siege of Niuzao Temple" },
}
ns.WoD = {
	{ ["id"] = 159896, ["name"] = "Bloodmaul Slag Mines" },
	{ ["id"] = 159900, ["name"] = "Grimrail Depot" },
	{ ["id"] = 159899, ["name"] = "Shadowmoon Burial Grounds" },
	{ ["id"] = 159901, ["name"] = "The Everbloom" },
}
ns.Legion = {
	{ ["id"] = 373262, ["name"] = "Karazhan" },
	{ ["id"] = 393764, ["name"] = "Halls of Valor" },
	{ ["id"] = 393766, ["name"] = "Court of Stars" },
	{ ["id"] = 424163, ["name"] = "Darkheart Thicket" },
	{ ["id"] = 424153, ["name"] = "Black Rook Hold" },
	{ ["id"] = 410078, ["name"] = "Neltharion's Lair" },
}
ns.BfA = {
	{ ["id"] = 373274, ["name"] = "Operation: Mechagon" },
	{ ["id"] = 424167, ["name"] = "Waycrest Manor" },
	{ ["id"] = 424187, ["name"] = "Atal'Dazar" },
	{ ["id"] = 410074, ["name"] = "The Underrot" },
}
ns.Shadowlands = {
	{ ["id"] = 354468, ["name"] = "De Other Side" },
	{ ["id"] = 354465, ["name"] = "Halls of Atonement" },
	{ ["id"] = 354464, ["name"] = "Mists of Tirna Scithe" },
	{ ["id"] = 354463, ["name"] = "Plaguefall" },
	{ ["id"] = 354466, ["name"] = "Spires of Ascension" },
	{ ["id"] = 354462, ["name"] = "The Necrotic Wake" },
	{ ["id"] = 354467, ["name"] = "Theater of Pain" },
	{ ["id"] = 354469, ["name"] = "Sanguine Depths" },
	{ ["id"] = 367416, ["name"] = "Tazavesh, the Veiled" },
}
ns.Dragonflight = {
	{ ["id"] = 393273, ["name"] = "Algeth'ar Academy" },
	{ ["id"] = 393283, ["name"] = "Halls of Infusion" },
	{ ["id"] = 393256, ["name"] = "Ruby Life Pools" },
	{ ["id"] = 393262, ["name"] = "The Nokhud Offensive" },
	{ ["id"] = 393267, ["name"] = "Brackenhide Hollow" },
	{ ["id"] = 393276, ["name"] = "Neltharus" },
	{ ["id"] = 393279, ["name"] = "The Azure Vault" },
	{ ["id"] = 393222, ["name"] = "Uldaman: Legacy of Tyr" },
	{ ["id"] = 424197, ["name"] = "Dawn of the Infinite" },
}





