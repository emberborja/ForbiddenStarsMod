-- idk if this will be needed but here it is anyway
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
}

{
  "" = "",
  -- 48db4f guid for eldar combat cards deck
  "" = "Howling Banshees",
  "" = "Striking Scorpions",
  "" = "Hit and run",
  "" = "Command of the Autarch",
  "" = "Ranger support",
  "e1dad3" = "Fire Dragon's vengeance",
  "cc904d" = "Swooping Hawks",
  "94b219" = "Wraithguard advance",
  "633154" = "Wraithguard support",
  "1fe05a" = "Fire Prism",
  "b8e7d6" = "Wave Serpent",
  "207cbc" = "Spiritseer's guidance",
  "183a08" = "Holofield emitter",
  "6fed86" = "Psychic lance",
}




-- faction data -> deckZoneGUID this is the faction combat deck
--[[
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
--]]
-- cardsData -> [card name] : [ icons: [''], faction: '']
-- ie ["Impure zeal"] = {icons={"b", "s"}, faction="ch"},
--[[
function takeCardHome(card)
  local cardData = cardsData[card.getName()]
  local factionData = factionsData[cardData.faction]
  local zone = getObjectFromGUID(factionData.deckZoneGUID)

  if putCardInDeck(card, zone) == false then
    moveCardToDeck(card, zone)
  end
end
--]]
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

function getFactionDataByColor(color)
  for k,v in pairs(factionsData) do
    if v.color == color then
      return v
    end
  end

  return nil
end

function upgradeCards(deck, playerColor)
    if (not state.combatLock[playerColor]) then
      state.combatLock[playerColor] = true
      local combatDeck = getObjectFromGUID(state.combatDecks[playerColor])
      if (combatDeck == nil) then
        combatDeck = findCombatDeckForColor(playerColor)
        state.combatLock[playerColor] = false
        return
      end
      if (#combatDeck.getObjects() < 10) then
        log("Invalid combat deck, please wait")
        state.combatLock[playerColor] = false
        return
      end
      if (closeTo(combatDeck.getRotation().z, 180, 1)) then
        combatDeck.flip()
      end
      if (combatDeck ~= nil) then
        state.plannedUpgrades[playerColor] = deck.getGUID()
        local cards = combatDeck.getObjects()
        local cardNamesToGuids = {}
        for k, card in pairs(cards) do
          if (not cardNamesToGuids[card.nickname]) then
            cardNamesToGuids[card.nickname] = {}
          end
          table.insert(cardNamesToGuids[card.nickname], card.guid)
        end
  
        local counter = 0
        state.floatingCards[playerColor] = cardNamesToGuids
        state.combatDeckPositions[playerColor] = vector_convertor(combatDeck.getPosition())
        for cardName, guids in pairs(cardNamesToGuids) do
          local goto1 = copyTable(combatDeck.getPosition())
          goto1.x = goto1.x - (10) + (counter * 4)
          goto1.y = 5
          local goto2 = copyTable(goto1)
          goto2.y = goto2.y - 0.1
          local card1 = combatDeck.takeObject({guid = guids[1]})
          card1.setPositionSmooth(goto1)
          local cardRotation = playerCardRotation(playerColor)
          card1.setRotationSmooth(cardRotation)
          card1.setLock(true)
          cardbutton(card1, "DIS", "finishUpgrade")
          if (counter < 4) then
  
            local card2 = combatDeck.takeObject({guid = guids[2]})
            log(card2.getGUID())
            card2.setPositionSmooth(goto2)
            card2.setRotationSmooth(cardRotation)
            card2.setLock(true)
          else
  
            local id = "moveCard" .. guids[2]
            Timer.destroy(id)
            Timer.create(
              {
                identifier = id,
                function_name = "moveObj",
                parameters = {guid = guids[2], pos = goto2, lock = true},
                delay = 0.1
              }
            )
          end
          counter = counter + 1
        end
      else
        broadcastToAll("Could not find combat deck for player " .. playerColor)
        state.combatLock[playerColor] = false
      end
    end
  end
  
  function finishUpgrade(clickedCard, playerColor)
    local betterCards = getObjectFromGUID(state.plannedUpgrades[playerColor])
    local sideTablePos = copyTable(betterCards.getPosition())
    local cardNamesToGuids = state.floatingCards[playerColor]
    local combatDeckPosition = copyTable(state.combatDeckPositions[playerColor])
    local height = 1.5
    local combatCardGuid
    local discardCardGuid
    local cardRotation = playerCardRotation(playerColor)
    local cardFaceDown = {x = cardRotation.x, y = cardRotation.y, z = cardRotation.z + 180}
    for cardName, guids in pairs(cardNamesToGuids) do
      for k, guid in pairs(guids) do
        local card = getObjectFromGUID(guid)
        if (cardName == clickedCard.getName()) then
          sideTablePos.y = height
          card.setPositionSmooth(sideTablePos)
          card.setRotationSmooth(cardRotation)
          card.setLock(false)
          card.use_snap_points = false
          card.use_grid = false
          card.hide_when_face_down = true
          discardCardGuid = card.getGUID()
        else
          combatDeckPosition.y = height
          card.setPositionSmooth(combatDeckPosition)
          card.setRotationSmooth(cardFaceDown)
          card.setLock(false)
          card.use_snap_points = false
          card.use_grid = false
          card.hide_when_face_down = true
          card.clearButtons()
          combatCardGuid = card.getGUID()
        end
        height = height + 0.1
      end
    end
    local betterGuids = {}
    for k, cardTab in pairs(betterCards.getObjects()) do
      table.insert(betterGuids, cardTab.guid)
    end
    local card1 = betterCards.takeObject({guid = betterGuids[1]})
    local card2 = betterCards.remainder
    if card1.getName():len() == 0 then
      card1.setName(card2.getName())
    end
    if card2.getName():len() == 0 then
      card2.setName(card1.getName())
    end
    combatDeckPosition.y = height
    card1.clearButtons()
    height = height + 0.1
    combatDeckPosition.y = height
  
    timer(betterGuids[1], "moveObj", {guid = betterGuids[1], rot = cardFaceDown, pos = combatDeckPosition, lock = false}, 0.1)
    timer(betterGuids[2], "moveObj", {guid = betterGuids[2],  rot = cardFaceDown, pos = combatDeckPosition, lock = false}, 0.2)
    timer(playerColor, "refindCombatDeck", {discard = discardCardGuid, combat = combatCardGuid, player = playerColor}, 3)
    timer(playerColor, "unlockCombat", {playerColor = playerColor}, 4)
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