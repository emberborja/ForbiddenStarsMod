local COMBAT = {
	battleData = nil,
    unitsPositions = {},
    botFightZoneGUID = "9f0b03",
    topFightZoneGUID = "839de2",
    topFightTileGUID = "3d4d0d",
    botFightTileGUID = "d96e1d"
}

function COMBAT.init()
    local topFightTile = getObjectFromGUID(COMBAT.topFightTileGUID)
    local botFightTile = getObjectFromGUID(COMBAT.botFightTileGUID)
    topFightTile.registerCollisions(false)
    topFightTile.interactable = false
    botFightTile.registerCollisions(false)
    botFightTile.interactable = false
    COMBAT.topFightTile = topFightTile
    COMBAT.botFightTile = botFightTile
end

return COMBAT
