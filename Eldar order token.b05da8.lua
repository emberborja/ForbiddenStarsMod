local faction = 'ed'
local waitMap = {}
function onHover(player_color)
    if not self.is_face_down then return end
    for _, zone in ipairs(object.getZones()) do
       if zone.guid == orderZones[faction] then return end
    end
    local buttonId = self.guid..":"..faction
    self.UI.show(buttonId)
    waitMap[buttonId] = Wait.frames(function () self.UI.hide(buttonId) end, 60)
end

function show()
    local buttonId = self.guid..":"..faction
    Wait.stop(waitMap[buttonId])
    self.UI.show(buttonId)
end

function hide()
    local buttonId = self.guid..":"..faction
    self.UI.hide(buttonId)
end