-- This file contains all pieces of universal state for the game.
-- In as much is possible, these should be divorced from disparate object states

-- TODO battle data do here?
-- TODO: put "boardzone" 
-- TODO: botFightZoneGUID = "9f0b03"
-- TODO: topFightZoneGUID = "839de2"
-- topFightTile = getObjectFromGUID("3d4d0d")
-- botFightTile = getObjectFromGUID("d96e1d")
-- topFightTile.registerCollisions(false)
-- botFightTile.registerCollisions(false)
-- topFightTile.interactable = false
-- botFightTile.interactable = false
-- unitsPositions = {}

-- updateAllConteinerAmounts this is setup and can go here too
-- setupBattlePanelsUI is setup and can go here
-- drawAllGarbageZoneBorders
-- getObjectFromGUID(diceWallIDs[1]).setPosition({-40.6, 6, 0})
-- getObjectFromGUID(diceWallIDs[2]).setPosition({-32.3, 6, 0.22})
-- getObjectFromGUID(diceWallIDs[3]).setPosition({-24, 6, 0})
-- lowerDiceWalls TODO: see if there is a better way to do bounding than this

-- This piece of state is where we store dice objects that have been randomized
-- every game frame these objects are checked and if they are no longer in a rolling state they are removed
rollingDices = {}

-- This table is a repository of plastic units and their stats from the faction boards
-- unit name => owning faction, dice, moarle, bag objects reference guid, if the unit is reinforcable and where, and HP
-- TODO: make sure it wouldn't mess anything up to change the order so that reinforcement is last for ease of reading
unitsData = {
    ["Onslaught Attack Ship"]   = {faction="oz", dices=1, morale=2, bagGUID = "7ece2b", reinf = "space", hp = 3},
    ["Ork Boyz"]                = {faction="oz", dices=2, morale=1, bagGUID = "6c4efd", reinf = "planet", hp = 2},
    ["Nob"]                     = {faction="oz", dices=2, morale=2, bagGUID = "b8e6b9", hp = 4},
    ["Kill Kroozer"]            = {faction="oz", dices=3, morale=4, bagGUID = "5ab3e3", hp = 6},
    ["Battlewagons"]            = {faction="oz", dices=3, morale=2, bagGUID = "32f862", hp = 5},
    ["Gargant"]                 = {faction="oz", dices=3, morale=3, bagGUID = "cab63c", hp = 6},
    ["Orks Bastion"]            = {faction="oz", dices=2, morale=2, bagGUID = "bbcfb4", hp = 3},
    ["Cultist"]                 = {faction="ch", dices=1, morale=2, bagGUID = "aa302c", reinf = "planet", hp = 2},
    ["Chaos Space Marine"]      = {faction="ch", dices=3, morale=2, bagGUID = "e3f272", hp = 3},
    ["Iconoclast Destroyer"]    = {faction="ch", dices=2, morale=2, bagGUID = "14836a", reinf = "space", hp = 2},
    ["Helbrute"]                = {faction="ch", dices=3, morale=3, bagGUID = "e73481", hp = 4},
    ["Repulsive Grand Cruiser"] = {faction="ch", dices=4, morale=4, bagGUID = "36cbd8", hp = 5},
    ["Chaos Reaver Titan"]      = {faction="ch", dices=4, morale=3, bagGUID = "632bba", hp = 5},
    ["Chaos Bastion"]           = {faction="ch", dices=2, morale=2, bagGUID = "580d53", hp = 3},
    ["Hellebore Frigate"]       = {faction="ed", dices=3, morale=1, bagGUID = "3b40cb", reinf = "space", hp = 2},
    ["Aspect Warrior"]          = {faction="ed", dices=2, morale=2, bagGUID = "26e79f", reinf="planet", hp = 1},
    ["Wraithguard"]             = {faction="ed", dices=2, morale=2, bagGUID = "581425", hp = 4},
    ["Void Stalker"]            = {faction="ed", dices=4, morale=4, bagGUID = "7ab72a", hp = 5},
    ["Falcon"]                  = {faction="ed", dices=3, morale=3, bagGUID = "4b093a", hp = 4},
    ["Warlock Battle Titan"]    = {faction="ed", dices=4, morale=3, bagGUID = "f16fe6", hp = 5},
    ["Eldar Bastion"]           = {faction="ed", dices=2, morale=2, bagGUID = "ab8b20", hp = 3},
    ["Space Marine Bastion"]    = {faction="sm", dices=2, morale=2, bagGUID = "bf9d28", hp = 3},
    ["Scout"]                   = {faction="sm", dices=1, morale=2, bagGUID = "90596a", reinf = "planet", hp = 2},
    ["Strike Cruiser"]          = {faction="sm", dices=2, morale=2, bagGUID = "145d82", reinf = "space", hp = 2},
    ["Space Marine"]            = {faction="sm", dices=2, morale=3, bagGUID = "bbfa5a", hp = 3},
    ["Land Raider"]             = {faction="sm", dices=3, morale=3, bagGUID = "ad6b7f", hp = 4},
    ["Battle Barge"]            = {faction="sm", dices=4, morale=4, bagGUID = "06cc47", hp = 5},
    ["Warlord Titan"]           = {faction="sm", dices=3, morale=4, bagGUID = "3a3e84", hp = 5}
  }

-- im going to be honest I dont know why this exists
buildingsData = {
    ["Chaos Factory"]         = "ch",
    ["Chaos City"]            = "ch",
    ["Orks Factory"]          = "oz",
    ["Orks City"]             = "oz",
    ["Space Marines Factory"] = "sm",
    ["Space Marines City"]    = "sm",
    ["Eldar Factory"]         = "ed",
    ["Eldar City"]            = "ed"
  }

-- tile number => [1, 2, 3, 4] each element is a square on the tile
-- element options -> isSpace = void, materiel = amount of end round money, empty array means a planet but worth no money
-- TODO: would probably be better for the planets with no materiel to be materiel=0 to ease confusion
-- TODO: maybe put the carying capacity and assets on these objects too and save it all in one spot 
tilesData = {
    ["12A"] = {{isSpace=true}, {materiel=1}, {materiel=1}, {materiel=1}},
    ["12B"] = {{isSpace=true}, {materiel=2}, {}, {materiel=1}},
    ["9A"] = {{isSpace=true}, {isSpace=true}, {materiel=1}, {materiel=2}},
    ["9B"] = {{materiel=1}, {isSpace=true}, {materiel=2}, {isSpace=true}},
    ["10A"] = {{isSpace=true}, {materiel=1}, {}, {materiel=2}},
    ["10B"] = {{materiel=1}, {isSpace=true}, {materiel=2}, {}},
    ["11A"] = {{isSpace=true}, {materiel=2}, {materiel=1}, {}},
    ["11B"] = {{materiel=1}, {isSpace=true}, {materiel=1}, {materiel=1}},
    ["3A"] = {{isSpace=true}, {materiel=1}, {isSpace=true}, {materiel=2}},
    ["3B"] = {{isSpace=true}, {}, {isSpace=true}, {materiel=2}},
    ["5A"] = {{isSpace=true}, {isSpace=true}, {materiel=1}, {materiel=2}},
    ["5B"] = {{isSpace=true}, {isSpace=true}, {materiel=1}, {materiel=1}},
    ["7A"] = {{isSpace=true}, {isSpace=true}, {materiel=2}, {}},
    ["7B"] = {{}, {isSpace=true}, {materiel=2}, {isSpace=true}},
    ["1A"] = {{materiel=2}, {isSpace=true}, {materiel=1}, {isSpace=true}},
    ["1B"] = {{materiel=2}, {isSpace=true}, {}, {isSpace=true}},
    ["8A"] = {{isSpace=true}, {isSpace=true}, {materiel=3}, {}},
    ["8B"] = {{}, {isSpace=true}, {materiel=3}, {isSpace=true}},
    ["4A"] = {{isSpace=true}, {isSpace=true}, {materiel=1}, {materiel=1}},
    ["4B"] = {{materiel=1}, {isSpace=true}, {materiel=1}, {isSpace=true}},
    ["2A"] = {{isSpace=true}, {isSpace=true}, {}, {materiel=3}},
    ["2B"] = {{isSpace=true}, {isSpace=true}, {}, {materiel=2}},
    ["6A"] = {{isSpace=true}, {materiel=1}, {isSpace=true}, {materiel=1}},
    ["6B"] = {{isSpace=true}, {materiel=1}, {isSpace=true}, {materiel=1}}
  }

-- faction code => starting combat deck GUID, colored dice bag GUID, faction color (can be used), money counter guid, faction name
factionsData = {
["ch"] = {deckZoneGUID = "545788", diceBagGUID = "35addc", color = "Red",    counterGUID="f8446e", name="Chaos"},
["ed"] = {deckZoneGUID = "fe9f55", diceBagGUID = "408fe6", color = "Yellow", counterGUID="9197a2", name="Eldar"},
["sm"] = {deckZoneGUID = "bdf156", diceBagGUID = "893c6c", color = "Blue",   counterGUID="a87a1e", name="Space Marines"},
["oz"] = {deckZoneGUID = "aad880", diceBagGUID = "5e40b3", color = "Green",  counterGUID="587dc5", name="Orks"}
}

-- this is used to pad the messages printed to screen
-- end of round materiel report 
-- TODO: move this to End Of Round functionality since this is not universal
-- TODO: might be a better 
factionsNameFiller = {
    ["ch"] = "               ",
    ["ed"] = "                ",
    ["sm"] = "",
    ["oz"] = "                 "
}

-- faction RBG values
factionColors = {
    ["ch"] = {0.83, 0.07, 0.11},
    ["ed"] = {0.93, 0.93, 0.00},
    ["sm"] = {0.40, 0.40, 1.00},
    ["oz"] = {0.18, 0.67, 0.14}
}

-- TODO: idk what these are for
borderLineY = 0.08
showSectorBorders = false
lineColor = {0.75,0.52,0.23}

-- black hole zones that you yeet things into
garbageZoneIDs = {"a9ec4f", "561867", "68756b", "4b67bc"}

-- all combat cards
-- card name, iconds, faction code
-- TODO: probably better way to do this, at least numbers instead of repeated codes
cardsData = {
    ["Foul worship"] = {icons={"s"}, faction="ch"},
    ["Khorne's rage"] = {icons={"b"}, faction="ch"},
    ["Dark faith"] = {icons={"m"}, faction="ch"},
    ["Impure zeal"] = {icons={"b", "s"}, faction="ch"},
    ["Lure of Chaos"] = {icons={"m"}, faction="ch"},
    ["Mark of Khorne"] = {icons={"b", "b"}, faction="ch"},
    ["Mark of Nurgle"] = {icons={"s", "s"}, faction="ch"},
    ["Mark of Slaanesh"] = {icons={"b", "s"}, faction="ch"},
    ["Mark of Tzeentch"] = {icons={"m", "m"}, faction="ch"},
    ["Chaos victorious"] = {icons={"b", "s", "m"}, faction="ch"},
    ["Death and despair"] = {icons={"b", "b", "m"}, faction="ch"},
    ["Chaos united"] = {icons={"b", "s", "m"}, faction="ch"},
    ["Daemonic resilience"] = {icons={"s", "s", "m"}, faction="ch"},
    ["Inhuman strength"] = {icons={"b", "b", "m"}, faction="ch"},
    ["Biker Nobz"] = {icons={"b", "b", "s"}, faction="oz"},
    ["Mega Nobz"] = {icons={"b", "s", "s"}, faction="oz"},
    ["Sea of green"] = {icons={"b", "s"}, faction="oz"},
    ["Waaagh!!!!"] = {icons={"m", "m", "m"}, faction="oz"},
    ["Rokkit wagon"] = {icons={"b", "b", "b"}, faction="oz"},
    ["Party wagon"] = {icons={"b", "s", "s"}, faction="oz"},
    ["Weirdboyz"] = {icons={"b", "s", "m"}, faction="oz"},
    ["Smasher Gargant"] = {icons={"b", "b", "s", "s", "s"}, faction="oz"},
    ["Snapper Gargant"] = {icons={"b", "b", "b", "b", "s"}, faction="oz"},
    ["Shoota Boyz"] = {icons={"b", "b"}, faction="oz"},
    ["'Ard Boyz"] = {icons={"s", "s"}, faction="oz"},
    ["Slugga Boyz"] = {icons={"b", "s"}, faction="oz"},
    ["Gretchin"] = {faction="oz"},
    ["Mek Boyz"] = {icons={"m"}, faction="oz"},
    ["Reconnaissance"] = {icons={"s"}, faction="sm"},
    ["Fury of the Ultramar"] = {icons={"b"}, faction="sm"},
    ["Blessed Power Armour"] = {icons={"s"}, faction="sm"},
    ["Ambush"] = {icons={"b"}, faction="sm"},
    ["Faith in the Emperor"] = {icons={"m"}, faction="sm"},
    ["Veteran Scouts"] = {icons={"b", "s", "m"}, faction="sm"},
    ["Drop Pod assault"] = {icons={"b", "s"}, faction="sm"},
    ["Glory and death"] = {icons={"b", "m"}, faction="sm"},
    ["Hold the line"] = {icons={"s", "m"}, faction="sm"},
    ["Emperor's glory"] = {icons={"s", "s", "m", "m"}, faction="sm"},
    ["Emperor's might"] = {icons={"b", "b", "b"}, faction="sm"},
    ["Show no fear"] = {icons={"s", "s", "m"}, faction="sm"},
    ["Armoured advance"] = {icons={"b", "b", "s"}, faction="sm"},
    ["Break the line"] = {icons={"b", "s", "s"}, faction="sm"},
    ["Howling Banshees"] = {icons={"b"}, faction="ed"},
    ["Striking Scorpions"] = {icons={"s"}, faction="ed"},
    ["Hit and run"] = {icons={"b"}, faction="ed"},
    ["Command of the Autarch"] = {faction="ed"},
    ["Ranger support"] = {icons={"s", "m"}, faction="ed"},
    ["Fire Dragon's vengeance"] = {icons={"b", "b"}, faction="ed"},
    ["Swooping Hawks"] = {icons={"s", "s"}, faction="ed"},
    ["Wraithguard advance"] = {icons={"b", "m"}, faction="ed"},
    ["Wraithguard support"] = {icons={"s", "m"}, faction="ed"},
    ["Fire Prism"] = {icons={"b", "b", "s"}, faction="ed"},
    ["Wave Serpent"] = {icons={"b", "s", "s"}, faction="ed"},
    ["Spiritseer's guidance"] = {icons={"b", "s", "m"}, faction="ed"},
    ["Holofield emitter"] = {icons={"b", "s", "s", "m"}, faction="ed"},
    ["Psychic lance"] = {icons={"b", "b", "s"}, faction="ed"}
  }

-- I assume this is for the borders when rolling dice
diceWallIDs = {"11fae1", "ccd19c", "1f4efb"}