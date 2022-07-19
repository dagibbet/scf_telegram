Config = {}

--LOCATIONS
--BLIPS
Config.postoffice = {
    { name = "Valentine", blip = 1475382911, coords = vector3(-178.90, 626.71, 114.09), radius = 1.0 },
    { name = "Blackwater", blip = 1475382911, coords = vector3(-875.1723, -1328.7574, 43.9580), radius = 1.0 },
    { name = "Saint Denis", blip = 1475382911, coords = vector3(2749.42, -1398.99, 46.23), radius = 1.0 },
	
	{name = 'Rhodes',           blip = 1475382911,          coords = vector3(1225.57, -1293.87, 76.9),   radius = 1.0},
    {name = 'Wallace',          blip = 1475382911,          coords = vector3(-1300.84, 399.29, 95.42),   radius = 1.0},
    {name = 'Riggs',            blip = 1475382911,          coords = vector3(-1095.31, -576.94, 82.4),   radius = 1.0},
    {name = 'Van Horn Trading',  blip = 1475382911,          coords = vector3(2986.42, 569.03, 44.67),   radius = 1.0},
    {name = 'Annesburg',         blip = 1475382911,          coords = vector3(2939.29, 1288.23, 44.65),   radius = 1.0},
    {name = 'Strawberry',        blip = 1475382911,      	coords = vector3(-1764.93, -384.45, 157.74), radius = 1.0},
    {name = 'Armadillo',         blip = 1475382911,          coords = vector3(-3733.68, -2597.89, -12.94),radius = 1.0},
	{name = 'Emerald Station',         blip = 1475382911,          coords = vector3(1521.97, 440.03, 90.73),radius = 1.0},
	
	{name = 'Sisika Penitentiary',         blip = 1475382911,          coords = vector3(3329.91, -693.79, 44.21),radius = 1.0},
}

Config.anonpostoffice = {
	{ name = "Valentine Sheriff Dept", coords = vector3(-278.72, 803.63, 119.43), radius = 1.0 },
	{ name = "Rhodes Sheriff Dept", coords = vector3(1362.03, -1303.56, 77.75), radius = 1.0 },
	{ name = "Strawberry Sheriff Dept", coords = vector3(-1812.57, -353.80, 165.33), radius = 1.0 },
	{ name = "Blackwater Sheriff Dept", coords = vector3(-762.65, -1271.98, 43.84), radius = 1.0 },
	{ name = "Armadillo Sheriff Dept", coords = vector3(-3624.31, -2601.64, -12.52), radius = 1.0 },
	{ name = "Tumbleweed Sheriff Dept", coords = vector3(-5530.41, -2929.62, -1.58), radius = 1.0 },
	{ name = "Saint Denis Sheriff Dept", coords = vector3(2507.48, -1300.98, 48.77), radius = 1.0 },
	{ name = "Annesburg Sheriff Dept", coords = vector3(2908.32, 1308.68, 43.94), radius = 1.0 },
}

--TRANSLATE
Config.post = "Post Office"
Config.OpenPost = "press"
Config.pdpost = "Tip Line"

--OPEN KEY
Config.keys = {
    G = 0x760A9C6F
}

-- CHARGE PER TELEGRAM SENT
Config.Pay = 0.50 --cents
