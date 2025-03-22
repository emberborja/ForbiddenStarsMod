local waitMap = require("_waitMap")
local faction = "ed"
local tokenGUID = "99d309"
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
