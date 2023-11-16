mainmenustate = {}

function mainmenustate:enter()
    button = require 'src.Components.Button'
    bgID = 1

    cloudsInstances = {}
    strikes = {}
    _createClouds(0)
    _createClouds(1280)
    strikesBGColor = 0

    fade = sunlight.newManager()
    
    fade:runEffect("fade-in", {
        color = {r = 0, g = 0, b = 0},
        time = 2,
    })

    newgameBtnState = "idle"
    continueBtnState = "idle"

    clouds = love.graphics.newImage("resources/preload/images/clouds.png")
    lightning = love.graphics.newImage("resources/preload/images/lightning.png")
    strikeSound = love.audio.newSource("resources/preload/sounds/thunder_menu.ogg", "static")

    if not menuSound then
        menuSound = love.audio.newSource("resources/preload/sounds/menu_ambience.ogg", "static")
    end

    bg = {
        love.graphics.newImage("resources/preload/images/menuBG1.PNG"),
        love.graphics.newImage("resources/preload/images/menuBG2.PNG"),
        love.graphics.newImage("resources/preload/images/menuBG3.PNG"),
    }
    
    dogeLogo = love.graphics.newImage("resources/preload/images/doge.png")

    logo = love.graphics.newImage("resources/preload/images/logo.png")


    bgtimer = timer.new()
    strikeTimer = timer.new()

    bgtimer:every(20, function()
        bgID = love.math.random(1, 3)
    end)

    strikeTimer:every(5, function()
        _createLightningStrike(
            math.random(0, love.graphics.getWidth() - lightning:getWidth()), 
            math.random(0.1, 0.3), math.random(0.1, 0.01)
        )
    end)

    btnImage, btnQuads = love.graphics.getQuads("resources/preload/images/btn_sheet1")
    local x, y, w1, h1 = btnQuads[1]:getViewport()
    local x, y, w2, h2 = btnQuads[3]:getViewport()


    hitboxButtons = {
        newgame = button.new(0, 0, w2 * 0.2, h2 * 0.2),
        continue = button.new(0, 0, w1 * 0.2, h1 * 0.2)
    }

    hitboxButtons.newgame.x = 100
    hitboxButtons.newgame.y = 370

    hitboxButtons.continue.x = 100
    hitboxButtons.continue.y = 500


    configImage = love.graphics.newImage("resources/images/config.png")
    configBtn = button.new(love.graphics.getWidth() - 300, 20, configImage:getWidth(), configImage:getHeight())
end

function mainmenustate:draw()
    love.graphics.draw(bg[bgID], 0, 0)
    love.graphics.draw(logo, 20, 20, 0, 0.3, 0.3)
    love.graphics.draw(dogeLogo, love.graphics.getWidth() - dogeLogo:getWidth() * 0.1, love.graphics.getHeight() - dogeLogo:getHeight() * 0.1, 0, 0.1, 0.1)
    love.graphics.setColor(1, 1, 1, 0.5)
    for _, cloud in ipairs(cloudsInstances) do 
        love.graphics.draw(clouds, cloud.x, cloud.y)
    end
    love.graphics.setColor(1, 1, 1, 1)
    for _, strike in ipairs(strikes) do
        love.graphics.setColor(1, 1, 1, strike.alpha)
        love.graphics.draw(lightning, strike.x, strike.y, 0, strike.size, strike.size)
        love.graphics.setColor(1, 1, 1, 1)
    end
    hitboxButtons.newgame:draw()
    hitboxButtons.continue:draw()

    if hitboxButtons.newgame:isHover() then
        love.graphics.draw(btnImage, btnQuads[4], 100, 370, 0, 0.2)
    else
        love.graphics.draw(btnImage, btnQuads[3], 100, 370, 0, 0.2)
    end

    if hitboxButtons.continue:isHover() then
        love.graphics.draw(btnImage, btnQuads[2], 100, 500, 0, 0.2)
    else
        love.graphics.draw(btnImage, btnQuads[1], 100, 500, 0, 0.2)
    end

    love.graphics.draw(configImage, love.graphics.getWidth() - 300, 30)

    fade:draw()
end

function mainmenustate:update(elapsed)
    if not menuSound:isPlaying() then
        menuSound:play()
    end

    bgtimer:update(elapsed)
    strikeTimer:update(elapsed)

    for _, cloud in ipairs(cloudsInstances) do
        cloud.x = cloud.x - 50 * elapsed
        if cloud.x < -clouds:getWidth() then
            table.remove(cloudsInstances, _)
            _createClouds(1280)
        end
    end

    for _, strike in ipairs(strikes) do
        strike.alpha = strike.alpha - strike.timer
        if strike.alpha < 0 then
            table.remove(strikes, _)
        end
    end
    fade:update(elapsed)
end

function mainmenustate:mousepressed(x, y, button)
    if configBtn:mousepressed(x, y, button) then
        fade:runEffect("fade-out", {
            color = { r = 0, g = 0, b = 0 },
            time = 2,
            func = function(_state)
                gamestate.switch(_state)
            end,
            args = {configstate}
        })
    end
end

--------------------------------------------------------------

function _createClouds(_x)
    local cloud = {}
    cloud.x = _x or 0
    cloud.y = 0
    table.insert(cloudsInstances, cloud)
end

function _createLightningStrike(_x, _size, _timer)
    local s = {}
    s.x = _x or 0
    s.y = 0
    s.size = _size or 0.5
    s.alpha = 1
    s.timer = _timer or 0.1
    strikesBGColor = 0.3
    table.insert(strikes, s)
end

return mainmenustate