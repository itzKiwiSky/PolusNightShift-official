local transitionmodule = {}
local transition = {
    time = 0,
    lengthTime = 0,
    run = nil,
    args = {}
}
local color = {}
local major, minor, revision, _ = love.getVersion()

function transitionmodule.load(_options)
    color.r = _options.color.r or 0
    color.b = _options.color.g or 0
    color.g = _options.color.b or 0
    color.a = 255

    -- If version is 11.
    if major == 11 and minor >= 0 and revision >= 0 then
        color.r = _options.color.r or 0 / 255
        color.b = _options.color.g or 0 / 255
        color.g = _options.color.b or 0 / 255
        color.a = 255 / 255
    end

    transition.lengthTime = _options.time or 2
    transition.run = _options.func
    transition.args = _options.args or {}
end

function transitionmodule.draw()
    love.graphics.setColor(color.r, color.g, color.b, color.a)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function transitionmodule.update(elapsed)
    transition.time = transition.time + elapsed
    if major == 11 and minor >= 0 and revision >= 0 then
        color.a = 1 - (transition.time / transition.lengthTime) * 1;
    else
        color.a = 255 - (transition.time / transition.lengthTime) * 255;
    end
    
    if color.a < 0 then
        if transition.run ~= nil then
            if #transition.args > 0 then
                transition.run(unpack(transition.args))
            else
                transition.run()
            end
        end
    end
end

return transitionmodule