local path = ...

local sunlight = {}
sunlight.__index = sunlight

function sunlight.newManager(_debug)
    local m = setmetatable({}, sunlight)
    m.debug = _debug or false
    m.effects = {}
    m.currentEffect = nil
    m.isEffectrunning = false

    if m.debug then
        print("--------------------------------")
        print(" Sunlight - StrawberryChocolate ")
        print("--------------------------------")
    end

    local effects = love.filesystem.getDirectoryItems(path:gsub("%.", "/") .. "/Transitions")
    for e = 1, #effects, 1 do
        if m.debug then
            print("Loaded : " .. effects[e]:gsub(".lua", ""))
        end
        m.effects[(effects[e]:gsub(".lua", "")):lower()] = require(path .. ".Transitions." .. effects[e]:gsub(".lua", ""))
    end
    return m
end

function sunlight:runEffect(_effectName, _options)
    assert(type(_effectName) == "string", "[ERROR] : Invalid parameter type | expected 'string' got" .. type(_effectName))
    assert(type(_options) == "table", "[ERROR] : Invalid parameter type | expected 'table' got" .. type(_options))

    if self.debug then
        print("running effect...")
    end

    self.currentEffect = self.effects[_effectName]

    if self.currentEffect ~= nil then
        self.currentEffect.load(_options)
        if self.debug then
            print("running effect...")
        end
    else
        error("[ERROR] : Failed to initialize transition")
    end
end

function sunlight:draw()
    if self.currentEffect ~= nil then
        self.currentEffect.draw()
    end
end

function sunlight:update(elapsed)
    assert(type(elapsed) == "number", "[ERROR] : Invalid parameter type | expected 'number' got" .. type(elapsed))

    if self.currentEffect ~= nil then
        self.currentEffect.update(elapsed)
    end
end

return sunlight