-- These functions are handy and reused widely


function printError(text)
    broadcastToAll(text, {1, 0, 0})
end

function printMessage(text)
    broadcastToAll(text, {0, 1, 0.2})
end

function concatTileNames(battles)
    local result = ""

    for i, v in ipairs(battles) do
      result = result..v.tileName..", "
    end

    return string.sub(result, 1, string.len(result) - 2)
end
