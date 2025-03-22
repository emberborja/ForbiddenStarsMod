local waitMap = require("_waitMap")
local faction = "oz"
local tokenGUID = "6faf2d"
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
