-- This file keeps all combat related functionality

--[[ Stores the battle data when a battle is occuring
    @see scanForBattles() => findEligibleBattle() => startBattle() for battle data assignment
    @see endBattleClicked() for battle data clearing

    @Type BattleData? - Table
    A table that contains a table of army objects by faction and boolean to show if that battle is in space
        @Key - "fighters" - String
        @value - Table - Associative Array
            @Key - faction - String - two character faction abbreviation to which the unit belongs; internal mapping
            @Value - Array of in-game Object references; Objects that exist in the tile where the battle is occuring
            @see https://api.tabletopsimulator.com/intro/#object
        @Key - "isSpace" - String
        @Value - Bool
--]]
battleData = nil

unitsPositions = {}

bottomFightZoneGUID = "9f0b03" -- (INGAMEREF)
topFightZoneGUID = "839de2" -- (INGAMEREF)


function setFightTiles()
    topFightTile = getObjectFromGUID("3d4d0d")
    bottomFightTile = getObjectFromGUID("d96e1d")
    topFightTile.registerCollisions(false)
    bottomFightTile.registerCollisions(false)
    topFightTile.interactable = false
    bottomFightTile.interactable = false
end

-- Section: Dice Walls
diceWallIDs = {"11fae1", "ccd19c", "1f4efb"} -- (INGAMEREF)
function setWallIdPositions()
    -- TODO: what are these magic numbers?
    getObjectFromGUID(diceWallIDs[1]).setPosition({-40.6, 6, 0})
    getObjectFromGUID(diceWallIDs[2]).setPosition({-32.3, 6, 0.22})
    getObjectFromGUID(diceWallIDs[3]).setPosition({-24, 6, 0})
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
-- End Section: Dice Walls

--[[ Board Error checking for Battles
called by fightClicked() in Global
This checks the entire board for battles by collecting disposition of army tokens in sectors.
Checks for errors in board state. Returns false for no eligeable battles.
@returns Tuple -
  @Value-1 - Bool     - an error status boolean. False if there is an error in board battle state
  @Value-2 - String   - an error message string, seen by the mod user, tells the user where the error in board state exists
--]]
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

-- Called by checkEligibleBattles and checkCollectMateriels
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

function getSectorArmy(sector, tile, isCountBuildings)
    local army
    army = sortObjectsByFactions(getSectorObjects(tile, sector), isCountBuildings)
    return convertArmyToArray(army)
end

function isFightTilesClean()
    return #getObjectFromGUID(bottomFightZoneGUID).getObjects() == 1 and #getObjectFromGUID(topFightZoneGUID).getObjects() == 1
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

