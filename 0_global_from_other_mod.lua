loaded = false

function vector_convertor(v)
  return {x = v.x, y = v.y, z = v.z}
end

function detailedbutton(domino, label, fn, font_size)
  local button = {}
  button.width = 1300
  button.height = 600
  button.position = {0, -0.2, 0}
  button.rotation = {180, 90, 0}
  button.click_function = fn
  button.label = label
  button.font_size = font_size
  button.function_owner = nil
  button.tooltip = label
  domino.createButton(button)
  domino.hide_when_face_down = false
  state.buttons[domino.getGUID()] = button
end

function button(domino, label, fn)
  detailedbutton(domino, label, fn, 180)
end

function cardbutton(card, label, fn)
  local button = {}
  button.width = 125 * string.len(label)
  button.height = 250
  button.position = {0, 2, 0}
  button.rotation = {0, 0, 0}
  button.click_function = fn
  button.label = label
  button.font_size = 180
  button.function_owner = nil
  card.createButton(button)
  state.buttons[card.getGUID()] = button
end

function backcardbutton(card, label, fn)
  local button = {}
  button.width = 125 * string.len(label)
  button.height = 250
  button.position = {0, -2, 0}
  button.rotation = {0, 0, 180}
  button.click_function = fn
  button.label = label
  button.font_size = 180
  button.function_owner = nil
  card.createButton(button)
  state.buttons[card.getGUID()] = button
end

function removeButtons(obj)
  obj.clearButtons()
  state.buttons[obj.getGUID()] = nil
end

function recreateButtons()
  for objGuid, buttonTab in pairs(state.buttons) do
    local obj = getObjectFromGUID(objGuid)
    if (obj ~= nil) then
      obj.createButton(buttonTab)
    end
  end
  for objGuid, option in pairs(state.optionButtons) do
    log("Setting option color for " .. tostring(objGuid) .. " to state " .. tostring(state.options[option]) .. " for option " .. tostring(option))
    setOptionColor(getObjectFromGUID(objGuid), state.options[option])
  end
end

function copyTable(tab)
  local result = {}
  for k, v in pairs(tab) do
    result[k] = v
  end
  return result
end

function tabToS(tab)
  local s = "{"
  for k, v in pairs(tab) do
    s = s .. k .. "=" .. tostring(v) .. ","
  end
  s = s .. "}"
  return s
end

-- fixed data

commandTokenRotation = {x = 0, y = 180, z = 0}
diceRotations = {
  Red = {
    gun = {x = 270.0, y = 0.0, z = 0.0},
    shield = {x = 0.0, y = 0.0, z = 0.0},
    morale = {x = 0.0, y = 360.0, z = 270.0}
  },
  Green = {
    gun = {x = 270.00, y = 180.00, z = 0.00},
    shield = {x = 0.00, y = 180.00, z = 0.00},
    morale = {x = 0.00, y = 180.00, z = 270.00}
  },
  Blue = {
    gun = {x = 270.00, y = 180.00, z = 0.00},
    shield = {x = 0.00, y = 180.00, z = 0.00},
    morale = {x = 0.00, y = 180.00, z = 270.00}
  },
  Yellow = {
    gun = {x = 270.0, y = 0.0, z = 0.0},
    shield = {x = 0.0, y = 0.0, z = 0.0},
    morale = {x = 0.0, y = 360.0, z = 270.0}
  }
}

dicePositions = {
  Red = {
    gun = {x = -42.22, y = 1.91, z = -10.24},
    shield = {x = -42.24, y = 1.91, z = -12.19},
    morale = {x = -42.26, y = 1.91, z = -14.21},
    combatCard = {x = -40.26, y = 1.1, z = -20.21},
    dir = 1
  },
  Green = {
    gun = {x = -31.55, y = 1.91, z = 10.12},
    shield = {x = -31.55, y = 1.91, z = 12.15},
    morale = {x = -31.55, y = 1.91, z = 14.15},
    combatCard = {x = -29.55, y = 1.1, z = 20.12},
    dir = -1
  },
  Blue = {
    gun = {x = 42.00, y = 1.91, z = 10.12},
    shield = {x = 42.00, y = 1.91, z = 12.12},
    morale = {x = 42.00, y = 1.91, z = 14.12},
    combatCard = {x = 40.00, y = 1.1, z = 20.12},
    dir = -1
  },
  Yellow = {
    gun = {x = 31.29, y = 1.91, z = -10.24},
    shield = {x = 31.29, y = 1.91, z = -12.19},
    morale = {x = 31.29, y = 1.91, z = -14.21},
    combatCard = {x = 33.29, y = 1.1, z = -20.21},
    dir = 1
  }
}
diceTrayZones = {
  ["a683b5"] = {player = "Red", side = "gun", dir = 1},
  ["4ad533"] = {player = "Red", side = "shield", dir = 1},
  ["c50b56"] = {player = "Red", side = "morale", dir = 1},
  ["f3b87d"] = {player = "Green", side = "gun", dir = -1},
  ["28da53"] = {player = "Green", side = "shield", dir = -1},
  ["1ac1b8"] = {player = "Green", side = "morale", dir = -1},
  ["1c39c8"] = {player = "Blue", side = "gun", dir = -1},
  ["eff97e"] = {player = "Blue", side = "shield", dir = -1},
  ["1581fb"] = {player = "Blue", side = "morale", dir = -1},
  ["666cb1"] = {player = "Yellow", side = "gun", dir = 1},
  ["61409a"] = {player = "Yellow", side = "shield", dir = 1},
  ["7f86d5"] = {player = "Yellow", side = "morale", dir = 1}
}
sideTableZones = {
  ["a53bc5"] = {player = "Blue"},
  ["7a2f2b"] = {player = "Yellow"},
  ["56ae34"] = {player = "Red"},
  ["ffaf4b"] = {player = "Green"}
}
diceSideMap = {"gun", "gun", "gun", "shield", "shield", "morale"}

dieXWidth = 1.56

playerHighlights = {
  ["Red"] = {r = 1, b = 0.0, g = 0.0},
  ["Yellow"] = {r = 1, b = 0.0, g = 1},
  ["Blue"] = {r = 0.0, b = 1, g = 0.0},
  ["Green"] = {r = 0.0, b = 0.0, g = 1}
}

tileRadius = 6.25
MAIN_BOARD_ZONE = "288d26"

default_state = {
  reinforceTokensToPlayer = {},
  combatTokensToPlayer = {},
  combatDecks = {},
  combatDeckPositions = {},
  plannedUpgrades = {},
  floatingCards = {},
  combatDice = {},
  combatEndDecks = {},
  playedCombatCards = {Red = {}, Green = {}, Yellow = {}, Blue = {}},
  playerCombatStartButtons = {},
  combatDeckContents = {},
  playerCombatDomino = {},
  combatLock = {
    Red = false,
    Yellow = false,
    Blue = false,
    Green = false
  },
  commandTokenObjects = {},
  factionButtons = {},
  customFactionBags = {
    ["Emp's Children"] = "4f3890",
    ["Thousand Sons"] = "e4ad4a",
    ["World Eaters"] = "40b0d1",
    ["Death Guard"] = "51df0b",
  },
  factionAssigned = {},
  buttons = {},
  putBackFaction = {},
  options = {
    ["Tile Helper"] = false,
    ["Blank State"] = false,
    ["Save State"] = true
  },
  optionButtons = {}
}

state = {}

customFactions = {
  ["Death Guard"] = [[{
    "factionBag": "51df0b",
    "modelPiles": [
      "e0595a",
      "83f21a",
      "fa55d0",
      "87df5d",
      "46b963",
      "56dd8f"
    ],
    "orderTokens": {
      "advance": [
        "f1ec15",
        "d6f391"
      ],
      "deploy": [
        "de2202",
        "adec92"
      ],
      "dominate": [
        "969a12",
        "cb719a"
      ],
      "strategize": [
        "02432d",
        "aed3cd"
      ]
    },
    "startingUnits": [
      "c1c684",
      "d78895",
      "0ca874",
      "4d4ef6",
      "3f6e23",
      "a21cb9",
      "109b85"
    ]
  }]],
  ["Thousand Sons"] = [[{
    "factionBag": "51df0b",
    "modelPiles": [
      "e677bf",
      "7a9d43",
      "c321d2",
      "877f2b",
      "ee2c17",
      "21454b"
    ],
    "orderTokens": {
      "advance": [
        "423287",
        "f20013"
      ],
      "deploy": [
        "f9d246",
        "6faf2d"
      ],
      "dominate": [
        "d48b28",
        "dc1152"
      ],
      "strategize": [
        "a28769",
        "8c2b92"
      ]
    },
    "startingUnits": [
      "d4e1cc",
      "382a0c",
      "fe6ca7",
      "75d149",
      "0865df",
      "9b4809",
      "0232b1"
    ]
  }]],
  ["Emp's Children"] = [[{
    "factionBag": "51df0b",
    "modelPiles": [
      "09adac",
      "a2b965",
      "4de571",
      "c6345f",
      "081a97",
      "f1198a"
    ],
    "orderTokens": {
      "advance": [
        "45d5db",
        "adec92"
      ],
      "deploy": [
        "89bebf",
        "cb719a"
      ],
      "dominate": [
        "c0f654",
        "f39507"
      ],
      "strategize": [
        "aca162",
        "aed3cd"
      ]
    },
    "startingUnits": [
      "79269e",
      "bdb09d",
      "0c8621",
      "4694cf",
      "1d6f4f",
      "48a1d3"
    ]
  }]],
  ["World Eaters"] = [[{
    "factionBag": "51df0b",
    "modelPiles": [
      "87b0df",
      "3ec97c",
      "410dc8",
      "a4a279",
      "0de8cd",
      "f04c17"
    ],
    "orderTokens": {
      "advance": [
        "acaabf",
        "eb93b1"
      ],
      "deploy": [
        "5292fb",
        "d6f391"
      ],
      "dominate": [
        "cb719a",
        "adec92"
      ],
      "strategize": [
        "c0f654",
        "aed3cd"
      ]
    },
    "startingUnits": [
      "9a57d2",
      "6322ee",
      "277536",
      "9f2a26",
      "72d006",
      "b67ddc"
    ]
  }]],
}

function onSave()
  if (state.options["Save State"]) then
    return JSON.encode(state)
  else
    local stateToSave = copyTable(default_state)
    stateToSave.options = state.options
    return JSON.encode(stateToSave)
  end
end

function onObjectSpawn(object)
  if (string.find(object.getName(), "order token")) then
    setOnCollisionEnter({object.getGUID()}, "commandTokenCollision")
  end
end

function prepSystemTile(tileObj)
  log("Prepping system tile")

  tileObj.setName("System tile")
  bounds = tileObj.getBoundsNormalized()
  currentXRadius = bounds.size.x / 2
  currentZRadius = bounds.size.z / 2
  log("Current tile size is " .. currentXRadius .. ":" .. currentZRadius .. " to tile")

  xscale = tileRadius / currentXRadius
  zscale = tileRadius / currentZRadius
  tileObj.scale({x = xscale, z = zscale, y = 1})
  log("Applied scale " .. xscale .. ":" .. zscale .. " to tile")

  local customObj = tileObj.getCustomObject()
  if customObj ~= nil and customObj.type == 4 then
    customObj.type = 0
    tileObj.setCustomObject(customObj)
    tileObj.reload()
  end
end

function onObjectLeaveContainer(container, leave_object)
  if container.getGUID() == "cb678c" then
    Wait.frames(function()
    prepSystemTile(leave_object)
    end, 2)
  end
end

function onLoad(statestring)
  -- statestring = ""
  log("Loading v2")

  --setOnCollisionEnter(findAllLike('order token'), 'commandTokenCollision')
  --setOnCollisionEnter(findAllWithTag('Bag'), 'bagCollision')
  --setOnCollisionEnter(findAllLike('Combat Pawn'), 'combatPawnCollision')
  --clearLua(findAllWithTag('Infinite'))
  --clearLua(findAllLike('order token'))
  --clearLua(findAllWithTag('Bag'))

  local blankState = false

  if (statestring ~= "") then
    local teststate = JSON.decode(statestring)
    if (teststate and teststate.options and teststate.options["Blank State"]) then
      blankState = true
    end
  end

  if (blankState) then
    statestring = ""
  end

  if (statestring == "") then
    log("Recreating state")
    --noinspection GlobalCreationOutsideO
    state = copyTable(default_state)
    state.options["Blank State"] = blankState
    setupButtons()
  else
    log("Loading state")
    --noinspection GlobalCreationOutsideO
    state = JSON.decode(statestring)
    setupButtons()
    recreateButtons()
  end
end

function onChat(message, color)
  if (message == "renameDecks") then
    print("renaming...")
    nameDecks()
    return false
  end
  if (message == "uniqueDecks") then
    print("uniqueing...")
    uniqueDecks()
    return false
  end
  if (message == "dieDistribution") then
    printDieDistribution()
    return false
  end
  if (string.match(message, "^assignFaction .*")) then
    print("assigning...")
    assignedFactionName = string.match(message, " .*")
    return false
  end
  if(string.match( message,"swap .*")) then
    color1, color2 = string.match(message, "swap ([^ ]+) ([^ ]+)")
    swapPlayerColors(color1, color2)
    return false
  end
  if(string.match( message,"randomizeColors")) then
    randomizeColorPositions()
    return false
  end
end

function printDieDistribution()
  local guns = Global.getVar("gunTimesRolled")
  local shields = Global.getVar("shieldTimesRolled")
  local morale = Global.getVar("moraleTimesRolled")

  if not guns then
    guns = 0
  end

  if not shields then
    shields = 0
  end

  if not morale then
    morale = 0
  end

  local total = (guns + shields + morale) * 1.0
  print("Total dice rolled: " .. total)

  print(
    "Side distribution:\nGuns: " ..
      (guns / total) .. "\nShields: " .. (shields / total) .. "\nMorale: " .. (morale / total)
  )
end

function uniqueDecks()
  local objs = getAllObjects()
  local cardsToDeckName = {}
  for k, obj in pairs(objs) do
    if (obj.tag == "Deck") then
      local p = obj.getPosition()
      local cards = obj.getObjects()
      local height = 1
      for i, c in pairs(cards) do
        obj.takeObject(
          {
            guid = c.guid,
            position = {p[1], p[2] + height, p[3]}
          }
        )
        height = height + 0.5
      end
    end
  end
end

nameSwaps = {
  ["3"] = "Combat upgrades (LV 3)",
  ["2"] = "Combat upgrades (LV 2)",
  ["0"] = "Combat upgrades (LV 0)"
}

function nameDecks()
  local objs = getAllObjects()
  local cardsToDeckName = {}
  for k, obj in pairs(objs) do
    if (obj.tag == "Deck") then
      local desc = obj.getDescription()
      local name = obj.getName()
      if (nameSwaps[name]) then
        name = nameSwaps[name]
      end
      local p = obj.getPosition()
      local cards = obj.getObjects()
      local card1 =
        obj.takeObject(
        {
          guid = cards[1].guid,
          position = {p[1], p[2] + 2, p[3]}
        }
      )
      Timer.create(
        {
          identifier = cards[1].guid,
          function_name = "rename",
          parameters = {guid = cards[1].guid, name = desc},
          delay = 0.5
        }
      )
      Timer.create(
        {
          identifier = cards[2].guid,
          function_name = "rename",
          parameters = {guid = cards[2].guid, name = desc},
          delay = 0.5
        }
      )
      cardsToDeckName[card1.getGUID()] = name
    end
  end
  Timer.create(
    {
      identifier = "name decks",
      function_name = "finishNameDecks",
      parameters = {cardsToDeckName = cardsToDeckName},
      delay = 5
    }
  )
end

function rename(params)
  local o = getObjectFromGUID(params.guid)
  o.setName(params.name)
end

function finishNameDecks(params)
  local cardsToDeckName = params.cardsToDeckName
  local objs = getAllObjects()
  for k, obj in pairs(objs) do
    if (obj.tag == "Deck") then
      for k2, card in pairs(obj.getObjects()) do
        if (cardsToDeckName[card.guid] ~= nil) then
          obj.setName(cardsToDeckName[card.guid])
        end
      end
    end
  end
end

function concatArrs(arrs)
  local result = {}
  for k, a in pairs(arrs) do
    for k2, v in pairs(a) do
      table.insert(result, v)
    end
  end
  return result
end

factionInitInfo = {
  Chaos = {
    orderTokens = {
      advance = {"911f30", "656f0c"},
      deploy = {"2d02ab", "7fc185"},
      strategize = {"787faf", "b5b9ec"},
      dominate = {"5244ce", "2607fc"}
    },
    startingUnits = {
      "49b1f8",
      "87a502",
      "9e22f7",
      "983186",
      "7d20fd",
      "15d8a0"
    },
    modelPiles = {
      "36cbd8",
      "14836a",
      "632bba",
      "e73481",
      "e3f272",
      "aa302c"
    },
    factionBag = "bff26b"
  },
  Eldar = {
    orderTokens = {
      advance = {"ea7418", "91d7c0"},
      deploy = {"8ec1f0", "99d309"},
      strategize = {"9d41d1", "b05da8"},
      dominate = {"525259", "a68c5d"}
    },
    startingUnits = {
      "06ff1f",
      "05139e",
      "9fa8cc",
      "994392",
      "51e527",
      "9cd9d3",
      "9479b9"
    },
    modelPiles = {
      "26e79f",
      "581425",
      "4b093a",
      "f16fe6",
      "3b40cb",
      "5c09c9"
    },
    factionBag = "a67614"
  },
  ["Space Marines"] = {
    orderTokens = {
      advance = {"e51f7b", "080a73"},
      deploy = {"cd262d", "f70c5d"},
      strategize = {"d36c19", "d2e8ea"},
      dominate = {"e3142f", "88b2c7"}
    },
    startingUnits = {
      "9f9cfe",
      "b5c001",
      "e5db19",
      "c06264",
      "6a0d9f",
      "65835a",
      "f7ac1c"
    },
    modelPiles = {
      "90596a",
      "bbfa5a",
      "ad6b7f",
      "3a3e84",
      "145d82",
      "06cc47"
    },
    factionBag = "8984b5"
  },
  Orks = {
    orderTokens = {
      advance = {"f20013", "ff822a"},
      deploy = {"6faf2d", "b23647"},
      strategize = {"3bf6c2", "8c2b92"},
      dominate = {"d48b28", "05f879"}
    },
    startingUnits = {
      "716219",
      "0b4934",
      "a72c09",
      "fa50a5",
      "ca69f1",
      "d28224",
      "c1c684"
    },
    modelPiles = {
      "6c4efd",
      "b8e6b9",
      "6f4d29",
      "cab63c",
      "5ab3e3",
      "7ece2b"
    },
    factionBag = "114154"
  },
  ["Imperial Guard"] = {
    orderTokens = {
      advance = {"e30b66", "0a7090"},
      deploy = {"c0f11b", "477d0f"},
      strategize = {"df1507", "0a8b59"},
      dominate = {"4a5065", "a30c48"}
    },
    startingUnits = {
      "6132cb",
      "69151d",
      "75c4ab",
      "08a518",
      "610487",
      "df09e0",
      "bdb09d"
    },
    modelPiles = {
      "2977c8",
      "3b6fc7",
      "b54571",
      "3baf8a",
      "81049c",
      "938fbc"
    },
    factionBag = "73fe3f",
    cardAdjust = {5, 0, 0}
  },
  Tyranids = {
    orderTokens = {
      advance = {"92e042", "df645e"},
      deploy = {"a274fd", "bc5ed0"},
      strategize = {"f45433", "4fa90e"},
      dominate = {"a85d8e", "867bad"}
    },
    startingUnits = {
      "b4e44d",
      "67ffaf",
      "8b487b",
      "d2cb45",
      "a28843",
      "f4c47a",
      "bdb09d",
      "93162e"
    },
    modelPiles = {
      "f13562",
      "1d90ae",
      "ca58cc",
      "6371bc",
      "46a926",
      "6e9720"
    },
    factionBag = "a3ca69",
    cardAdjust = {5, 0, 0}
  },
  Necrons = {
    orderTokens = {
      advance = {"6b0aaf", "bee4f2"},
      deploy = {"7803fb", "c8ad1f"},
      strategize = {"801153", "b692ea"},
      dominate = {"c02ed7", "aadbd2"}
    },
    startingUnits = {
      "78cffc",
      "3c25bf",
      "afe30d",
      "f4c47a",
      "36eb36",
      "bdb09d",
      "7b83d1"
    },
    modelPiles = {
      "114730",
      "4bf366",
      "d6c079",
      "6bfbc3",
      "bd04f2",
      "a40ac2"
    },
    factionBag = "5afca1",
    cardAdjust = {5, 0, 0}
  },
  Tau = {
    orderTokens = {
      advance = {"960f1e", "5e2cd7"},
      deploy = {"eee83b", "cd8ac7"},
      strategize = {"363c79", "7b9d34"},
      dominate = {"d510b6", "def40f"}
    },
    startingUnits = {
      "d39392",
      "5cbe52",
      "9231c3",
      "bc327f",
      "e2edb1",
      "bdb09d"
    },
    modelPiles = {
      "994d72",
      "857a63",
      "7550af",
      "eefd1a",
      "0d84a8",
      "24e241"
    },
    factionBag = "0925c3",
    cardAdjust = {5, 0, 0}
  }
}

function getByPred(objectDescriptors, pred)
  local results = {}
  for index, desc in pairs(objectDescriptors) do
    if (pred(desc)) then
      table.insert(results, desc.guid)
    end
  end
  return results
end

function getByNameLike(objectDescriptors, name)
  local result =
    getByPred(
    objectDescriptors,
    function(desc)
      return string.find(string.lower(desc.name), string.lower(name))
    end
  )
  return result
end

function getByName(objectDescriptors, name)
  local result =
    getByPred(
    objectDescriptors,
    function(desc)
      return string.lower(desc.name) == string.lower(name)
    end
  )
  return result
end

function swapKey(tab, key1, key2)
  local val1 = tab[key1]
  tab[key1] = tab[key2]
  tab[key2] = val1
end

function swapValEntry(tab, key, val1, val2)
  for k,v in pairs(tab) do
    if(v[key] == val1) then
      v[key] = val2
    elseif (v[key] == val2) then
      v[key] = val1
    end
  end
end

function swapObjects(obj1, obj2)
  local pos1 = obj1.getPosition()
  local rot1 = obj1.getRotation()
  local pos2 = obj2.getPosition()
  local rot2 = obj2.getRotation()

  obj1.setPosition(pos2)
  obj1.setRotation(rot2)

  obj2.setPosition(pos1)
  obj2.setRotation(rot1)
end

function swapPlayerColors(color1, color2)
  local player1 = Player[color1]
  local player2 = Player[color2]

  local numHands = player1.getHandCount()

  for i=1,numHands do
    local trans1 = player1.getHandTransform(i)
    local trans2 = player2.getHandTransform(i)
    player1.setHandTransform(trans2, i)
    player2.setHandTransform(trans1, i)
  end

  swapKey(diceRotations, color1, color2)
  swapKey(dicePositions, color1, color2)
  swapValEntry(diceTrayZones, "player", color1, color2)
  swapValEntry(sideTableZones, "player", color1, color2)
  swapKey(playerInitInfo, color1, color2)

  swapObjects(getObjectFromGUID(playerDieBoards[color1]), getObjectFromGUID(playerDieBoards[color2]))
  swapObjects(getObjectFromGUID(playerHiddenZones[color1]), getObjectFromGUID(playerHiddenZones[color2]))
end

function shuffle(list)

end

function randomizeColorPositions()
  local list = {"Red", "Blue", "Green", "Yellow"}
	for i = #list, 2, -1 do
		local j = math.random(i)
		swapPlayerColors(list[j], list[i])
	end
end

playerDieBoards = {
  Red = "7d6880",
  Yellow = "566382",
  Green = "c5bb77",
  Blue = "d760de"
}

playerHiddenZones = {
  Red = "a82193",
  Yellow = "d48a52",
  Green = "3f1125",
  Blue = "5c5abb"
}

playerInitInfo = {
  Red = {
    combatStart = "713059",
    combatEnd = "e0982e",
    tokenReset = "0e761d",
    orderTokenUpperLeft = {pos = {-9.25, 1.06, -28.25}, rot = {0.00, 180, 180}},
    factionCardPos = {pos = {-18.75, 1, -30.80}, rot = {0.00, 179.85, 0.00}},
    objectiveTokenPos = {pos = {-18.41, 1.53, -33.14}, rot = {0.00, 180.00, 180.00}},
    combatDeckPos = {pos = {-27.75, 1.02, -28.75}, rot = {0.00, 180.00, 0.00}},
    eventCardPos = {pos = {-27.75, 1.01, -33.75}, rot = {0.00, 180.00, 0.00}},
    startUnitsUpperLeft = {pos = {-24.25, 0.96, -22.75}, rot = {0, 0, 0}},
    materialCounterPos = {pos = {-18.49, 1, -28.20}, rot = {0, 0, 0}},
    combatDieUpperLeft = {pos = {-61.89, 1.48, -31.75}, rot = {270.00, 360, 0.00}},
    factoryPilePos = {pos = {-59.26, 0.89, -26.02}, rot = {0, 0, 0}},
    bastionPilePos = {pos = {-59.24, 0.73, -24.09}, rot = {0, 0, 0}},
    cityPilePos = {pos = {-59.26, 1.02, -21.91}, rot = {0, 0, 0}},
    upgradeCardUpperLeft = {pos = {-78.26, 0.81, -22.68}, rot = {0.00, 180, 0.00}},
    modelPileUpperLeft = {pos = {-78.26, 1.4, -32.68}, rot = {0, 180, 0}},
    startTilePos = {pos = {-21.25, 1.11, -14.25}, rot = {0.00, 180, 180}},
    dir = 1
  },
  Yellow = {
    combatStart = "6e8dbf",
    combatEnd = "53d047",
    tokenReset = "f39151",
    orderTokenUpperLeft = {pos = {6.25, 1.06, -28.25}, rot = {0.00, 180, 180}},
    factionCardPos = {pos = {18.25, 1, -30.75}, rot = {0, 180, 0}},
    objectiveTokenPos = {pos = {18.46, 1.53, -33.16}, rot = {0, 180, 180}},
    combatDeckPos = {pos = {26.75, 1.02, -28.75}, rot = {0, 180, 0}},
    eventCardPos = {pos = {26.75, 1.01, -33.75}, rot = {0, 180, 0}},
    startUnitsUpperLeft = {pos = {17.75, 0.96, -22.75}, rot = {0, 0, 0}},
    materialCounterPos = {pos = {18.43, 1, -28.09}, rot = {0, 0, 0}},
    combatDieUpperLeft = {pos = {55.69, 1.96, -33.63}, rot = {270, 0, 0}},
    factoryPilePos = {pos = {76.45, 1.37, -26.76}, rot = {0, 0, 0}},
    bastionPilePos = {pos = {76.59, 1.21, -24.24}, rot = {0, 0, 0}},
    cityPilePos = {pos = {76.59, 1.50, -21.74}, rot = {0, 0, 0}},
    upgradeCardUpperLeft = {pos = {57.27, 1.28, -22.85}, rot = {0, 180, 0}},
    modelPileUpperLeft = {pos = {63.51, 1.4, -35.33}, rot = {0, 0, 0}},
    startTilePos = {pos = {20.75, 1.11, -13.75}, rot = {0, 180, 180}},
    dir = 1
  },
  Blue = {
    combatStart = "b06168",
    combatEnd = "75dde9",
    tokenReset = "c2f4c8",
    orderTokenUpperLeft = {pos = {9.75, 1.06, 28.25}, rot = {0, 0, 180.00}},
    factionCardPos = {pos = {18.5, 1, 30.75}, rot = {0, 0, 0}},
    objectiveTokenPos = {pos = {18.00, 1.53, 33.11}, rot = {0, 0, 180}},
    combatDeckPos = {pos = {27, 1.02, 28.75}, rot = {0, 0, 0}},
    eventCardPos = {pos = {27, 1.01, 33.75}, rot = {0, 0, 0}},
    startUnitsUpperLeft = {pos = {26.54, 0.96, 22.20}, rot = {0, 0, 0}},
    materialCounterPos = {pos = {17.96, 1, 27.72}, rot = {0, 180, 0}},
    combatDieUpperLeft = {pos = {61.00, 1.90, 32.40}, rot = {270, 180, 0}},
    factoryPilePos = {pos = {59.75, 1.31, 27.04}, rot = {0, 0, 0}},
    bastionPilePos = {pos = {59.87, 1.15, 24.24}, rot = {0, 0, 0}},
    cityPilePos = {pos = {59.86, 1.45, 21.94}, rot = {0, 0, 0}},
    upgradeCardUpperLeft = {pos = {77.99, 1.23, 21.96}, rot = {0, 0, 0}},
    modelPileUpperLeft = {pos = {78.30, 1.4, 33.54}, rot = {0, 0, 0}},
    startTilePos = {pos = {21.75, 1.11, 13.75}, rot = {0, 0, 180}},
    dir = -1
  },
  Green = {
    combatStart = "dc2e41",
    combatEnd = "a91d0c",
    tokenReset = "a2d0c5",
    orderTokenUpperLeft = {pos = {-7.25, 1.06, 28.25}, rot = {0, 0, 180}},
    factionCardPos = {pos = {-18.72, 1, 30.74}, rot = {0, 0, 0}},
    objectiveTokenPos = {pos = {-18.94, 1.53, 33.17}, rot = {0, 0, 180}},
    combatDeckPos = {pos = {-27.74, 1.02, 28.76}, rot = {0, 0, 0}},
    eventCardPos = {pos = {-27.75, 1.01, 33.75}, rot = {0, 0, 0}},
    startUnitsUpperLeft = {pos = {-18.17, 0.97, 22.25}, rot = {0, 0, 0}},
    materialCounterPos = {pos = {-19.06, 1, 28.08}, rot = {0, 180, 0}},
    combatDieUpperLeft = {pos = {-57.02, 1.68, 32.88}, rot = {270, 180, 0}},
    factoryPilePos = {pos = {-77.81, 1.09, 29.42}, rot = {0, 0, 0}},
    bastionPilePos = {pos = {-77.81, 0.93, 26.92}, rot = {0, 180, 0}},
    cityPilePos = {pos = {-77.81, 1.23, 24.92}, rot = {0, 0, 0}},
    upgradeCardUpperLeft = {pos = {-57.46, 1.00, 22.93}, rot = {0, 0, 0}},
    modelPileUpperLeft = {pos = {-64.60, 1.4, 34.75}, rot = {0, 0, 0}},
    startTilePos = {pos = {-21.75, 1.11, 14.75}, rot = {0, 0, 180}},
    dir = -1
  }
}

cardWidth = 3.7
cardHeight = 4.8

function moveToCallback(obj, params)
  obj.setLock(params.lock)
end

function moveTo(guids, pos, bag, lock, scale, transform)
  local obj =
    bag.takeObject(
    {
      guid = guids[1],
      position = pos.pos,
      rotation = pos.rot,
      smooth = false,
      callback_function = function(obj)
        if transform ~= nil then
          transform(obj)
        end
        moveToCallback(obj, {lock = lock})
      end
    }
  )
  if obj.getName() == "System tile" then
    obj.use_grid = true
    Wait.frames(function()
      prepSystemTile(obj)
      end, 5)
  else
    obj.use_grid = false
  end
  obj.use_snap_points = false
  if (scale) then
    obj.setScale(scale)
  end
end

function DIV(a, b)
  return (a - a % b) / b
end

function gridLayout(guids, pos, dir, cols, x, z, bag, lock, scale, startIndex, transform)
  local index = 0
  if (startIndex ~= nil) then
    index = startIndex
  end
  for i, g in pairs(guids) do
    for i, guid in pairs(g) do
      local newPos = {}
      newPos["x"] = pos.pos[1] + ((index % cols) * x * dir)
      newPos["z"] = pos.pos[3] + (DIV(index, cols) * z * (-dir))
      newPos["y"] = pos.pos[2]
      moveTo({guid}, {pos = newPos, rot = pos.rot}, bag, lock, scale, transform)
      index = index + 1
    end
  end
end

function adjust(origPos, adjustment, dir)
  if (adjustment == nil) then
    return origPos
  end
  local newPos = {}
  newPos["x"] = origPos.pos[1] + (adjustment[1] * -dir)
  newPos["z"] = origPos.pos[3] + adjustment[3]
  newPos["y"] = origPos.pos[2] + adjustment[2]
  return {pos = newPos, rot = origPos.rot}
end

playerFaction = {}

function initFaction(color, faction)
  local factionTable = factionInitInfo[faction]
  if factionTable ~= nil then
    local factionBag = getObjectFromGUID(factionTable.factionBag)
    initFactionHelper(color, faction, factionTable, factionBag)
  else
    local bagGuid = state.customFactionBags[faction]
    log("Getting bag GUID for " .. faction .. ": " .. bagGuid)
    initCustomFaction(color, getObjectFromGUID(bagGuid), faction)
  end
end

function initCustomFaction(color, factionBag, faction)
  log("Initializing custom faction " .. faction)
  local factionTable = JSON.decode(customFactions[faction])
  initFactionHelper(color, faction, factionTable, factionBag)
end

bagToAssign = nil
assignedFactionName = nil

function onScriptingButtonDown(button_number, playerColor)
  log("Scripting button " .. tostring(button_number))
  local player = Player[playerColor]
  if (button_number == 1 and player.getHoverObject().getTable("fs-meta") ~= nil) then
    local obj = player.getHoverObject()
    if state.customFactionBags == nil then
      state.customFactionBags = {}
    end
    local name = "CustomFaction" .. tostring(#state.customFactionBags)
    state.customFactionBags[name] = ""
    initCustomFaction(playerColor, obj, name)
  end
  if (button_number == 2 and player.getHoverObject() and player.getHoverObject().getTable("fs-meta") and bagToAssign == nil and assignedFactionName ~= nil) then
    log("Assigning bag " .. player.getHoverObject().getGUID() .. " to faction " .. assignedFactionName)
    bagToAssign = player.getHoverObject()
  elseif (button_number == 2 and bagToAssign ~= nil and player.getHoverObject()) then
    log("Creating button for faction " .. assignedFactionName)
    removeButtons(player.getHoverObject())
    factionButton(player.getHoverObject().getGUID(), assignedFactionName)
    if state.customFactionBags == nil then
      state.customFactionBags = {}
    end
    state.customFactionBags[assignedFactionName] = bagToAssign.getGUID()
    bagToAssign = nil
    assignedFactionName = nil
  end

end

function lockEverything()
  local results = {}
  for k,v in pairs(getAllObjects()) do
    if not v.getLock() then
      table.insert( results, v )
      v.setLock(true)
    end
  end
  return results
end

function unlockThings(locks)
  for k,v in pairs(locks) do
    v.setLock(false)
  end
end

function initFactionHelper(color, faction, factionTable, factionBag)
  local lockedThings = lockEverything()
  local objectDescriptors = factionBag.getObjects()
  local factionCard = getByName(objectDescriptors, "Faction Card")
  local eventDeck = getByName(objectDescriptors, "Event cards")
  local combatDeck = getByNameLike(objectDescriptors, "Combat Cards")
  local objectiveTokens = getByName(objectDescriptors, "Objective tokens")
  local factionTile = getByName(objectDescriptors, "System tile")
  local cities = getByName(objectDescriptors, "Cities")
  local factories = getByName(objectDescriptors, "Factories")
  local bastions = getByName(objectDescriptors, "Bastions")
  local dice = getByNameLike(objectDescriptors, "combat die")
  local level0upgrades = getByName(objectDescriptors, "Combat upgrades (LV 0)")
  local level2upgrades = getByName(objectDescriptors, "Combat upgrades (LV 2)")
  local level3upgrades = getByName(objectDescriptors, "Combat upgrades (LV 3)")
  local orderUpgrades = getByName(objectDescriptors, "Order upgrades")
  local counter = getByName(objectDescriptors, "materiel")
  local colorTable = playerInitInfo[color]

  local materielPos = adjust(colorTable.materialCounterPos, factionTable.cardAdjust, colorTable.dir)
  local objectiveTokenPos = adjust(colorTable.objectiveTokenPos, factionTable.cardAdjust, colorTable.dir)
  local cityPos = adjust(colorTable.cityPilePos, {cardWidth / 2, 0, 0}, -colorTable.dir)
  local bastionPos = adjust(colorTable.bastionPilePos, {cardWidth / 2, 0, 0}, -colorTable.dir)
  local factoryPos = adjust(colorTable.factoryPilePos, {cardWidth / 2, 0, 0}, -colorTable.dir)

  local cardScale = {1.5, 1, 1.5}

  moveTo(factionCard, colorTable.factionCardPos, factionBag, true)
  moveTo(eventDeck, colorTable.eventCardPos, factionBag, false, cardScale)
  moveTo(combatDeck, colorTable.combatDeckPos, factionBag, false, cardScale)
  moveTo(objectiveTokens, objectiveTokenPos, factionBag, true, nil, function(token)
    Wait.frames(function()
      token.setLock(false)
    end, 20)
  end)
  moveTo(factionTile, colorTable.startTilePos, factionBag, false)
  moveTo(cities, cityPos, factionBag, false)
  moveTo(factories, factoryPos, factionBag, false)
  moveTo(bastions, bastionPos, factionBag, false)
  moveTo(counter, materielPos, factionBag, true)
  gridLayout(
    {dice},
    colorTable.combatDieUpperLeft,
    colorTable.dir,
    4,
    dieXWidth + 0.1,
    dieXWidth + 0.1,
    factionBag,
    false
  )
  gridLayout({factionTable.modelPiles}, colorTable.modelPileUpperLeft, colorTable.dir, 10, 3, 3, factionBag, true)
  gridLayout({factionTable.startingUnits}, colorTable.startUnitsUpperLeft, colorTable.dir, 5, 3, 3, factionBag, false)

  local orderTokens = {
    factionTable.orderTokens.advance,
    factionTable.orderTokens.dominate,
    factionTable.orderTokens.strategize,
    factionTable.orderTokens.deploy
  }

  gridLayout(orderTokens, colorTable.orderTokenUpperLeft, colorTable.dir, 2, 2.5, 2.5, factionBag, false, nil, nil, function(obj)
    obj.setName(faction .. " order token")
  end)
  gridLayout(
    {level0upgrades, orderUpgrades},
    colorTable.upgradeCardUpperLeft,
    colorTable.dir,
    6,
    cardWidth,
    cardHeight,
    factionBag,
    true,
    cardScale
  )
  gridLayout(
    {level2upgrades, level3upgrades},
    colorTable.upgradeCardUpperLeft,
    colorTable.dir,
    6,
    cardWidth,
    cardHeight,
    factionBag,
    true,
    cardScale,
    6
  )
  local id = "initPlayerButtons" .. color .. faction
  playerFaction[color] = faction
  Timer.destroy(id)
  Timer.create(
    {
      identifier = id,
      function_name = "playerButtons",
      parameters = {
        colorTable = colorTable,
        orderTokens = concatArrs(orderTokens),
        combatDeck = combatDeck[1],
        dice = dice,
        color = color,
        upgradeCards = concatArrs({level0upgrades, level2upgrades, level3upgrades})
      },
      delay = 3
    }
  )
  state.putBackFaction[color] = {}
  state.putBackFaction[color]["faction"] = faction
  state.putBackFaction[color]["bag"] = factionBag.getGUID()
  state.putBackFaction[color]["guids"] =
    concatArrs(
    {
      factionCard,
      eventDeck,
      combatDeck,
      objectiveTokens,
      factionTile,
      cities,
      factories,
      bastions,
      dice,
      level0upgrades,
      level2upgrades,
      level3upgrades,
      orderUpgrades,
      counter,
      factionTable.modelPiles,
      concatArrs(orderTokens),
      factionTable.startingUnits
    }
  )
  Wait.frames(function()
    unlockThings(lockedThings)
  end, 15)
end

function playerButtons(params)
  tokenResetButton(getObjectFromGUID(params.colorTable.tokenReset), params.orderTokens)
  combatStartButton(getObjectFromGUID(params.colorTable.combatStart), params.combatDeck, params.color)
  combatEndButton(getObjectFromGUID(params.colorTable.combatEnd), params.combatDeck, params.dice)
  for k, v in pairs(params.upgradeCards) do
    upgradeButton(getObjectFromGUID(v))
  end
end

function randomizeColorButton(dominoGUID)
  detailedbutton(getObjectFromGUID(dominoGUID), "Randomize Colors", "randomizeColorPositions", 160)
end
function setupButtons()
  factionButton("7d957a", "Chaos")
  factionButton("a9cb2b", "Eldar")
  factionButton("7a9c5a", "Space Marines")
  factionButton("709e59", "Orks")
  factionButton("6f71a1", "Imperial Guard")
  factionButton("a96dc5", "Tyranids")
  factionButton("9742c2", "Necrons")
  factionButton("0d3a2b", "Tau")
  factionButton("8ab868", "Death Guard")
  factionButton("15eb7e", "Thousand Sons")
  factionButton("554375", "Emp's Children")
  factionButton("7d8992", "World Eaters")

  randomFaction("190101", "Random")

  optionButton("319c92", "Tile Helper")

  randomizeColorButton("f5e837")

  Global.setVar("loaded", true)
end

function setOptionColor(obj, on)
  if (on) then
    obj.highlightOn(playerHighlights["Green"])
  else
    obj.highlightOn(playerHighlights["Red"])
  end
end

function optionButton(domino, optionName)
  log("Creating option button attached to " .. domino .. " for option " .. optionName)
  local currentState = state.options[optionName]
  state.optionButtons[domino] = optionName
  setOptionColor(getObjectFromGUID(domino), currentState)
  detailedbutton(getObjectFromGUID(domino), optionName, "toggleOption", 220)
end

function toggleOption(domino, player)
  local optionName = state.optionButtons[domino.getGUID()]
  state.options[optionName] = not state.options[optionName]
  log("Set option " .. optionName .. " to " .. tostring(state.options[optionName]))
  setOptionColor(domino, state.options[optionName])
end

function factionButton(domino, faction)
  state.factionButtons[domino] = faction
  detailedbutton(getObjectFromGUID(domino), faction, "assignFaction", 220)
end

function randomFaction(domino, name)
  detailedbutton(getObjectFromGUID(domino), name, "chooseRandomFaction", 220)
end

function chooseRandomFaction(domino, playerColor)
  local availableFactionButtons = {}
  for k, v in pairs(state.factionButtons) do
    if (not state.factionAssigned[v]) then
      table.insert(availableFactionButtons, k)
    end
  end

  local choice = math.random(1, #availableFactionButtons)
  local buttonGUID = availableFactionButtons[choice]
  local buttonObject = getObjectFromGUID(buttonGUID)
  assignFaction(buttonObject, playerColor)
end

function assignFaction(domino, playerColor)
  if (playerColor ~= "White" and state.putBackFaction[playerColor] == nil) then
    local faction = state.factionButtons[domino.getGUID()]
    state.factionAssigned[faction] = true
    initFaction(playerColor, faction)
    removeButtons(domino)
    detailedbutton(domino, "Put back " .. faction, "putBackFaction", 180)
  end
end

function putAllInBag(guids, bagGuid)
  local bag = getObjectFromGUID(bagGuid)
  for k, v in pairs(guids) do
    local obj = getObjectFromGUID(v)
    if (obj ~= nil) then
      bag.putObject(obj)
    end
  end
end

function putBackFaction(domino, playerColor)
  local faction = state.factionButtons[domino.getGUID()]
  if (state.putBackFaction[playerColor]["faction"] == faction) then
    state.factionAssigned[faction] = false
    putAllInBag(state.putBackFaction[playerColor]["guids"], state.putBackFaction[playerColor]["bag"])
    removeButtons(domino)
    removeButtons(getObjectFromGUID(playerInitInfo[playerColor].combatStart))
    removeButtons(getObjectFromGUID(playerInitInfo[playerColor].combatEnd))
    removeButtons(getObjectFromGUID(playerInitInfo[playerColor].tokenReset))

    factionButton(domino.getGUID(), faction)
    state.putBackFaction[playerColor] = nil
  end
end

function upgradeButton(deck)
  cardbutton(deck, "UP", "upgradeCards")
end

function playerCardRotation(playerColor)
  local yRot = 180
  if playerInitInfo[playerColor].dir < 0 then
    yRot = 0
  end
  return {x = 0, y = yRot, z = 0}
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

function refindCombatDeck(params)
  for k, v in pairs(getAllObjects()) do
    if (v.tag == "Deck") then
      for k2, cardTab in pairs(v.getObjects()) do
        if (cardTab.guid == params.combat) then
          state.combatDecks[params.player] = v.getGUID()
          v.setName("Combat Cards")
        end
        if (cardTab.guid == params.discard) then
          cardbutton(v, "UP", "upgradeCards")
          v.setName("Discarded Combat upgrades")
        end
      end
    end
  end
end

function isObjectInZone(zoneGUID, objectGUID)
  local zone = getObjectFromGUID(zoneGUID)
  if (zone) then
    for k, v in pairs(zone.getObjects()) do
      if (v.getGUID() == objectGUID) then
        return true
      end
    end
  end
  return false
end

function isObjectInZones(zoneGUIDs, objectGUID)
  for k, v in pairs(zoneGUIDs) do
    if (isObjectInZone(k, objectGUID)) then
      return true
    end
  end
  return false
end

function onObjectRandomize(object, playerColor)
  if (string.find(object.getName(), "combat die") and diceRotations[playerColor]) then
    rollCombatDie(object, playerColor)
  end
end

function onObjectDropped(playerColor, obj)
  local p = obj.getPosition()
  if (obj.getName() == "Combat token" and not obj.getVar("owned")) then
    state.combatTokensToPlayer[obj.getGUID()] = playerColor
    obj.setVar("owned", true)
    obj.setVar("owner", playerColor)
    obj.highlightOn(playerHighlights[playerColor])
  end
  if (obj.getName() == "Bastion" and not obj.getVar("owned")) then
    obj.setVar("owned", true)
    obj.setVar("owner", playerColor)
  end
  if (obj.getName() == "Reinforcement token" and not obj.getVar("owned")) then
    state.reinforceTokensToPlayer[obj.getGUID()] = playerColor
    obj.setVar("owned", true)
    obj.setVar("owner", playerColor)
    obj.highlightOn(playerHighlights[playerColor])
  end
  if (obj.getName() == "System tile" and state.options["Tile Helper"]) then
    systemTileDropped(obj)
  end
end

function onObjectPickUp(playerColor, obj)
  if (obj.getName() == "System tile") then
    removeTileFromGrid(obj)
  end
  if (string.find(obj.getName(), "combat die")) then
    obj.setVar("intended_side", "None")
  end
end

function onObjectEnterScriptingZone(zone, object)
  if (diceTrayZones[zone.getGUID()]) then
    local id = "organizeAllDice" .. zone.getGUID()
    local props = diceTrayZones[zone.getGUID()]
    intended_side = object.getVar("intended_side")
    if intended_side == "None" or intended_side == props.side then
      Timer.destroy(id)
      Timer.create(
        {
          identifier = id,
          function_name = "organizeDice",
          parameters = {zone = zone, side = props.side, playerColor = props.player, dir = props.dir, trigger = object},
          delay = 0.3
        }
      )
    end
  end
end

function organizeAllDice(params)
  local playerColor = params.playerColor
  local zones = {}
  for k, v in pairs(diceTrayZones) do
    if v.player == playerColor then
      params.zone = getObjectFromGUID(k)
      organizeDice(params)
    end
  end
end

function organizeDice(params)
  local zone = params.zone
  local side = params.side
  local playerColor = params.playerColor
  local triggerObjectGUID = params.trigger.getGUID()
  local count = 0
  local held = false
  if isObjectInZone(zone.getGUID(), triggerObjectGUID) then
    for k, v in pairs(zone.getObjects()) do
      if (v.getName() and v.held_by_color == nil and string.find(v.getName(), "die")) then
        v.setLock(true)
        v.setRotationSmooth(diceRotations[playerColor][side])
        local pos = copyTable(dicePositions[playerColor][side])
        pos.x = pos.x + ((dieXWidth * count) * params.dir)
        v.setPositionSmooth(pos)
        count = count + 1
        v.setLock(false)
      elseif (v.held_by_color) then
        held = true
      end
    end
    if (held) then
      local id = "organizeDice" .. zone.getGUID()
      Timer.destroy(id)
      Timer.create(
        {
          identifier = id,
          function_name = "organizeDice",
          parameters = params,
          delay = 0.3
        }
      )
    end
  end
end

function rollCombatDie(die, playerColor)
  local s = math.random(1, 6)
  local side = diceSideMap[s]

  local timesRolled = Global.getVar(side .. "TimesRolled")
  if not timesRolled then
    timesRolled = 0
  end
  timesRolled = timesRolled + 1
  Global.setVar(side .. "TimesRolled", timesRolled)
  playerDieReport[playerColor][die.getGUID()] = side

  local rot = diceRotations[playerColor][side]
  local posInt = copyTable(dicePositions[playerColor][side])
  posInt.x = posInt.x + ((dieXWidth * 10) * dicePositions[playerColor].dir)
  local posFinal = copyTable(dicePositions[playerColor][side])
  posFinal.x = posFinal.x + ((dieXWidth * 7) * dicePositions[playerColor].dir)
  die.roll()
  die.setVar("intended_side", side)
  local idInt = "setDieInt" .. die.getGUID()
  local idFin = "setDieFin" .. die.getGUID()
  Timer.destroy(idInt)
  Timer.create(
    {
      identifier = idInt,
      function_name = "moveObj",
      parameters = {obj = die, pos = posInt, rot = rot},
      delay = 0.6
    }
  )
  Timer.destroy(idFin)
  Timer.create(
    {
      identifier = idFin,
      function_name = "moveObj",
      parameters = {obj = die, pos = posFinal, rot = rot},
      delay = 1.2
    }
  )
  Timer.destroy(playerColor .. "DieReport")
  Timer.create(
    {
      identifier = playerColor .. "DieReport",
      function_name = "dieReport",
      parameters = {playerColor = playerColor},
      delay = 2
    }
  )
end

playerDieReport = {
  Red = {},
  Green = {},
  Blue = {},
  Yellow = {}
}

function reportAppend(reportString, num, sing, plural)
  if num > 0 then
    if reportString ~= "" then
      reportString = reportString .. ", "
    end
    if num == 1 then
      name = sing
    else
      name = plural
    end
    reportString = reportString .. "" .. num .. " " .. name
  end
  return reportString
end

function countDice(report, side)
  local count = 0
  for k, v in pairs(report) do
    if v == side then
      count = count + 1
    end
  end
  return count
end

function dieReport(params)
  report = playerDieReport[params.playerColor]
  faction = playerFaction[params.playerColor]
  reportString = ""
  guns = countDice(report, "gun")
  shields = countDice(report, "shield")
  morale = countDice(report, "morale")
  reportString = reportAppend(reportString, guns, "gun", "guns")
  reportString = reportAppend(reportString, shields, "shield", "shields")
  reportString = reportAppend(reportString, morale, "morale", "morale")

  printToAll(faction .. " rolled " .. reportString)
  playerDieReport[params.playerColor] = {}
end

function retrieveAll()
  for k, o in pairs(getAllObjects()) do
    if (o.tag == "Bag") then
      retrieveItems(o)
    end
  end
end

function tryObjectEnterContainer(bag, object)
  if (bag.tag == "Bag") then
    local bagName = bag.getName()
    local countWithName = 0
    local total = 0
    for k, v in pairs(bag.getObjects()) do
      total = total + 1
      if (bagNameLike(bagName, v.name)) then
        countWithName = countWithName + 1
      end
    end
    if (countWithName > (total / 2)) then
      if not bagNameLike(bagName, object.getName()) then
        log("Denied object " .. object.getName() .. " entering bag " .. bagName)
        return false
      end
    end
  end
  return true
end

function moveObj(params)
  local obj = params.obj
  if (params.guid) then
    obj = getObjectFromGUID(params.guid)
  end

  if (params.rot) then
    obj.setRotationSmooth(params.rot)
  end
  if (params.pos) then
    obj.setPositionSmooth(params.pos)
  end
  if (params.lock) then
    obj.setLock(params.lock)
  end
end

function sameRot(rot1, rot2, tolerance)
  local xdif = math.abs(rot1.x - rot2.x)
  local ydif = math.abs(rot1.y - rot2.y)
  local zdif = math.abs(rot1.z - rot2.z)
  return xdif < tolerance and ydif < tolerance and zdif < tolerance
end

function numObjectsInZoneWithRot(zone, rot)
  local count = 0
  for k, v in pairs(zone.getObjects()) do
    if (sameRot(rot, v.getRotation(), 0.1)) then
      count = count + 1
    end
  end
  return count
end

function sign(x)
  return x > 0 and 1 or -1
end

function bagNameLike(bagName, n)
  return string.find(bagName, n) or string.find(bagName, n .. "s") or string.find(bagName, string.gsub(n, "y$", "ies"))
end

function retrieveItems(bag)
  local bagName = bag.getName()
  local countWithName = 0
  local total = 0
  for k, v in pairs(bag.getObjects()) do
    total = total + 1
    if (bagNameLike(bagName, v.name)) then
      countWithName = countWithName + 1
    end
  end
  if (countWithName > (total / 2)) then
    local retrieveOffset = 10
    local retrieveHeight = 2
    for k, v in pairs(bag.getObjects()) do
      local n = v.name
      if
        (not (string.find(bagName, n) or string.find(bagName, n .. "s") or
          string.find(bagName, string.gsub(n, "y$", "ies"))))
       then
        print("Retrieving")
        local pos = bag.getPosition()
        pos["x"] = pos["x"] + (retrieveOffset * (-1 * sign(pos["x"])))
        pos["z"] = pos["z"] + (retrieveOffset * (-1 * sign(pos["z"])))
        pos["y"] = pos["y"] + retrieveHeight
        bag.takeObject({guid = v.guid, position = pos})
        retrieveHeight = retrieveHeight + 2
      end
    end
  end
end

function commandTokenCollision(info)
  local t = info.collision_object
  if
    (t and t.getName() and isObjectInZone(MAIN_BOARD_ZONE, info.object.getGUID()) and
      string.find(t.getName(), "order token"))
   then
    local targetPos = info.collision_object.getPosition()
    local oPos = info.object.getPosition()
    local tPos = t.getPosition()
    if (oPos["y"] > tPos["y"] and (math.abs(oPos["x"] - tPos["x"]) > 0.01 or math.abs(oPos["z"] - tPos["z"]) > 0.01)) then
      local newPos = {}
      newPos["y"] = tPos["y"] + 0.3
      newPos["x"] = tPos["x"]
      newPos["z"] = tPos["z"]
      info.object.setRotation(commandTokenRotation)
      info.object.setPosition(newPos)
    end
  end
end

function findAll(name)
  local result = {}
  for k, v in pairs(getAllObjects()) do
    if (v.getName() == name) then
      table.insert(result, v.guid)
    end
  end
  return result
end

function findAllWithTag(name)
  local result = {}
  for k, v in pairs(getAllObjects()) do
    if (v.tag == name) then
      table.insert(result, v.guid)
    end
  end
  return result
end

function findAllLike(name)
  local result = {}
  for k, v in pairs(getAllObjects()) do
    if (string.find(v.getName(), name)) then
      table.insert(result, v.guid)
    end
  end
  return result
end

function find(name)
  for k, v in pairs(getAllObjects()) do
    if (v.getName() == name) then
      return v
    end
  end
  return result
end

function storePositions(objectGuids)
  local storage = {}
  local positions = {}
  local guids = {}
  local rotations = {}
  storage["guids"] = guids
  storage["positions"] = positions
  storage["rotations"] = rotations
  local count = 0
  for k, v in pairs(objectGuids) do
    local o = getObjectFromGUID(v)
    table.insert(guids, v)
    table.insert(positions, vector_convertor(o.getPosition()))
    table.insert(rotations, vector_convertor(o.getRotation()))
    count = count + 1
  end
  storage["size"] = count
  return storage
end

function resetPositions(storage, random)
  random = random or false
  local positions = storage["positions"]
  local guids = storage["guids"]
  local rotations = storage["rotations"]
  local offset = 0
  local l = storage["size"]
  if (random) then
    offset = math.random(6)
  end
  for k, v in pairs(guids) do
    local o = getObjectFromGUID(v)
    local index = ((k - 1 + l + offset) % l) + 1
    if (o ~= nil) then
      o.setRotationSmooth(rotations[k])
      o.setPositionSmooth(positions[index])
      o.setLock(false)
    else
      retrieveFromContainer(v, rotations[k], positions[index])
    end
  end
end

function retrieveFromContainer(guid, putRot, putPos)
  local objs = getAllObjects()
  for k, container in pairs(objs) do
    if (container.tag == "Bag" or container.tag == "Deck") then
      for k2, target in pairs(container.getObjects()) do
        if (target.guid == guid) then
          local takeObjParams = {}
          takeObjParams.guid = guid
          takeObjParams.position = putPos
          takeObjParams.rotation = putRot
          container.takeObject(takeObjParams)
        end
      end
    end
  end
end

function tokenResetButton(domino, tokens)
  button(domino, "Reset Command\n Tokens", "resetCommandTokens")
  state.commandTokenObjects[domino.getGUID()] = storePositions(tokens)
end

function resetCommandTokens(domino, color)
  resetPositions(state.commandTokenObjects[domino.getGUID()], true)
end

function combatStartButton(domino, deckGuid, playerColor)
  button(domino, "Start Combat", "startCombat")
  state.playerCombatStartButtons[domino.getGUID()] = playerColor
  state.playerCombatDomino[playerColor] = domino.getGUID()
  local deck = getObjectFromGUID(deckGuid)
  state.combatDecks[playerColor] = deck.getGUID()
end

function startCombat(domino, playerColor)
  if (not state.combatLock[playerColor]) then
    state.combatLock[playerColor] = true
    local deck = getObjectFromGUID(state.combatDecks[playerColor])
    if (closeTo(deck.getRotation().z, 0, 1)) then
      deck.flip()
    end
    state.combatDeckContents[deck.getGUID()] = {table.unpack(deck.getObjects())}
    deck.shuffle()
    deck.dealToColor(5, playerColor)
    timer(playerColor, "initHand", {playerColor = playerColor}, 1)
  end
end

function unlockCombat(params)
  state.combatLock[params.playerColor] = false
end

function timer(key, fn_name, params, delay)
  local id = fn_name .. key
  Timer.destroy(id)
  Timer.create(
    {
      identifier = id,
      function_name = fn_name,
      parameters = params,
      delay = delay
    }
  )
end

function initHand(params)
  for k, card in pairs(Player[params.playerColor].getHandObjects()) do
    cardbutton(card, "PLAY", "playCard")
  end
end

function smoothMove(obj, pos)
  obj.setPositionSmooth(pos)
end

function playCard(card, playerColor)
  card.clearButtons()
  card.flip()
  card.setLock(true)
  local firstCardPos = copyTable(dicePositions[playerColor]["combatCard"])
  local jumpPos = copyTable(card.getPosition())
  jumpPos.y = jumpPos.y + 10

  backcardbutton(card, "RET", "returnCard")
  firstCardPos.x = firstCardPos.x + (4 * dicePositions[playerColor].dir * #state.playedCombatCards[playerColor])
  card.setPosition(jumpPos)
  smoothMove(card, firstCardPos)
  for k, playedCardGuid in pairs(state.playedCombatCards[playerColor]) do
    getObjectFromGUID(playedCardGuid).clearButtons()
  end
  table.insert(state.playedCombatCards[playerColor], card.getGUID())
  card.setLock(false)
end

function returnCard(card, playerColor)
  card.clearButtons()
  local handdata = Player[playerColor].getHandObjects()[1]
  local handPos = copyTable(handdata.getPosition())
  card.setPositionSmooth(handPos)
  table.remove(state.playedCombatCards[playerColor])
  timer(card.getGUID(), "flipAndInitCard", {card = card}, 0.5)
end

function flipAndInitCard(params)
  params.card.flip()
  cardbutton(params.card, "PLAY", "playCard")
end

function combatEndButton(domino, deck, dice)
  button(domino, "End Combat", "endCombat")
  state.combatDice[domino.getGUID()] = storePositions(dice)
end

function closeTo(num1, num2, tolerance)
  return math.abs(num1 - num2) < tolerance
end

function findCombatDeckForColor(playerColor)
  local expectedPos = playerInitInfo[playerColor].combatDeckPos
  local closestDeck = nil
  local closestDistance = nil
  for k, obj in pairs(getAllObjects()) do
    if (obj.tag == "Deck") then
      if (closestDistance == nil or distance2D(obj.getPosititon(), expectedPos) < closestDistance) then
        closestDeck = obj
        closestDistance = distance2D(obj.getPosititon(), expectedPos)
      end
    end
  end
  if (closestDeck ~= nil) then
    state.combatDecks[playerColor] = closestDeck.getGUID()
    closestDeck.setName("Combat Cards")
  end
  return closestDeck
end

function endCombat(domino, playerColor)
  state.combatLock[playerColor] = true
  local deck = getObjectFromGUID(state.combatDecks[playerColor])
  if (deck == nil) then
    deck = findCombatDeckForColor(playerColor)
  end
  state.playedCombatCards[playerColor] = {}
  if (deck ~= nil) then
    local cards = state.combatDeckContents[deck.getGUID()]
    if (cards) then
      for k, v in pairs(cards) do
        local card = getObjectFromGUID(v["guid"])
        if card ~= nil then
          card.clearButtons()
          card.putObject(deck)
        end
      end
    end
    if (closeTo(deck.getRotation().z, 180, 1)) then
      deck.flip()
    end
  end
  state.combatDeckContents[deck.getGUID()] = {}
  for k, v in pairs(state.combatTokensToPlayer) do
    if (v == playerColor) then
      local obj = getObjectFromGUID(k)
      if (obj ~= nil) then
        obj.destruct()
      end
    end
  end
  resetPositions(state.combatDice[domino.getGUID()])
  timer(playerColor, "unlockCombat", {playerColor = playerColor}, 2)
end

function setOnCollisionEnter(guids, fnName)
  for k, v in pairs(guids) do
    local o = getObjectFromGUID(v)
    if (o) then
      o:setLuaScript(
        [[
      function onCollisionEnter(collision_info)
          if(self and collision_info and Global and Global.getVar("loaded") ) then
            collision_info['object'] = self
            Global.call(']] ..
          fnName .. [[', collision_info)
          end
      end
      ]]
      )
    end
  end
end

function clearLua(guids)
  for k, v in pairs(guids) do
    local o = getObjectFromGUID(v)
    if (o) then
      o:setLuaScript("")
    end
  end
end

function distance3D(point1, point2)
  local x = point1.x - point2.x
  local y = point1.y - point2.y
  local z = point1.z - point2.z
  return math.sqrt(x * x + y * y + z * z)
end

function distance2D(point1, point2)
  local x = point1.x - point2.x
  local z = point1.z - point2.z
  return math.sqrt(x * x + z * z)
end

function numPlayers()
  return #getSeatedPlayers()
end

-- state.tiles()
-- state.laidTiles()

default_state.tiles = {
  tileData = {},
  startingAttachment = {x = 0, y = 1, z = 0}
}

function futureCenter()
  local timerId = "center"
  Timer.destroy(timerId)
  Timer.create(
    {
      identifier = timerId,
      function_name = "center",
      delay = 0.75
    }
  )
end

function doAttach(tile, point)
  if (distance2D(tile.getPosition(), point) < (tileRadius / 1.5)) then
    attachTileToPoint(tile, point)
    futureCenter()
    return true
  else
    return false
  end
end

function removeTileFromGrid(tile)
  local val = state.tiles.tileData[tile.getGUID()]
  if (val) then
    state.tiles.tileData[tile.getGUID()] = nil
  --futureCenter()
  end
end

function systemTileDropped(tile)
  local shouldCheckStart = true
  for tileGuid, tileData in pairs(state.tiles.tileData) do
    shouldCheckStart = false
    local pointArray = tileData.attachmentPoints
    for index, point in pairs(pointArray) do
      if (doAttach(tile, point)) then
        return
      end
    end
  end
  if (shouldCheckStart and doAttach(tile, state.tiles.startingAttachment)) then
    return
  end
end

function move(point, dim, amount)
  local newPoint = {x = point.x, y = point.y, z = point.z}
  newPoint[dim] = newPoint[dim] + amount
  return newPoint
end

function vecDiff(from, to)
  return {x = to.x - from.x, y = to.y - from.y, z = to.z - from.z}
end

function vecAdd(p, vec)
  return {x = vec.x + p.x, y = vec.y + p.y, z = vec.z + p.z}
end

function rotAdd(p, vec)
  return {x = (vec.x + p.x) % 360, y = (vec.y + p.y) % 360, z = (vec.z + p.z) % 360}
end

function rotateVec(vec, degrees)
  return {
    x = vec.x * math.cos(math.rad(degrees)) - vec.z * math.sin(math.rad(degrees)),
    y = vec.y,
    z = vec.x * math.sin(math.rad(degrees)) + vec.z * math.cos(math.rad(degrees))
  }
end

function adjustUnits(tilePos, dest, maybeRot, smooth)
  local units = getUnits(tilePos)
  adjustUnitsHelper(units, tilePos, dest, maybeRot, smooth)
  return units
end

function getUnits(tilePos)
  local units = {}
  for k, unit in pairs(getAllObjects()) do
    if
      (unit.getName() ~= "System tile" and unit.getName() ~= nil and unit.getName() ~= "" and
        (unit.name == "Card" or unit.name == "Custom_Model") and
        distance2D(unit.getPosition(), tilePos) < tileRadius)
     then
      table.insert(units, 1, unit)
    end
  end
  return units
end

function adjustUnitsHelper(units, tilePos, dest, maybeRot, smooth)
  for i, unit in pairs(units) do
    unit.setLock(true)
    local vec = vecDiff(tilePos, unit.getPosition())
    if (maybeRot) then
      vec = rotateVec(vec, maybeRot.y)
    end
    local newPos = vecAdd(dest, vec)
    newPos.y = newPos.y + 0.2 --bump up a bit to avoid collisions
    if (smooth) then
      unit.setPositionSmooth(newPos)
    else
      unit.setPosition(newPos)
    end
    if (maybeRot) then
      unit.setRotation(rotAdd(unit.getRotation(), maybeRot))
    end
  end
end

function copyPos(p)
  return {x = p.x, y = p.y, z = p.z}
end

function generateAttachPoints(p, d)
  local points = {}
  table.insert(points, move(p, "x", d))
  table.insert(points, move(p, "x", -d))
  table.insert(points, move(p, "z", d))
  table.insert(points, move(p, "z", -d))
  return points
end

function unlockHelper(params)
  params.obj.setLock(params.lock)
end

function setLockAsync(obj, lock, delay)
  local id = "unlock" .. obj.getGUID()
  Timer.destroy(id)
  Timer.create(
    {
      identifier = id,
      function_name = "unlockHelper",
      parameters = {obj = obj, lock = lock},
      delay = delay
    }
  )
end

function unlockAll(objs)
  for i, obj in pairs(objs) do
    if (obj) then
      setLockAsync(obj, false, 1)
    end
  end
end

function attachTileToPoint(obj, p)
  obj.setLock(true)
  local origPos = copyPos(obj.getPosition())
  local currentRot = obj.getRotation()
  local newRot = math.floor((currentRot.y / 90) + 0.5) * 90
  local toRotate = currentRot.y - newRot
  local units = adjustUnits(origPos, p, {x = 0, y = toRotate, z = 0}, true)
  obj.setPositionSmooth(p)
  obj.setRotationSmooth({x = currentRot.x, y = newRot, z = currentRot.z})
  unlockAll(units)
  --obj.setLock(true)
  local d = 2 * tileRadius
  local points = generateAttachPoints(p, d)
  obj.use_grid = false
  state.tiles.tileData[obj.getGUID()] = {attachmentPoints = points, center = p}
  setLockAsync(obj, false, 1)
end

function fold(coll, init, foldFn)
  local val = init
  for k, v in pairs(coll) do
    val = foldFn(val, v)
  end
  return val
end

mathBy = function(mathfn, attr)
  return function(m, tileData)
    return mathfn(m, tileData.center[attr])
  end
end

maxOf = function(tiles, attr)
  return fold(tiles.tileData, -100000, mathBy(math.max, attr))
end

minOf = function(tiles, attr)
  return fold(tiles.tileData, 100000, mathBy(math.min, attr))
end

function translateCenter()
  local tiles = state.tiles
  local getMiddle = function(attr, tiles)
    local valMax = maxOf(tiles, attr)
    local valMin = minOf(tiles, attr)
    return (valMax + valMin) / 2
  end

  local centerx = getMiddle("x", tiles)
  local centerz = getMiddle("z", tiles)

  local currentCenter = {x = centerx, y = 1, z = centerz}
  log("Current center: " .. tabToS(currentCenter))
  local transformVector = vecDiff(currentCenter, state.tiles.startingAttachment)
  log("Transform center by: " .. tabToS(transformVector))
  for guid, tileData in pairs(tiles.tileData) do
    local tile = getObjectFromGUID(guid)
    tile.setLock(true)
    local origPos = copyPos(tile.getPosition())
    local newCenter = vecAdd(tile.getPosition(), transformVector)
    local units = adjustUnits(origPos, newCenter, {x = 0, y = 0, z = 0}, true)
    tile.setPositionSmooth(newCenter)
    unlockAll(units)
    local newAttachments = {}
    for k, aPoint in pairs(tileData.attachmentPoints) do
      table.insert(newAttachments, vecAdd(aPoint, transformVector))
    end
    tileData.attachmentPoints = newAttachments
    tileData.center = newCenter
    setLockAsync(tile, false, 1)
  end
end

function rotateCenter()
  local tiles = state.tiles
  local maxz = maxOf(tiles, "z")
  local maxx = maxOf(tiles, "x")

  if (maxz > 17.2 and maxx < 17.2) then
    log("Rotating")

    local tiles = state.tiles
    local getMiddle = function(attr, tiles)
      local valMax = maxOf(tiles, attr)
      local valMin = minOf(tiles, attr)
      return (valMax + valMin) / 2
    end

    local centerx = getMiddle("x", tiles)
    local centerz = getMiddle("z", tiles)
    local currentCenter = {x = centerx, y = 1, z = centerz}

    local savedUnits = {}

    for guid, tileData in pairs(tiles.tileData) do
      local units = getUnits(getObjectFromGUID(guid).getPosition())
      savedUnits[guid] = units
    end

    for guid, tileData in pairs(tiles.tileData) do
      local tile = getObjectFromGUID(guid)
      tile.setLock(true)
      local pos = copyPos(tile.getPosition())
      local vectorFromCenter = vecDiff(currentCenter, pos)
      local rotated = rotateVec(vectorFromCenter, 90)
      local newCenter = vecAdd(rotated, currentCenter)
      local units = savedUnits[guid]
      adjustUnitsHelper(units, pos, newCenter, {x = 0, y = 90, z = 0}, false)
      tile.setPosition(newCenter)
      tile.setRotation(rotAdd(tile.getRotation(), {x = 0, y = -90, z = 0}))
      unlockAll(units)
      local d = 2 * tileRadius
      local newAttachments = generateAttachPoints(newCenter, d)
      tileData.attachmentPoints = newAttachments
      tileData.center = newCenter
      setLockAsync(tile, false, 1)
    end
    return true
  end
  return false
end

function center()
  translateCenter()
  if (rotateCenter()) then
  --futureCenter()
  end
end