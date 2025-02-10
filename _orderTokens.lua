local STORE = require("_variables")
local ORDER_TOKENS = {}

function ORDER_TOKENS.init()
	for faction, tokens in pairs(STORE.orderTokens) do
		for tokenType, guids in pairs(tokens) do
			for _, guid in ipairs(guids) do
				-- Global.call("call_module", {"ORDER_TOKENS._onHover", {player_color, "%s", "%s"}})
				getObjectFromGUID(guid).setLuaScript(string.format(
					[[
                    local waitMap = {}
                    local faction = "%s"
                    local tokenGUID = "%s"
                    local buttonId = tokenGUID..":"..faction
                    function onHover(player_color)
                        local orderZone = "%s"
                        local token = getObjectFromGUID(tokenGUID)
                        if not token.is_face_down then return end
                        local zones = token.getZones()
                        if #zones == 0 then return end
                        for _, zone in ipairs(zones) do
                            if zone.guid == orderZone then return end
                        end
                        token.UI.show(buttonId)
                        waitMap[buttonId] = Wait.frames(function () token.UI.hide(buttonId) end, 60)
                    end

                    -- button onMouseEnter
                    function show()
                        if waitMap[buttonId] then Wait.stop(waitMap[buttonId]) end
                        self.UI.show(buttonId)
                    end

                    -- button onMouseExit
                    function hide()
                        self.UI.hide(buttonId)
                    end
                ]],
					faction,
					guid,
                    STORE.orderZones[faction]
				))
			end
		end
	end
end

return ORDER_TOKENS
