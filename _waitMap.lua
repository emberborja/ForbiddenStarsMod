local waitMap = {
    waitMap = {},
    get = function(key)
        return waitMap[key]
    end,
    set = function(key, value)
        waitMap[key] = value
    end
}

return waitMap