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