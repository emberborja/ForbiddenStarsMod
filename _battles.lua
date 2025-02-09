local STORE = require("_variables")
local UTILS = require('_utils')
local COMBAT = require("_combat")

local BATTLE_SCRIPTS = {}

BATTLE_SCRIPTS.checkEligibleBattles = function(boardZone, botFightZoneGUID, topFightZoneGUID)
    local battles = BATTLE_SCRIPTS.getAllBattles(boardZone)

    if BATTLE_SCRIPTS.isFightTilesClean(botFightZoneGUID, topFightZoneGUID) == false then
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

    for _, v in ipairs(objs) do
        if string.find(v.getName(), "Tile") then
            local data = BATTLE_SCRIPTS.findEligibleBattle(v)
            if data ~= nil then
                print("Found a battle on " .. v.getName())
                BATTLE_SCRIPTS.startBattle(data, botFightTile, topFightTile)
                return
            end
        end
    end
end

BATTLE_SCRIPTS.getAllBattles = function(boardZone, isCountBuildings)
    local objs = boardZone.getObjects()
    local result, army = {}, {}

    for _, tile in ipairs(objs) do
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

function BATTLE_SCRIPTS.isFightTilesClean(botFightZoneGUID, topFightZoneGUID)
    local bottomFightZoneObjects = getObjectFromGUID(botFightZoneGUID).getObjects()
    local topFightZoneObjects = getObjectFromGUID(topFightZoneGUID).getObjects()
    return #bottomFightZoneObjects == 1 and #topFightZoneObjects == 1
end

function BATTLE_SCRIPTS.findEligibleBattle(tile)
    local army
    for i = 1, 4 do
        army = UTILS.getSectorArmy(i, tile)
        if #army == 2 then
            return BATTLE_SCRIPTS.createBattleData(army, tile, i)
        end
    end

    return nil
end

function BATTLE_SCRIPTS.createBattleData(fighters, tile, sector)
    local result = {}
    local sectorNormalized = UTILS.normalizeSectorNumber(sector, tile)
    table.sort(fighters, BATTLE_SCRIPTS.compareFighters)
    result.fighters = fighters
    result.isSpace = UTILS.getTileData(tile)[sectorNormalized].isSpace or false
    return result
end

function BATTLE_SCRIPTS.compareFighters(a, b)
    local order = {
        ch = 1,
        ed = 2,
        oz = 3,
        sm = 4
    }
    return order[a.faction] < order[b.faction]
end

function BATTLE_SCRIPTS.startBattle(data, botFightTile, topFightTile)
    COMBAT.battleData = data
    -- raiseDiceWalls()
    BATTLE_SCRIPTS.setupFighter(data.fighters[1], botFightTile)
    BATTLE_SCRIPTS.setupFighter(data.fighters[2], topFightTile)
end

function BATTLE_SCRIPTS.setupFighter(fighter, tile)
    BATTLE_SCRIPTS.spawnUnitDices(fighter.units, tile)
    BATTLE_SCRIPTS.dealBattleCards(fighter.faction)
    BATTLE_SCRIPTS.lookAtBattle(fighter.faction, tile)
    BATTLE_SCRIPTS.moveUnitsToBattle(fighter, tile)
end

function BATTLE_SCRIPTS.spawnUnitDices(units, tile)
    local diceCount = 0
    local sign, unflipped, unitData, faction, factionData
    for _, v in ipairs(units) do
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

function BATTLE_SCRIPTS.dealBattleCards(faction)
    local deck, factionData

    factionData = STORE.factionsData[faction]
    deck = BATTLE_SCRIPTS.getFactionDeck(factionData)
    if deck ~= nil then
        deck.shuffle()
        deck.deal(5, factionData.color)
    end
end

function BATTLE_SCRIPTS.getFactionDeck(factionData)
    local objs

    objs = getObjectFromGUID(factionData.deckZoneGUID).getObjects()
    for _, v in ipairs(objs) do
        if v.tag == "Deck" then
            return v
        end
    end
end

function BATTLE_SCRIPTS.lookAtBattle(faction, tile)
    local factionData = STORE.factionsData[faction]
    Player[factionData.color].lookAt({
        position = tile.getPosition(),
        pitch = 70,
        yaw = tile.getRotation().y,
        distance = 50
    })
end

function BATTLE_SCRIPTS.moveUnitsToBattle(fighter, tile)
    local count = 0
    BATTLE_SCRIPTS.saveUnitsPositions(fighter.units)
    for _, v in ipairs(fighter.units) do
        v.setRotation({0, tile.getRotation().y, v.getRotation().z})
        v.setPositionSmooth(BATTLE_SCRIPTS.getUnitPosition(tile, count))
        count = count + 1
    end
end

-- unitsPositions is a table created on load, global variable
function BATTLE_SCRIPTS.saveUnitsPositions(units)
    for _, v in ipairs(units) do
        COMBAT.unitsPositions[v.getGUID()] = v.getPosition()
    end
end

function BATTLE_SCRIPTS.getUnitPosition(tile, count)
    local diceWidth, diceHeight = 2, 2
    local sign = math.cos(tile.getRotation().y * math.pi / 180)
    local position = tile.getPosition()
    position.y = 3
    position.x = position.x - tile.getBounds().size.x / 2 + diceWidth / 2 + count * diceWidth
    position.z = position.z + sign * tile.getBounds().size.z / 2 - sign * diceHeight / 2 - sign * 3 * diceHeight
    position.z = position.z - sign * 4
    return position
end

return BATTLE_SCRIPTS
