nightstate = {}

function nightstate:enter()
    button = require 'src.Components.Button'

    energy = 100
    oxygen = 100
    refill = 200
    gasRefill = 200
    isVentClosed = false

    perspective = love.graphics.newShader("resources/shaders/perspective.glsl")
    perspective:send("depth", 3.5)
    shaderchain.clearAppended()
    shaderchain.resize(1280, 720)
    shaderchain.append(perspective)

    state = "idle"

    cameras = {
        map = {
            cam1 = love.graphics.newImage("resources/images/cam/cam1.png"),
            cam2 = love.graphics.newImage("resources/images/cam/cam2.png"),
            cam3 = love.graphics.newImage("resources/images/cam/cam3.png"),
            cam4 = love.graphics.newImage("resources/images/cam/cam4.png"),
            cam5 = love.graphics.newImage("resources/images/cam/cam5.png"),
            cam6 = love.graphics.newImage("resources/images/cam/cam6.png"),
        },
        vents = {

        }
    }
    
    camMap = {
        idle = love.graphics.newImage("resources/images/cam_map.PNG"),
        vent = love.graphics.newImage("resources/images/cam_map_ventHightlight.PNG"),
    }

    camButtonsImg, camButtonsQuads = love.graphics.getQuads("resources/images/sheets/camButtons")

    idleRoom = love.graphics.newImage("resources/images/room.png")

    viewCam = gamera.new(0, 0, 2000, 720)

    cursor = object.new()
    cursor:loadGraphic("resources/images/cursor_active.png")
    cursor:centerOrigin()
    cursor:updateHitbox()
    
    scrollingCam = object.new()
    scrollingCam.properties.scrollX = scrollingCam.x
    scrollingCam.properties.scrollY = scrollingCam.y

    buttonsMap = {
        airButton = {
            drawState = {
                active = love.graphics.newImage("resources/images/air_btn_pressed.PNG"),
                idle = love.graphics.newImage("resources/images/air_btn.PNG")
            },
            currentState = "idle"
        },
        ventButton = {
            drawState = {
                active = love.graphics.newImage("resources/images/btn_vent_pressed.PNG"),
                idle = love.graphics.newImage("resources/images/btn_vent.PNG")
            },
            currentState = "idle"
        }
    }

    airBtn = object.new(150, 380)
    airBtn.hitbox.w = 64
    airBtn.hitbox.h = 64

    ventBtn = object.new(1780, 450)
    ventBtn.hitbox.w = 64
    ventBtn.hitbox.h = 64

    tableOffice = object.new(2000 / 2, love.graphics.getHeight())
    tableOffice:loadGraphic("resources/images/table.png")
    tableOffice:centerOrigin()
    tableOffice:updateHitbox()

    tableOfficeParallax = parallax.new(viewCam, 0.5)
    tableOffice.sizeX, tableOffice.sizeY = tableOffice.sizeX + 1.2, tableOffice.sizeY + 1.2
end

local function _draw(l, t, w, h)
    love.graphics.draw(idleRoom, 0, 0)
    love.graphics.draw(buttonsMap.airButton.drawState[buttonsMap.airButton.currentState], 0, 0)
    love.graphics.draw(buttonsMap.ventButton.drawState[buttonsMap.ventButton.currentState], 0, 0)
    airBtn:drawHitbox()
    ventBtn:drawHitbox()
    cursor:draw()
    cursor:drawHitbox()
    tableOfficeParallax:draw(function()
        tableOffice:draw()
    end)
end

function nightstate:draw()
    --shaderchain.start()
    viewCam:draw(function(l, t, w, h)
        _draw(l, t, w, h)
    end)
    --shaderchain.stop()
end

function nightstate:update(elapsed)
    cursor.x, cursor.y = viewCam:toWorld(love.mouse.getX(), love.mouse.getY())
    cursor.hitbox.x, cursor.hitbox.y = cursor.x, cursor.y

    scrollingCam.properties.scrollX = scrollingCam.properties.scrollX - (scrollingCam.properties.scrollX - love.mouse.getX()) * 0.02
    scrollingCam.properties.scrollY = scrollingCam.properties.scrollY - (scrollingCam.properties.scrollY - love.mouse.getY()) * 0.02
    scrollingCam.x = scrollingCam.properties.scrollX
    scrollingCam.y = scrollingCam.properties.scrollY

    viewCam:setPosition(scrollingCam.x, scrollingCam.y)


    if love.mouse.isDown(1) then
        if collision.rectRect(cursor.hitbox, airBtn.hitbox) then
            buttonsMap.airButton.currentState = "active"
        else
            buttonsMap.airButton.currentState = "idle"
        end
    else
        buttonsMap.airButton.currentState = "idle"
    end

    if isVentClosed then
        buttonsMap.ventButton.currentState = "active"
    else
        buttonsMap.ventButton.currentState = "idle"
    end
end

function nightstate:mousepressed(x, y, button)
    if button == 1 then
        if collision.rectRect(cursor.hitbox, ventBtn.hitbox) then
            if isVentClosed then
                isVentClosed = false
            else
                isVentClosed = true
            end
        end
    end
end

return nightstate