local waitMap = require("_waitMap")
local faction = "ch"
local tokenGUID = "2d02ab"
local buttonId = tokenGUID .. ":" .. faction

-- button onMouseEnter
function show()
	log(waitMap)
	if waitMap.waitMap[buttonId] then
		Wait.stop(waitMap.waitMap[buttonId])
	end
	self.UI.show(buttonId)
end

-- button onMouseExit
function hide()
	self.UI.hide(buttonId)
end
