local STORE = require("_variables")
local UTILS = require("_utils")
local waitMap = require("_waitMap")

local ORDER_TOKENS = {
	orderTokens = {
		["sm"] = {
			deploy = { "f70c5d", "cd262d" },
			strategize = { "d2e8ea", "d36c19" },
			dominate = { "e3142f", "88b2c7" },
			advance = { "e51f7b", "080a73" },
		},
		["oz"] = {
			deploy = { "6faf2d", "b23647" },
			strategize = { "3bf6c2", "8c2b92" },
			dominate = { "d48b28", "05f879" },
			advance = { "f20013", "ff822a" },
		},
		["ch"] = {
			deploy = { "7fc185", "2d02ab" },
			strategize = { "b5b9ec", "787faf" },
			dominate = { "5244ce", "2607fc" },
			advance = { "911f30", "656f0c" },
		},
		["ed"] = {
			deploy = { "8ec1f0", "99d309" },
			strategize = { "9d41d1", "b05da8" },
			dominate = { "ea7418", "91d7c0" },
			advance = { "525259", "a68c5d" },
		},
	},

	orderZones = {
		["ch"] = "a82193",
		["ed"] = "d48a52",
		["sm"] = "5c5abb",
		["oz"] = "3f1125",
	},

	orderTokenStartingCoordinates = {},
}

function ORDER_TOKENS.setOrderTokenTeleportButtons()
	for faction, tokenTypes in pairs(ORDER_TOKENS.orderTokens) do
		for type, tokens in pairs(tokenTypes) do
			for _, guid in ipairs(tokens) do
				local obj = getObjectFromGUID(guid)
				ORDER_TOKENS.orderTokenStartingCoordinates[guid] = {
					position = obj.getPosition(),
					rotation = obj.getRotation(),
				}
				obj.UI.setXmlTable({ ORDER_TOKENS.createOrderTokenUI(guid, obj, faction, type == "strategize") })
			end
		end
	end
end

function ORDER_TOKENS.createOrderTokenUI(tokenId, obj, faction, isStrategize)
	local scale = 1 / obj.getScale().x
	local offset = 10
	return {
		tag = "Button",
		attributes = {
			interactable = true,
			active = false,
			height = 60,
			width = 250,
			scale = scale .. " " .. scale .. " " .. scale,
			position = "0 " .. ((150 + offset) * scale) .. " 0",
			rotation = obj.getRotation().z .. " 0 0",
			text = isStrategize and "Add to event deck" or "Return to start",
			fontSize = 28,
			onClick = isStrategize and "Global/placeStrategizeOrderTokenOnEventDeck"
				or "Global/placeOrderTokenBackToStart",
			onMouseEnter = "show",
			onMouseExit = "hide",
			id = tokenId .. ":" .. faction,
		},
	}
end

function ORDER_TOKENS.placeStrategizeOrderTokenOnEventDeck(player, value, id)
	local orderToken
	for tokenId, faction in string.gmatch(id, "(%w+):(%w+)") do
		orderToken = getObjectFromGUID(tokenId)
		orderToken.UI.setAttributes(id, {
			onClick = "Global/placeStrategizeOrderTokenBackToStart",
			text = "Return to start",
		})
		local factionData = STORE.factionsData[faction]
		if not factionData then
			return
		end
		local eventDeckGUID = factionData.eventDeckGUID
		local eventDeck = getObjectFromGUID(eventDeckGUID).getPosition()
		eventDeck.y = eventDeck.y + 2
		orderToken.setPositionSmooth(eventDeck, false, true)
		local startRot = ORDER_TOKENS.orderTokenStartingCoordinates[tokenId].rotation
		orderToken.setRotationSmooth(startRot, false, true)
	end
end
Global.setVar("placeStrategizeOrderTokenOnEventDeck", ORDER_TOKENS.placeStrategizeOrderTokenOnEventDeck)

function ORDER_TOKENS.placeStrategizeOrderTokenBackToStart(player, value, id)
	for tokenId, faction in string.gmatch(id, "(%w+):(%w+)") do
		local startPos = ORDER_TOKENS.orderTokenStartingCoordinates[tokenId].position
		local startRot = ORDER_TOKENS.orderTokenStartingCoordinates[tokenId].rotation
		local strategizeToken = getObjectFromGUID(tokenId)
		strategizeToken.setPositionSmooth(startPos, false, true)
		strategizeToken.setRotationSmooth(startRot, false, true)
		strategizeToken.UI.setAttributes(id, {
			onClick = "Global/placeOrderTokenOnEventDeck",
			text = "Add to event deck",
		})
	end
end
Global.setVar("placeStrategizeOrderTokenBackToStart", ORDER_TOKENS.placeStrategizeOrderTokenBackToStart)

function ORDER_TOKENS.placeOrderTokenBackToStart(player, value, id)
	for tokenId, faction in string.gmatch(id, "(%w+):(%w+)") do
		local startPos = ORDER_TOKENS.orderTokenStartingCoordinates[tokenId].position
		local startRot = ORDER_TOKENS.orderTokenStartingCoordinates[tokenId].rotation
		getObjectFromGUID(tokenId).setPositionSmooth(startPos, false, true)
		getObjectFromGUID(tokenId).setRotationSmooth(startRot, false, true)
	end
end
Global.setVar("placeOrderTokenBackToStart", ORDER_TOKENS.placeOrderTokenBackToStart)

function ORDER_TOKENS.getFactionOfOrderToken(id)
	for faction, tokens in pairs(ORDER_TOKENS.orderTokens) do
		for type, ids in pairs(tokens) do
			for _, tokenId in ipairs(ids) do
				if tokenId == id then
					return faction
				end
			end
		end
	end
end

ORDER_TOKENS.handlePlayerFlip = function(player, action, targets)
	if action == Player.Action.FlipOver then
		for _, target in ipairs(targets) do
			local id = target.getGUID()
			local faction = ORDER_TOKENS.getFactionOfOrderToken(id)
			if not faction then
				return
			end
			-- prevent illegal flips
			if STORE.factionsData[faction].color ~= player.color then
				return false
			end
			-- visibility of order token teleport buttons
			-- if target.is_face_down then
			-- 	target.UI.hide(id .. ":" .. faction)
			-- else
			-- 	target.UI.show(id .. ":" .. faction)
			-- end
		end
	end
end

-- prevent illegal peeks
function ORDER_TOKENS.testAndHideOrderTokenOnPeek(object, player_color)
	local objectName = object.getName()
	local msg = player_color .. " peeked: " .. objectName
	local waitId = player_color .. object.guid
	if waitMap[waitId] then
		Wait.stop(waitMap[waitId])
	end
	if string.find(objectName, "order token") and not object.is_face_down then
		local msgColor = { 1, 0, 0 }
		local shouldHide = false
		for faction, data in pairs(STORE.factionsData) do
			local color = data["color"]
			if color == player_color then
				msgColor = STORE.factionColors[faction]
			end
			if string.find(objectName, data["name"]) and color ~= player_color then
				shouldHide = true
			end
		end
		if shouldHide then
			object.setHiddenFrom({ player_color })
			broadcastToAll(msg, msgColor)
			ORDER_TOKENS.addWaitToUnhideObject(object, player_color)
		end
	end
end

function ORDER_TOKENS.addWaitToUnhideObject(object, player_color)
	local waitId = player_color .. object.guid
	waitMap[waitId] = Wait.frames(function()
		for _, player in ipairs(Player.getPlayers()) do
			if player.color == player_color then
				local hoverGuid = player.getHoverObject() and player.getHoverObject().guid
				if hoverGuid == object.guid then
					print(player_color .. " still hovering")
					ORDER_TOKENS.addWaitToUnhideObject(object, player_color)
					return
				end
			end
		end
		object.setHiddenFrom({})
		waitMap[waitId] = nil
	end, 300)
end

-- teleport token button visibility code
function ORDER_TOKENS.onHover(player_color, object)
	if not object then
		return
	end
	for faction, tokens in pairs(ORDER_TOKENS.orderTokens) do
		for type, guids in pairs(tokens) do
			for _, guid in ipairs(guids) do
				if guid == object.guid then
					local buttonId = guid .. ":" .. faction
					local orderZone = ORDER_TOKENS.orderZones[faction]
					-- is_face_down is reversed in game for order tokens, will have to fix assets
					if not object.is_face_down then
						return
					end
					-- the intent here is to not show the buttons when in the order zone
					local zones = object.getZones()
					if zones then
						for _, zone in ipairs(zones) do
							if zone.guid == orderZone then
								return
							end
						end
					end
					object.UI.show(buttonId)
					ORDER_TOKENS.addWaitToUnhideObject(object, player_color)
				end
			end
		end
	end
end

function ORDER_TOKENS.init()
	ORDER_TOKENS.setOrderTokenTeleportButtons()
	for faction, data in pairs(STORE.factionsData) do
		data.orderTokens = ORDER_TOKENS.orderTokens[faction]
	end
end

return ORDER_TOKENS
