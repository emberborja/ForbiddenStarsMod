-- These are all fucntions that run when TTS emits a certain type of event
-- @see https://api.tabletopsimulator.com/events/

-- runs when a player peeks an object
-- @see https://api.tabletopsimulator.com/events/#onobjectpeek
function onObjectPeek(object, player_color)
    if string.find(object.getName(), "order token") then
        print(player_color .. " peeked: " .. object.getName())
    end
end

