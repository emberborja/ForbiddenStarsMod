-- These functions are handy and reused widely
-- If at all possible, no side effects

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
    -- this .sub call removes the final ", "
    return string.sub(result, 1, string.len(result) - 2)
end

function updateContainerAmount(container)
    if container.UI.getValue("amount") != nil then
      container.UI.setValue("amount", container.getQuantity())
    end
end
