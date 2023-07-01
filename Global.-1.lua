--[[ Lua code. See documentation: http://berserk-games.com/knowledgebase/scripting/ --]]

--[[ The OnLoad function. This is called after everything in the game save finishes loading.
Most of your script code goes here. --]]

rollingDices = {}

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

factionsData = {
  ["ch"] = {deckZoneGUID = "545788", diceBagGUID = "35addc", color = "Red",    counterGUID="f8446e", orderZone="d48a52", name="Chaos"},
  ["ed"] = {deckZoneGUID = "fe9f55", diceBagGUID = "408fe6", color = "Yellow", counterGUID="9197a2", orderZone="a82193", name="Eldar"},
  ["sm"] = {deckZoneGUID = "bdf156", diceBagGUID = "893c6c", color = "Blue",   counterGUID="a87a1e", orderZone="5c5abb", name="Space Marines"},
  ["oz"] = {deckZoneGUID = "aad880", diceBagGUID = "5e40b3", color = "Green",  counterGUID="587dc5", orderZone="3f1125", name="Orks"}
}

factionsNameFiller = {
    ["ch"] = "               ",
    ["ed"] = "                ",
    ["sm"] = "",
    ["oz"] = "                 "
}

factionColors = {
    ["ch"] = {0.83, 0.07, 0.11},
    ["ed"] = {0.93, 0.93, 0.00},
    ["sm"] = {0.40, 0.40, 1.00},
    ["oz"] = {0.18, 0.67, 0.14}
}

borderLineY = 0.08
showSectorBorders = false
lineColor = {0.75,0.52,0.23}

garbageZoneIDs = {"a9ec4f", "561867", "68756b", "4b67bc"}

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

diceWallIDs = {"11fae1", "ccd19c", "1f4efb"}

function onload()
    battleData = nil
    boardZone = getObjectFromGUID("7e9dca")
    botFightZoneGUID = "9f0b03"
    topFightZoneGUID = "839de2"
    topFightTile = getObjectFromGUID("3d4d0d")
    botFightTile = getObjectFromGUID("d96e1d")
    topFightTile.registerCollisions(false)
    botFightTile.registerCollisions(false)
    topFightTile.interactable = false
    botFightTile.interactable = false
    unitsPositions = {}

    updateAllConteinerAmounts()
    setupBattlePanelsUI()
    drawAllGarbageZoneBorders()
    getObjectFromGUID(diceWallIDs[1]).setPosition({-40.6, 6, 0})
    getObjectFromGUID(diceWallIDs[2]).setPosition({-32.3, 6, 0.22})
    getObjectFromGUID(diceWallIDs[3]).setPosition({-24, 6, 0})
    lowerDiceWalls()
end

function onObjectPeek(object, player_color)
    if string.find(object.getName(), "order token") then
        print(player_color .. " peeked: " .. object.getName())
    end
end

function checkEligibleBattles()
  local battles = getAllBattles()

  if isFightTilesClean() == false then
    return false, "There is something in the battle zone. Clean battle zone first!"
  end
  if #battles == 0 then
    return false, "I don't see any active battles on the board."
  end
  if #battles > 1 then
    return false, "I have found battles on tiles: "..concatTileNames(battles)..". There can only be one active battle!"
  end
  if #battles[1].armies > 2 then
    return false, "I have found a battle on "..battles[1].tileName..", but there are more than 2 factions there!"
  end

  return true
end

function concatTileNames(battles)
  local result = ""

  for i, v in ipairs(battles) do
    result = result..v.tileName..", "
  end

  return string.sub(result, 1, string.len(result) - 2)
end

function getAllBattles(isCountBuildings)
  local objs = boardZone.getObjects()
  local result, army = {}, {}

  for num,tile in ipairs(objs) do
      if string.find(tile.getName(), "Tile") then
        for i = 1, 4 do
          army = getSectorArmy(i, tile, isCountBuildings)
          if #army > 1 then
            table.insert(result, {tileName=tile.getName(), armies=army})
          end
        end
      end
  end

  return result
end

function scanForBattles()
  local objs = boardZone.getObjects()
  local fighters

  for i,v in ipairs(objs) do
      if string.find(v.getName(), "Tile") then
        data = findEligibleBattle(v)
        if data ~= nil then
          print("Found a battle on "..v.getName())
          startBattle(data)
          return
        end
      end
  end
end

function compareFighters(a, b)
  local order = {ch=1, ed=2, oz=3, sm=4}
  return order[a.faction] < order[b.faction]
end

function startBattle(data)
  battleData = data
  raiseDiceWalls()
  setupFighter(data.fighters[1], botFightTile)
  setupFighter(data.fighters[2], topFightTile)
end

function setupFighter(fighter, tile)
  spawnUnitDices(fighter.units, tile)
  dealBattleCards(fighter.faction)
  lookAtBattle(fighter.faction, tile)
  moveUnitsToBattle(fighter, tile)
end

function moveUnitsToBattle(fighter, tile)
  local count = 0
  saveUnitsPositions(fighter.units)
  for i,v in ipairs(fighter.units) do
    v.setRotation({0, tile.getRotation().y, v.getRotation().z})
    v.setPositionSmooth(getUnitPosition(tile, count))
    count = count + 1
  end
end

function saveUnitsPositions(units)
  for i,v in ipairs(units) do
    unitsPositions[v.getGUID()] = v.getPosition()
  end
end

function getUnitPosition(tile, count)
  local diceWidth, diceHeight = 2, 2
  local sign = math.cos(tile.getRotation().y * math.pi / 180)
  position = tile.getPosition()
  position.y = 3
  position.x = position.x - tile.getBounds().size.x / 2 + diceWidth / 2 + count * diceWidth
  position.z = position.z + sign * tile.getBounds().size.z / 2 - sign * diceHeight / 2 - sign * 3 * diceHeight
  position.z = position.z - sign * 4
  return position
end

function lookAtBattle(faction, tile)
  local factionData = factionsData[faction]
  Player[factionData.color].lookAt({
    position = tile.getPosition(),
    pitch    = 70,
    yaw      = tile.getRotation().y,
    distance = 50,
  })
end

function dealBattleCards(faction)
  local deck, factionData

  factionData = factionsData[faction]
  deck = getFactionDeck(factionData)
  if deck ~= nil then
    deck.shuffle()
    deck.deal(5, factionData.color)
  end
end

function getFactionDeck(factionData)
  local objs

  objs = getObjectFromGUID(factionData.deckZoneGUID).getObjects()
  for i,v in ipairs(objs) do
    if v.tag == "Deck" then
      return v
    end
  end
end

function spawnUnitDices(units, tile)
  local diceCount = 0
  local unitData, faction, factionData
  for i,v in ipairs(units) do
    unitData = unitsData[v.getName()]
    faction = unitData.faction
    diceCount = diceCount + unitData.dices
  end
  diceCount = math.min(diceCount, 8)
  for i=1,diceCount do
    addDiceToTile(tile, factionsData[faction].diceBagGUID)
  end
end

function raiseDiceWalls()
    adjustDiceWalls(20)
    Wait.time(lowerDiceWalls,5)
end

function lowerDiceWalls()
    adjustDiceWalls(-20)
end

function adjustDiceWalls(heightOffset)
    for i,v in ipairs(diceWallIDs) do
        wall = getObjectFromGUID(v)
        pos = wall.getPosition()
        pos[2] = pos[2] + heightOffset
        wall.setPosition(pos)
    end
end

function updateMateriels()
  local materiels = countMateriels()
  local counter, old, plus, delta, report

  report = "Materiels were added:"
  for k,v in pairs(factionsData) do
    counter = getObjectFromGUID(v.counterGUID)
    plus    = materiels[k] or 0
    delta   = math.min(plus, 14 - counter.call("getCount"))
    old     = counter.call("getCount")
    counter.call("setCount", counter.call("getCount") + delta)
    report  = report.."\n"..v.name..": "..factionsNameFiller[k]..old.." + "..delta.." ("..plus..") = "..counter.call("getCount")
  end
  printMessage(report)
end

function countMateriels()
  local objs = boardZone.getObjects()
  local materiel
  local result = {}

  for i,v in ipairs(objs) do
    if string.find(v.getName(), "Tile") then
      for sector = 1, 4 do
        army = getSectorArmy(sector, v, true)
        if #army > 0 then
          materiel = getTileData(v)[normalizeSectorNumber(sector, v)].materiel or 0
          result[army[1].faction] = result[army[1].faction] or 0
          result[army[1].faction] = result[army[1].faction] + materiel
        end
      end
    end
  end
  return result
end

function findEligibleBattle(tile)
  local army
  local fightersData
  for i = 1, 4 do
    army = getSectorArmy(i, tile)
    if #army == 2 then
      return createBattleData(army, tile, i)
    end
  end

  return nil
end

function getSectorArmy(sector, tile, isCountBuildings)
  local army
  army = sortObjectsByFactions(getSectorObjects(tile, sector), isCountBuildings)
  return convertArmyToArray(army)
end

function createBattleData(fighters, tile, sector)
  local result = {}
  local sectorNormalized = normalizeSectorNumber(sector, tile)
  table.sort(fighters, compareFighters)
  result.fighters = fighters
  result.isSpace = getTileData(tile)[sectorNormalized].isSpace or false
  return result
end

function getTileData(tile)
  local num = tile.getName()
  local letter
  num = string.sub(num, string.len("Tile ") + 1)
  letter = tile.is_face_down and "B" or "A"
  return tilesData[num..letter]
end

function normalizeSectorNumber(sector, tile)
  local offset = round(tile.getRotation().y / 90)
  sector = sector - offset
  if sector < 1 then sector = 4 + sector end
  if sector > 4 then sector = math.fmod(sector, 4) end
  return sector
end

function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

function sortObjectsByFactions(objs, isCountBuildings)
  local army = {}
  local faction, unitData, buildingData

  for i,v in ipairs(objs) do
    faction = unitsData[v.getName()] and unitsData[v.getName()].faction
    faction = faction or (isCountBuildings and buildingsData[v.getName()])
    if faction then
      army[faction] = army[faction] or {}
      table.insert(army[faction], v)
    end
  end

  return army
end

function convertArmyToArray(army)
  local result = {}
  for k,v in pairs(army) do
    table.insert(result, {
      faction = k,
      units = v
    })
  end

  return result
end

function getSectorObjects(tile, sector)
  local position = tile.getPosition()
  local signX = {-1, 1, 1, -1}
  local signZ = {1, 1, -1, -1}
  local data, objs = {}, {}
  position.x = position.x + signX[sector] * tile.getBounds().size.x / 4
  position.z = position.z + signZ[sector] * tile.getBounds().size.z / 4
  data = Physics.cast({origin=position, type=3, size={5, 5, 5},direction = {0,1,0},max_distance = 0})

  for i,v in ipairs(data) do
    table.insert(objs, v.hit_object)
  end
  return objs
end

function collectMaterielClicked()
  local status, err = checkCollectMateriels()
  if status == true then
    updateMateriels()
  else
    printError(err)
  end
  getObjectFromGUID("9fdf39").shuffle()
  getObjectFromGUID("f869ee").shuffle()
  getObjectFromGUID("beb03e").shuffle()
  getObjectFromGUID("84398b").shuffle()
end

function checkCollectMateriels()
  local battles = getAllBattles(true)

  if #battles > 0 then
    return false, "I can't count materiels! There are active battles on "..concatTileNames(battles)
  end

  return true
end

function onObjectDrop(player, object)
    if showSectorBorders and (unitsData[object.getName()] or buildingsData[object.getName()]) then
        updateTileBorders()
    end
    checkGarbageZones()
end

function checkGarbageZones()
    for _, id in ipairs(garbageZoneIDs) do
        checkGarbageZone(id)
    end
end

function checkGarbageZone(id)
    zone = getObjectFromGUID(id)
    for _, occupyingObject in ipairs(zone.getObjects()) do
        name = occupyingObject.getName()
        if occupyingObject.type == "Dice" or string.find(name, "token") then
            occupyingObject.destruct()
        else
            if occupyingObject.type == "Figurine" then
                if string.find(occupyingObject.getName(), "City") or
                    string.find(occupyingObject.getName(), "Factory") or
                    string.find(occupyingObject.getName(), "Bastion") then
                        occupyingObject.destruct()
                else
                    unitDeleteClicked("", "", occupyingObject.getGUID())
                end
            end
        end
    end
end

function drawAllGarbageZoneBorders()
    for _, id in ipairs(garbageZoneIDs) do
        drawGarbageZoneBorders(id)
    end
end

function drawGarbageZoneBorders(id)
    zone = getObjectFromGUID(id)
    zone.setVectorLines({
        createLine({{0.5, -0.5, 0.5}, {0.5, -0.5, -0.5}, {-0.5, -0.5, -0.5}, {-0.5, -0.5, 0.5}, {0.5, -0.5, 0.5}}, lineColor)
    })
end

function toggleBordersClicked(player, value, id)
    showSectorBorders = value == "True"
    updateTileBorders()
end

function updateTileBorders()
    local objs = boardZone.getObjects()
    local foundTile = false
    for num,tile in ipairs(objs) do
        if string.find(tile.getName(), "Tile") then
            foundTile = true
            toggleBorder(tile)
        end
    end
end

function toggleBorder(tile)
    local lines = {}
    if showSectorBorders then
        lines[1] = createTileBorderMiddleLine(true,  tile.is_face_down)
        lines[2] = createTileBorderMiddleLine(false, tile.is_face_down)
        local index = 3
        local army
        for i = 1, 4 do
            army = getSectorArmy(i, tile, true)
            if #army == 1 then
                lines = addSectorOccupationLines(adjustSector(i,tile), army[1].faction, lines, index, tile.is_face_down)
                index = index + 4
            end
        end
    end
    tile.setVectorLines(lines)
end

function adjustSector(sector, tile)
    local sectorFlip   = {2,1,4,3}
    local rotationFlip = {0,3,2,1}
    local roationIndex = math.floor((tile.getRotation().y/90)+0.5) -- 0=0, 90=1, 180=2, 270=3
    roationIndex = rotationFlip[roationIndex+1]
    local adjusted = sector + roationIndex
    if adjusted > 4      then adjusted = adjusted - 4         end
    if tile.is_face_down then adjusted = sectorFlip[adjusted] end
    return adjusted
end

function addSectorOccupationLines(sector, faction, lines, index, tileFlipped)
    local c = factionColors[faction]
    local xz, g, l, y = 2.6, 0.1, 0.2, borderLineY
    local xOffA, yOffA, xOffB, yOffB, offset = 0, 0, 0, 0, xz + g
    if tileFlipped then y = -borderLineY end
    if sector == 1 then
        xOffA = offset
    elseif sector == 3 then
        yOffA = offset
    elseif sector == 4 then
        xOffA = offset
        yOffA = offset
    end
    lines[index]   = createLine({{xz-l-xOffA,y,xz-yOffA}, {xz-xOffA,y,xz-yOffA}, {xz-xOffA,y,xz-l-yOffA}}, c)
    lines[index+1] = createLine({{g+l-xOffA, y,xz-yOffA}, {g-xOffA, y,xz-yOffA}, {g-xOffA, y,xz-l-yOffA}}, c)
    lines[index+2] = createLine({{xz-l-xOffA,y,g-yOffA }, {xz-xOffA,y,g-yOffA }, {xz-xOffA,y,g+l-yOffA }}, c)
    lines[index+3] = createLine({{g+l-xOffA, y,g-yOffA }, {g-xOffA, y,g-yOffA }, {g-xOffA, y,g+l-yOffA }}, c)
    return lines
end

function createTileBorderMiddleLine(vertical, tileFlipped)
    local x, z = 0, 0
    local y = borderLineY
    if vertical then x = 2.8 else z = 2.8 end
    if tileFlipped then y = -borderLineY end
    return createLine({{x,y,z}, {-x,y,-z}}, lineColor)
end

function createLine(pointTable, color)
    return {
        points    = pointTable,
        color     = color,
        thickness = 0.03,
        rotation  = {0,0,0},
    }
end

function addDiceClicked(player, value, id)
  local factionData = getFactionDataByColor(player.color)
  local tile = id == "botDiceButton" and botFightTile or topFightTile
  local zoneGUID = id == "botDiceButton" and botFightZoneGUID or topFightZoneGUID

  factionData = factionData or factionsData["ch"]

  if getDiceCount(getObjectFromGUID(zoneGUID)) < 8 then
    addDiceToTile(tile, factionData.diceBagGUID)
  else
    print("You can't have more than 8 dice!")
  end
end

function addBolterClicked(player, value, id)
  local tile = id == "botBolterButton" and botFightTile or topFightTile
  addTokenToTile("bolter", tile)
end

function addShieldClicked(player, value, id)
  local tile = id == "botShieldButton" and botFightTile or topFightTile
  addTokenToTile("shield", tile)
end

function addTokenToTile(type, tile)
  local bag = getObjectFromGUID("792a8c")
  bag.takeObject({
    position = {tile.getPosition().x, 3, tile.getPosition().z},
    rotation = {0, 0, type == "shield" and 180 or 0},
    callback_function=sortObjects
  })
end

function getDiceCount(zone)
  local objs = zone.getObjects()
  local result = 0

  for i,v in ipairs(objs) do
    if v.tag == "Dice" then
      result = result + 1
    end
  end

  return result
end

function getFactionDataByColor(color)
  for k,v in pairs(factionsData) do
    if v.color == color then
      return v
    end
  end

  return nil
end

function addDiceToTile(tile, bagGUID)
  local position = tile.getPosition()
  local bounds = tile.getBounds().size

  position.y = 3
  position.x = math.random(position.x - bounds.x / 3, position.x + bounds.x / 3)
  position.z = math.random(position.z - 2, position.z + 2)
  getObjectFromGUID(bagGUID).takeObject({
    position = position,
    callback_function = onDiceAdded
  })
end

function onDiceAdded(dice)
  dice.randomize("someColor")
end

function endRoundClicked()
  removeCombatTokens(getObjectFromGUID(botFightZoneGUID))
  removeCombatTokens(getObjectFromGUID(topFightZoneGUID))
end

function removeCombatTokens(zone)
  local objs = zone.getObjects()

  for i,v in ipairs(objs) do
    if v.getName() == "Combat token" then
      v.destruct()
    end
  end
end

function sortClicked()
  calculate()
  sortObjects()
end

function fightClicked()
  local status, err = checkEligibleBattles()
  if status then
    scanForBattles()
  else
    printError(err)
  end
end

function printError(text)
  broadcastToAll(text, {1, 0, 0})
end

function printMessage(text)
  broadcastToAll(text, {0, 1, 0.2})
end

function isFightTilesClean()
  return #getObjectFromGUID(botFightZoneGUID).getObjects() == 1 and #getObjectFromGUID(topFightZoneGUID).getObjects() == 1
end

function endBattleClicked()
  cleanFightZone(getObjectFromGUID(botFightZoneGUID))
  cleanFightZone(getObjectFromGUID(topFightZoneGUID))
  discardBattleCards()
  unitsPositions = {}
  battleData = nil
  Wait.time(calculate, 0.2)
end

function discardBattleCards()
  for k,v in pairs(Player.getPlayers()) do
    if v.getHandCount() > 0 then
      discardPlayerCards(v)
    end
  end
end

function discardPlayerCards(player)
  local cards = player.getHandObjects()
  for i,v in ipairs(cards) do
    if cardsData[v.getName()] ~= nil then
      takeCardHome(v)
    end
  end
end

function cleanFightZone(zone)
  local objs = zone.getObjects()

  for i,v in ipairs(objs) do
    if v.tag == "Dice" or v.getName() == "Combat token" or v.getVar("isReinforcement") then
      v.destruct()
    end

    if v.tag == "Card" then
      takeCardHome(v)
    end

    if unitsPositions[v.getGUID()] then
      v.setPositionSmooth(unitsPositions[v.getGUID()])
    end
  end
end

function takeCardHome(card)
  local cardData = cardsData[card.getName()]
  local factionData = factionsData[cardData.faction]
  local zone = getObjectFromGUID(factionData.deckZoneGUID)

  if putCardInDeck(card, zone) == false then
    moveCardToDeck(card, zone)
  end
end

function moveCardToDeck(card, zone)
  if card.is_face_down == false then
    card.flip()
  end

  position = zone.getPosition()
  position.y = 3
  card.setPositionSmooth(position)
end

function putCardInDeck(card, zone)
  local objs

  objs = zone.getObjects()
  for i,v in ipairs(objs) do
    if v.tag == "Deck" then
      v.putObject(card)
      return true
    end
  end

  return false
end

function setupBattlePanelsUI()
  local data = botFightTile.UI.getXmlTable()
  topFightTile.UI.setXmlTable(data)
  Wait.time(setupBattlePanelsUIDelay, 0.2)
end

function setupBattlePanelsUIDelay()
  botFightTile.UI.setAttribute("battlePanel", "offsetXY", "250 0")
  topFightTile.UI.setAttribute("battlePanel", "offsetXY", "-250 0")
  botFightTile.UI.setAttribute("diceButton", "id", "botDiceButton")
  topFightTile.UI.setAttribute("diceButton", "id", "topDiceButton")
  topFightTile.UI.setAttribute("bolterButton", "offsetXY", "-77 -12")
  topFightTile.UI.setAttribute("shieldButton", "offsetXY", "-77 13")
  botFightTile.UI.setAttribute("bolterButton", "offsetXY", "77 -12")
  botFightTile.UI.setAttribute("shieldButton", "offsetXY", "77 13")
  botFightTile.UI.setAttribute("shieldButton", "id", "botShieldButton")
  topFightTile.UI.setAttribute("shieldButton", "id", "topShieldButton")
  botFightTile.UI.setAttribute("bolterButton", "id", "botBolterButton")
  topFightTile.UI.setAttribute("bolterButton", "id", "topBolterButton")
end

function onObjectDestroy(destroyedObj)
    Wait.time(calculate, 0.1)
end

function onObjectCollisionEnter(registered_object, info)
  local obj = info.collision_object

  if obj.getName() == "Reinforcement token" then
    renameReinforcementToken(obj, registered_object == botFightTile and 1 or 2)
    obj.setVar("isReinforcement", true)
    obj.setRotation({0, registered_object.getRotation().y, 0})
  end
  if unitsData[obj.getName()] then
    obj.UI.setXmlTable(createUnitUI(obj))
  end

  calculate()
end

function printTable(tab)
  for key,value in pairs(tab) do
    print("key: " .. key.." value: ")
    print(value)
  end
end

--[[ The Update function. This is called once per frame. --]]
function update ()
    if #rollingDices == 0 then return end

    for i, v in ipairs(rollingDices) do
        if v == nil then break end
        if v.resting == false then return end
    end

    rollingDices = {}
    calculate()
    sortObjects()
end

function sortObjects()
  sortObjectsOnTile(botFightZoneGUID, botFightTile)
  sortObjectsOnTile(topFightZoneGUID, topFightTile)
end

function sortObjectsOnTile(zoneGUID, tile)
  local row, column = 0,0
  local types = {"bolter", "shield", "morale"}
  local sortedObjs = sortObjectsByType(getObjectFromGUID(zoneGUID).getObjects())

  for i, type in ipairs(types) do
    for j, v in ipairs(sortedObjs[type]) do
      if v.tag == "Dice" then
        v.setRotationValue(v.getRotationValue())
      end
      v.setPositionSmooth(getTileItemPosition(tile, row, column), false, false)
      column = column + 1
      if column > 7 then
        column = 0
        row = row + 1
      end
    end
    if row < i then
      row = i
      column = 0
    end
  end
end

function sortObjectsByType(objs)
  local types = {bolter = {}, shield = {}, morale = {}}
  for i,v in ipairs(objs) do
    if v.tag == "Dice" then
      table.insert(types[getDiceValue(v)], v)
    end
    if v.getName() == "Combat token" then
      table.insert(types[getCombatTokenValue(v)], v)
    end
  end

  table.sort(types.bolter, compareDiceAndTokens)
  table.sort(types.shield, compareDiceAndTokens)
  return types
end

function compareDiceAndTokens(a, b)
  if a.tag == b.tag then
    return a.getGUID() > b.getGUID()
  end

  return a.tag == "Dice" and true or false
end

function getTileItemPosition(tile, row, column)
  local diceWidth, diceHeight = 2, 2
  local sign = math.cos(tile.getRotation().y * math.pi / 180)
  position = tile.getPosition()
  position.y = 3
  position.x = position.x - tile.getBounds().size.x / 2 + diceWidth / 2 + column * diceWidth
  position.z = position.z + sign * tile.getBounds().size.z / 2 - sign * diceHeight / 2 - sign * row * diceHeight
  return position
end

function onObjectRandomize(obj, color)
    if obj.tag == "Dice" then
      if haveRollingDice(obj) then return end
      table.insert(rollingDices, obj)
    end
end

function haveRollingDice(dice)
  for i,v in ipairs(rollingDices) do
    if v == dice then return true end
  end

  return false
end

function renameReinforcementToken(token, fighterIndex)
  local reinf
  if battleData == nil then return nil end
  reinf = battleData.isSpace and "space" or "planet"
  token.setName(getReinforcementUnitName(battleData.fighters[fighterIndex].faction, reinf))
end

function getReinforcementUnitName(faction, reinf)
  for k,v in pairs(unitsData) do
    if v.faction == faction and v.reinf == reinf then
      return k
    end
  end
end

function createUnitUI(obj)
  local hp = unitsData[obj.getName()].hp
  return {
    createUnitButton(obj, 0,"HP: "..hp, nil, 1, false),
    createUnitButton(obj, 1, "Kill", "Global/unitDeleteClicked", 2, true),
    --createUnitButton(obj, 2, "Return", "Global/unitReturnClicked", 3)
  }
end

function createUnitButton(obj, number, text, onClick, index, enabled)
  local scale = 1 / obj.getScale().x
  local offset = 70

  return {
    tag="Button",
    attributes = {
        interactable = enabled,
      height = 60,
      width = 100,
      scale = scale.." "..scale.." "..scale,
      position = "0 "..((-150 - offset * number) * scale).." -60",
      rotation = obj.getRotation().z.." 0 "..obj.getRotation().z,
      text = text,
      fontSize = 28,
      onClick = onClick,
      id = obj.getGUID() .. ":" .. index
    }
  }
end

function unitDeleteClicked(player, value, id)
  local unit = getObjectFromGUID(string.sub(id, 1, 6))
  if unit == nil then return end
  local data = unitsData[unit.getName()]
  if unit.tag == "Figurine" then
    getObjectFromGUID(data.bagGUID).putObject(unit)
  else
    unit.destruct()
  end
end

function unitReturnClicked(player, value, id)
  local unit = getObjectFromGUID(string.sub(id, 1, 6))
  if unitsPositions[unit.getGUID()] then
    unit.setPositionSmooth(unitsPositions[unit.getGUID()])
  else
    printError("I don't know where to return that")
  end
end

function onObjectLeaveScriptingZone(zone, obj)
  if (zone.guid == botFightZoneGUID or zone.guid == topFightZoneGUID) then
    calculate()

    if unitsData[obj.getName()] then
      obj.UI.setXmlTable({{}})
    end
  end
end

function calculate()
    local botStats = getStatsForObjects(getObjectFromGUID(botFightZoneGUID).getObjects())
    local topStats = getStatsForObjects(getObjectFromGUID(topFightZoneGUID).getObjects())

    setFightTileData(botFightTile, botStats, topStats)
    setFightTileData(topFightTile, topStats, botStats)
end

function getStatsForObjects(objs)
  local stats = {shield=0,bolter=0,morale=0}
  local value, unitData

  for i, v in ipairs(objs) do
    if v.tag == "Dice" then
      value = getDiceValue(v)
      stats[value] = stats[value] + 1
    end

    if v.tag == "Card" and v.is_face_down == false then
      stats["shield"] = stats["shield"] + getCardIcons(v, "s")
      stats["bolter"] = stats["bolter"] + getCardIcons(v, "b")
      stats["morale"] = stats["morale"] + getCardIcons(v, "m")
    end

    if v.getName() == "Combat token" then
      stats[getCombatTokenValue(v)] = stats[getCombatTokenValue(v)] + 1
    end

    unitData = unitsData[v.getName()]
    if unitData ~= nil and v.is_face_down == false then
      stats["morale"] = stats["morale"] + unitData.morale
    end
  end

  return stats
end

function getCombatTokenValue(token)
  return token.is_face_down and "bolter" or "shield"
end

function setFightTileData(panel, myStats, hisStats)
  local damageDealt, damageTaken, moraleDelta, moraleSign

  damageDealt = myStats["bolter"] - hisStats["shield"]
  damageTaken = hisStats["bolter"] - myStats["shield"]
  moraleDelta = myStats["morale"] - hisStats["morale"]
  moraleSign = moraleDelta > 0 and "+" or ""
  panel.UI.setAttribute("dealtDamage", "text", "Deal "..damageDealt)
  panel.UI.setAttribute("dealtDamage", "color", getDeltaColor(damageDealt))
  panel.UI.setAttribute("takenDamage", "text", "Take "..damageTaken)
  panel.UI.setAttribute("takenDamage", "color", getDeltaColor(-damageTaken))
  panel.UI.setAttribute("moraleDelta", "text", moraleSign..moraleDelta)
  panel.UI.setAttribute("moraleDelta", "color", getDeltaColor(moraleDelta))
  panel.UI.setAttribute("bolterCount", "text", myStats["bolter"])
  panel.UI.setAttribute("shieldCount", "text", myStats["shield"])
  panel.UI.setAttribute("moraleCount", "text", myStats["morale"])
end

function getDeltaColor(stat)
  if stat == 0 then return "#000000" end
  return stat < 0 and "#FF0000" or "#00FF00"
end

function getCardIcons(card, type)
  local result = 0
  local cardIcons = cardsData[card.getName()] and cardsData[card.getName()].icons or nil

  if cardIcons == nil then return 0 end

  for i = 1, #cardIcons do
    if cardIcons[i] == type then
      result = result + 1
    end
  end

  return result
end

function getDiceValue(dice)
  local sides = {"shield", "bolter", "bolter", "bolter", "morale", "shield"}
  return sides[tonumber(dice.getRotationValue())]
end

function onObjectEnterContainer(container, object)
    updateContainerAmount(container)
end

function onObjectLeaveContainer(container, object)
    updateContainerAmount(container)
end

function updateAllConteinerAmounts()
    for k,v in pairs(unitsData) do
        updateContainerAmount(getObjectFromGUID(v.bagGUID))
    end
end

function updateContainerAmount(container)
    if container.UI.getValue("amount") != nil then
      container.UI.setValue("amount", container.getQuantity())
    end
end
