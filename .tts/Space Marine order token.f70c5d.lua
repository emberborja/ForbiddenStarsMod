local waitMap = require("_waitMap")
local faction = "sm"
local tokenGUID = "f70c5d"
local buttonId = tokenGUID .. ":" .. faction

-- button onMouseEnter
function show()
	if waitMap.waitMap[buttonId] then
		Wait.stop(waitMap.waitMap[buttonId])
	end
	self.UI.show(buttonId)
end

-- button onMouseExit
function hide()
	self.UI.hide(buttonId)
end
