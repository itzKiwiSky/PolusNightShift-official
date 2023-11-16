nightstate = {}

function nightstate:enter()
    button = require 'src.Components.Button'

    energy = 100
    oxygen = 100
    refill = 200
    gasRefill = 200
    isVentClosed = false


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

    idleRoom = love.graphics.newImage("resources/images/room.PNG")

    viewCam = camera()
    viewCam:zoomTo(0.5)

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


    --[[
    airBtn = button.new(128, 128)
    airBtn.x = 150
    airBtn.y = 380

    ventBtn = button.new(128, 128)
    ventBtn.x = 1780
    ventBtn.y = 450
    ]]--
end

function nightstate:draw()
    viewCam:attach()
        love.graphics.draw(idleRoom, 0, 0)
        love.graphics.draw(buttonsMap.airButton.drawState[buttonsMap.airButton.currentState], 0, 0)
        love.graphics.draw(buttonsMap.ventButton.drawState[buttonsMap.ventButton.currentState], 0, 0)
        airBtn:drawHitbox()
        ventBtn:drawHitbox()
        cursor:drawHitbox()
        cursor:draw()
    viewCam:detach()
    love.graphics.print(cursor.x, 90, 90)
    love.graphics.print(viewCam.x, 90, 120)
end

function nightstate:update(elapsed)
    scrollingCam.properties.scrollX = scrollingCam.properties.scrollX - (scrollingCam.properties.scrollX - love.mouse.getX()) * 0.02
    scrollingCam.properties.scrollY = scrollingCam.properties.scrollY - (scrollingCam.properties.scrollY - love.mouse.getY()) * 0.02
    scrollingCam.x = scrollingCam.properties.scrollX
    scrollingCam.y = scrollingCam.properties.scrollY

    viewCam.w = 1280

    cursor.y = love.mouse.getY()
    cursor.x = love.mouse.getX()


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

    viewCam:lookAt(scrollingCam.x, scrollingCam.y)
    if viewCam.x < love.graphics.getWidth() / 2 then
        viewCam.x = love.graphics.getWidth() / 2
    end
    if viewCam.y < love.graphics.getHeight() / 2 then
        viewCam.y = love.graphics.getHeight() / 2
    end
    
    if viewCam.x > 2100 - love.graphics.getWidth() / 2 then
        viewCam.x = 2100 - love.graphics.getWidth() / 2
    end

    if viewCam.y > 720 - love.graphics.getHeight() / 2 then
        viewCam.y = 720 - love.graphics.getHeight() / 2
    end
end

function nightstate:mousepressed(x, y, button)
    if button == 1 then

    end
    if isVentClosed then
        isVentClosed = false
    else
        isVentClosed = true
    end
end

return nightstate