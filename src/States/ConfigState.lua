configstate = {}

function configstate:enter()
    vcr = love.graphics.newFont("resources/fonts/vcr.ttf", 18)
    pc = love.graphics.newImage("resources/images/pc_config.png")

    menuState = 1
    menus = {
        categories = {
            "graphics",
            "audio",
            "misc",
            "gamejoltapi"
        },
        graphics = {
            "shaders",
            "fullscreen"
        },
        misc = {
            "subtitles",
            "language",
        }
    }

    bg = {
        love.graphics.newImage("resources/images/light_room.png"),
        love.graphics.newImage("resources/images/light_room_low.png"),
    }

    bgState = 1
    bgSeconds = 5

    bgtimer = timer.new()

    bgtimer:every(bgSeconds, function()
        bgState = math.random(1, 2)
        bgSeconds = math.random(1, 5)
    end)

    pcui = suit.new()

    pcui.theme.color = {
        normal   = {bg = {42 / 255, 255 / 255, 0 / 255}, fg = {15 / 255, 89 / 255, 255 / 255}},
        hovered  = {bg = {0 / 255, 255 / 255, 0 / 255}, fg = {255 / 255, 255 / 255, 255 / 255}},
        active   = {bg = {151 / 255, 255 / 255, 0 / 255}, fg = {225 / 255, 153 / 255, 0 / 255}}
    }
end

function configstate:draw()
    love.graphics.print(lang.settings.options)
    love.graphics.draw(bg[bgState], 300, 0)
    love.graphics.draw(pc, 0, 0)
    pcui:draw()
end

function configstate:update(elapsed)
    bgtimer:update(elapsed)
    local btnY = 130
    --pcui:Button(lang.settings.options["graphics"].title, {id = lang.settings.options["graphics"].title .. "Btn"}, 150, btnY, 196, 32)

    if menuState == "" then
        for c = 1, #menus, 1 do
            if pcui:Button(lang.settings.options[menus[c]].title, {id = lang.settings.options[menus[c]].title .. "Btn"}, 150, btnY, 196, 32).hit then
                menuState = menus[c]
            end
            btnY = btnY + 35
        end
    elseif menuState == menus[1] then
        for c = 1, #menus, 1 do
            if pcui:Button(lang.settings.options[menus[c]].title, {id = lang.settings.options[menus[c]].title .. "Btn"}, 150, btnY, 196, 32).hit then
                menuState = menus[c]
            end
            btnY = btnY + 35
        end
    end
end

return configstate