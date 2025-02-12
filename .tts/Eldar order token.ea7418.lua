local waitMap = require("_waitMap")
local faction = "ed"
local tokenGUID = "ea7418"
local buttonId = tokenGUID .. ":" .. faction

-- button onMouseEnter
function show()
	if waitMap[buttonId] then
		Wait.stop(waitMap[buttonId])
	end
	self.UI.show(buttonId)
end

-- button onMouseExit
function hide()
	self.UI.hide(buttonId)
end
