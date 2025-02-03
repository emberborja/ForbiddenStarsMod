local STORE = require("_variables")

local UTILS = {}

UTILS.onDiceAdded = function(dice)
    dice.randomize("someColor")
end

UTILS.addDiceToTile = function(tile, bagGUID)
    local position = tile.getPosition()
    local bounds = tile.getBounds().size

    position.y = 3
    position.x = math.random(position.x - bounds.x / 3, position.x + bounds.x / 3)
    position.z = math.random(position.z - 2, position.z + 2)
    getObjectFromGUID(bagGUID).takeObject({
        position = position,
        callback_function = UTILS.onDiceAdded
    })
end

UTILS.getTileData = function(tile)
    local num = tile.getName()
    local letter
    num = string.sub(num, string.len("Tile ") + 1)
    letter = tile.is_face_down and "B" or "A"
    return STORE.tilesData[num .. letter]
end

UTILS.normalizeSectorNumber = function(sector, tile)
    local offset = UTILS.round(tile.getRotation().y / 90)
    sector = sector - offset
    if sector < 1 then
        sector = 4 + sector
    end
    if sector > 4 then
        sector = math.fmod(sector, 4)
    end
    return sector
end

UTILS.concatTileNames = function(battles)
    local result = ""

    for i, v in ipairs(battles) do
        result = result .. v.tileName .. ", "
    end

    return string.sub(result, 1, string.len(result) - 2)
end

UTILS.getSectorArmy = function(sector, tile, isCountBuildings)
    local army
    army = sortObjectsByFactions(getSectorObjects(tile, sector), isCountBuildings)
    return convertArmyToArray(army)
end

function convertArmyToArray(army)
    local result = {}
    for k, v in pairs(army) do
        table.insert(result, {
            faction = k,
            units = v
        })
    end

    return result
end

function sortObjectsByFactions(objs, isCountBuildings)
    local army = {}
    local faction, unitData, buildingData

    for i, v in ipairs(objs) do
        faction = STORE.unitsData[v.getName()] and STORE.unitsData[v.getName()].faction
        faction = faction or (isCountBuildings and STORE.buildingsData[v.getName()])
        if faction then
            army[faction] = army[faction] or {}
            table.insert(army[faction], v)
        end
    end

    return army
end

function getSectorObjects(tile, sector)
    local position = tile.getPosition()
    local signX = {-1, 1, 1, -1}
    local signZ = {1, 1, -1, -1}
    local data, objs = {}, {}
    position.x = position.x + signX[sector] * tile.getBounds().size.x / 4
    position.z = position.z + signZ[sector] * tile.getBounds().size.z / 4
    data = Physics.cast({
        origin = position,
        type = 3,
        size = {5, 5, 5},
        direction = {0, 1, 0},
        max_distance = 0
    })

    for i, v in ipairs(data) do
        table.insert(objs, v.hit_object)
    end
    return objs
end

UTILS.round = function(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

function printTable(tab)
    for key, value in pairs(tab) do
        print("key: " .. key .. " value: ")
        print(value)
    end
end

return UTILS

-- alternative way to get object rotation, but can't attach to an object >:-|
--[[ 
function onObjectRotate(object, spin, flip, player_color, old_spin, old_flip)
  if spin ~= old_spin then
      print(player_color .. " spun " .. tostring(object) .. " from " .. old_spin .. " degrees to " .. spin .. " degrees")
  end
-- flip 180 means right side up
  if flip ~= old_flip then
      print(player_color .. " flipped " .. tostring(object) .. " from " .. old_flip .. " degrees to " .. flip .. " degrees")
  end
end ]]