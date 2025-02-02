local STORE = require("_variables")
local UTILS = require('_utils')

local BATTLE_SCRIPTS = {}

BATTLE_SCRIPTS.checkEligibleBattles = function(boardZone, botFightZoneGUID, topFightZoneGUID)
    local battles = BATTLE_SCRIPTS.getAllBattles(boardZone)

    if isFightTilesClean(botFightZoneGUID, topFightZoneGUID) == false then
        return false, "There is something in the battle zone. Clean battle zone first!"
    end
    if #battles == 0 then
        return false, "I don't see any active battles on the board."
    end
    if #battles > 1 then
        return false, "I have found battles on tiles: " .. UTILS.concatTileNames(battles) ..
            ". There can only be one active battle!"
    end
    if #battles[1].armies > 2 then
        return false,
            "I have found a battle on " .. battles[1].tileName .. ", but there are more than 2 factions there!"
    end

    return true
end

BATTLE_SCRIPTS.scanForBattles = function(boardZone, botFightTile, topFightTile)
    local objs = boardZone.getObjects()
    local fighters

    for i, v in ipairs(objs) do
        if string.find(v.getName(), "Tile") then
            data = findEligibleBattle(v)
            if data ~= nil then
                print("Found a battle on " .. v.getName())
                startBattle(data, botFightTile, topFightTile)
                return
            end
        end
    end
end

BATTLE_SCRIPTS.getAllBattles = function(boardZone, isCountBuildings)
    local objs = boardZone.getObjects()
    local result, army = {}, {}

    for num, tile in ipairs(objs) do
        if string.find(tile.getName(), "Tile") then
            for i = 1, 4 do
                army = UTILS.getSectorArmy(i, tile, isCountBuildings)
                if #army > 1 then
                    table.insert(result, {
                        tileName = tile.getName(),
                        armies = army
                    })
                end
            end
        end
    end

    return result
end

function isFightTilesClean(botFightZoneGUID, topFightZoneGUID)
    local bottomFightZoneObjects = getObjectFromGUID(botFightZoneGUID).getObjects()
    local topFightZoneObjects = getObjectFromGUID(topFightZoneGUID).getObjects()
    return #bottomFightZoneObjects == 1 and #topFightZoneObjects == 1
end

function findEligibleBattle(tile)
    local army
    local fightersData
    for i = 1, 4 do
        army = UTILS.getSectorArmy(i, tile)
        if #army == 2 then
            return createBattleData(army, tile, i)
        end
    end

    return nil
end

function createBattleData(fighters, tile, sector)
    local result = {}
    local sectorNormalized = UTILS.normalizeSectorNumber(sector, tile)
    table.sort(fighters, compareFighters)
    result.fighters = fighters
    result.isSpace = UTILS.getTileData(tile)[sectorNormalized].isSpace or false
    return result
end

function compareFighters(a, b)
    local order = {
        ch = 1,
        ed = 2,
        oz = 3,
        sm = 4
    }
    return order[a.faction] < order[b.faction]
end

-- battleData is also a global variable
function startBattle(data, botFightTile, topFightTile)
    battleData = data
    -- raiseDiceWalls()
    setupFighter(data.fighters[1], botFightTile)
    setupFighter(data.fighters[2], topFightTile)
end

function setupFighter(fighter, tile)
    spawnUnitDices(fighter.units, tile)
    dealBattleCards(fighter.faction)
    lookAtBattle(fighter.faction, tile)
    moveUnitsToBattle(fighter, tile)
end

function spawnUnitDices(units, tile)
    local diceCount = 0
    local sign, unflipped, unitData, faction, factionData
    for i, v in ipairs(units) do
        sign = math.cos(v.getRotation().z * math.pi / 180)
        unflipped = sign > 0
        unitData = STORE.unitsData[v.getName()]
        faction = unitData.faction
        if unflipped then
            diceCount = diceCount + unitData.dices
        end
    end
    diceCount = math.min(diceCount, 8)
    for i = 1, diceCount do
        UTILS.addDiceToTile(tile, STORE.factionsData[faction].diceBagGUID)
    end
end

function dealBattleCards(faction)
    local deck, factionData

    factionData = STORE.factionsData[faction]
    deck = getFactionDeck(factionData)
    if deck ~= nil then
        deck.shuffle()
        deck.deal(5, factionData.color)
    end
end

function getFactionDeck(factionData)
    local objs

    objs = getObjectFromGUID(factionData.deckZoneGUID).getObjects()
    for i, v in ipairs(objs) do
        if v.tag == "Deck" then
            return v
        end
    end
end

function lookAtBattle(faction, tile)
    local factionData = STORE.factionsData[faction]
    Player[factionData.color].lookAt({
        position = tile.getPosition(),
        pitch = 70,
        yaw = tile.getRotation().y,
        distance = 50
    })
end

function moveUnitsToBattle(fighter, tile)
    local count = 0
    saveUnitsPositions(fighter.units)
    for i, v in ipairs(fighter.units) do
        v.setRotation({0, tile.getRotation().y, v.getRotation().z})
        v.setPositionSmooth(getUnitPosition(tile, count))
        count = count + 1
    end
end

-- unitsPositions is a table created on load, global variable
function saveUnitsPositions(units)
    for i, v in ipairs(units) do
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

return BATTLE_SCRIPTS
