warnstate = {}

function warnstate:enter()
    warnImage = love.graphics.newImage("resources/preload/images/warn.png")
    warnTimer = timer.new()

    fade = sunlight.newManager()

    warnTimer:after(3, function()
        fade:runEffect("fade-out", {
            color = {r = 0, g = 0, b = 0},
            time = 2,
            func = function(_state)
                gamestate.switch(_state)
            end,
            args = {mainmenustate}
        })
    end)
end

function warnstate:draw()
    love.graphics.draw(warnImage, 0, 0)
    fade:draw()
end

function warnstate:update(elapsed)
    warnTimer:update(elapsed)
    fade:update(elapsed)
end

return warnstate