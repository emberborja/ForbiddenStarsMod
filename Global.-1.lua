--[[ Lua code. See documentation: http://berserk-games.com/knowledgebase/scripting/ --]]

--[[ The OnLoad function. This is called after everything in the game save finishes loading.
Most of your script code goes here. --]]
local STORE = require("_variables")
local UTILS = require('_utils')
local BATTLE_SCRIPTS = require('_battles')

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

    updateAllContainerAmounts()
    setupBattlePanelsUI()
    drawAllGarbageZoneBorders()
    getObjectFromGUID(STORE.diceWallIDs[1]).setPosition({-40.6, 6, 0})
    getObjectFromGUID(STORE.diceWallIDs[2]).setPosition({-32.3, 6, 0.22})
    getObjectFromGUID(STORE.diceWallIDs[3]).setPosition({-24, 6, 0})
    lowerDiceWalls()
end

-- https://api.tabletopsimulator.com/events/#onobjectpeek
function onObjectPeek(object, player_color)
  testAndHideOrderTokenOnPeek(object, player_color)
end

local unhideColorMap = {}
function testAndHideOrderTokenOnPeek(object, player_color)
  local objectName = object.getName()
  local msg = player_color .. " peeked: " .. objectName
  if unhideColorMap[player_color] then Wait.stop(unhideColorMap[player_color]) end
  if string.find(objectName, "order token") and not object.is_face_down then
    local msgColor = {1, 0, 0}
    local shouldHide = false
    for faction, data in pairs(factionsData) do
      local color = data['color']
      if color == player_color then msgColor = factionColors[faction] end
      if string.find(objectName, data["name"]) and color ~= player_color then 
        shouldHide = true
      end
    end
    if shouldHide then
      object.setHiddenFrom({player_color})
      broadcastToAll(msg, msgColor)
      addWaitToUnhideObject(object, player_color)
    end
  end
end

function addWaitToUnhideObject(object, player_color)
  unhideColorMap[player_color] = Wait.frames(
    function()
      for _, player in ipairs(Player.getPlayers()) do
        if player.color == player_color then
          local hoverGuid = player.getHoverObject() and player.getHoverObject().guid
          if hoverGuid == object.guid then
            print(player_color..' still hovering')
            addWaitToUnhideObject(object, player_color)
            return
          end
        end
      end
      object.setHiddenFrom({})
      unhideColorMap[player_color] = nil
    end,
    300
  )
end

-- Scan for battle button function
function fightClicked()
  local status, err = BATTLE_SCRIPTS.checkEligibleBattles(boardZone, botFightZoneGUID, topFightZoneGUID)
  if status then
    BATTLE_SCRIPTS.scanForBattles(boardZone, botFightTile, topFightTile)
  else
    printError(err)
  end
end

function raiseDiceWalls()
    adjustDiceWalls(20)
    --Wait.time(lowerDiceWalls,5)
end

function lowerDiceWalls()
    adjustDiceWalls(-20)
end

function adjustDiceWalls(heightOffset)
    for i,v in ipairs(STORE.diceWallIDs) do
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
    for k,v in pairs(STORE.factionsData) do
      local isSeatedPlayer = false
      for _, player in ipairs(Player.getPlayers()) do
          if(player.color == v.color) then isSeatedPlayer = true end
      end

      if(isSeatedPlayer) then
        counter = getObjectFromGUID(v.counterGUID)
        plus    = materiels[k] or 0
        delta   = math.min(plus, 14 - counter.call("getCount"))
        old     = counter.call("getCount")
        counter.call("setCount", counter.call("getCount") + delta)
        local materiel = v.name..": "..STORE.factionsNameFiller[k].."materiel "..old.." + "..delta.." ("..plus..") = "..counter.call("getCount")
        printMessage(materiel, v.color)
      end
    end
end

function countMateriels()
  local objs = boardZone.getObjects()
  local materiel
  local result = {}

  for i,v in ipairs(objs) do
    if string.find(v.getName(), "Tile") then
      for sector = 1, 4 do
        army = UTILS.getSectorArmy(sector, v, true)
        if #army > 0 then
          materiel = UTILS.getTileData(v)[UTILS.normalizeSectorNumber(sector, v)].materiel or 0
          result[army[1].faction] = result[army[1].faction] or 0
          result[army[1].faction] = result[army[1].faction] + materiel
        end
      end
    end
  end
  return result
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
  local battles = UTILS.getAllBattles(boardZone, true)

  if #battles > 0 then
    return false, "I can't count materiels! There are active battles on "..UTILS.concatTileNames(battles)
  end

  return true
end

function onObjectDrop(player, object)
    if STORE.showSectorBorders and (STORE.unitsData[object.getName()] or STORE.buildingsData[object.getName()]) then
        updateTileBorders()
    end
    checkGarbageZones()
end

function checkGarbageZones()
    for _, id in ipairs(STORE.garbageZoneIDs) do
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
    for _, id in ipairs(STORE.garbageZoneIDs) do
        drawGarbageZoneBorders(id)
    end
end

function drawGarbageZoneBorders(id)
    zone = getObjectFromGUID(id)
    zone.setVectorLines({
        createLine({{0.5, -0.5, 0.5}, {0.5, -0.5, -0.5}, {-0.5, -0.5, -0.5}, {-0.5, -0.5, 0.5}, {0.5, -0.5, 0.5}}, STORE.lineColor)
    })
end

function toggleBordersClicked(player, value, id)
    STORE.showSectorBorders = value == "True"
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
    if STORE.showSectorBorders then
        lines[1] = createTileBorderMiddleLine(true,  tile.is_face_down)
        lines[2] = createTileBorderMiddleLine(false, tile.is_face_down)
        local index = 3
        local army
        for i = 1, 4 do
            army = UTILS.getSectorArmy(i, tile, true)
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
    local c = STORE.factionColors[faction]
    local xz, g, l, y = 2.6, 0.1, 0.2, STORE.borderLineY
    local xOffA, yOffA, xOffB, yOffB, offset = 0, 0, 0, 0, xz + g
    if tileFlipped then y = -STORE.borderLineY end
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
    local y = STORE.borderLineY
    if vertical then x = 2.8 else z = 2.8 end
    if tileFlipped then y = -STORE.borderLineY end
    return createLine({{x,y,z}, {-x,y,-z}}, STORE.lineColor)
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

  factionData = factionData or STORE.factionsData["ch"]

  if getDiceCount(getObjectFromGUID(zoneGUID)) < 8 then
    UTILS.addDiceToTile(tile, factionData.diceBagGUID)
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
  for k,v in pairs(STORE.factionsData) do
    if v.color == color then
      return v
    end
  end

  return nil
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

function printError(text)
  broadcastToAll(text, {1, 0, 0})
end

function printMessage(text, customColor)
  local messageColor = customColor or {0, 1, 0.2}
  broadcastToAll(text, messageColor)
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
    if STORE.cardsData[v.getName()] ~= nil then
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
  local cardData = STORE.cardsData[card.getName()]
  local factionData = STORE.factionsData[cardData.faction]
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
  if STORE.unitsData[obj.getName()] then
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
    if #STORE.rollingDices == 0 then
        if STORE.wallsUp then
            lowerDiceWalls()
            STORE.wallsUp = false
        end
        return
    end

    if not STORE.wallsUp then
        raiseDiceWalls()
        STORE.wallsUp = true
    end

    for i, v in ipairs(STORE.rollingDices) do
        if v == nil then break end
        if v.resting == false then return end
    end

    STORE.rollingDices = {}
    calculate()
    sortObjects()
    lowerDiceWalls()
    STORE.wallsUp = false
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
      table.insert(STORE.rollingDices, obj)
    end
end

function haveRollingDice(dice)
  for i,v in ipairs(STORE.rollingDices) do
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
  for k,v in pairs(STORE.unitsData) do
    if v.faction == faction and v.reinf == reinf then
      return k
    end
  end
end

function createUnitUI(obj)
  local hp = STORE.unitsData[obj.getName()].hp
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
  local data = STORE.unitsData[unit.getName()]
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

    if STORE.unitsData[obj.getName()] then
      obj.UI.setXmlTable({{}})
    end
  end
end

function calculate()
    local bottomFightZone = getObjectFromGUID(botFightZoneGUID)
    local bottomFightZoneObjects = bottomFightZone and bottomFightZone.getObjects()
    if(not bottomFightZoneObjects) then return end
    local botStats = getStatsForObjects(bottomFightZoneObjects)
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

    unitData = STORE.unitsData[v.getName()]
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
  local cardIcons = STORE.cardsData[card.getName()] and STORE.cardsData[card.getName()].icons or nil

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

function updateAllContainerAmounts()
    for k,v in pairs(STORE.unitsData) do
        updateContainerAmount(getObjectFromGUID(v.bagGUID))
    end
end

function updateContainerAmount(container)
    local containerAmount = container.UI.getValue("amount")
    if containerAmount then
      container.UI.setValue("amount", container.getQuantity())
    end
end