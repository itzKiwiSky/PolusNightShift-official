local clickzone = {}
clickzone.__index = clickzone

function clickzone.new(_x, _y, _w, _h)
    local c = setmetatable({}, clickzone)
    c.x = _x or 0
    c.y = _y or 0
    c.w = _w or 16
    c.h = _h or 16
    return c
end

function clickzone:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function clickzone:hover()
    local mx, my = love.mouse.getPosition()
    if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
        return true
    end
    return false
end

function clickzone:click()
    local mx, my = love.mouse.getPosition()
    if love.mouse.isDown(1) then
        if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
            return true
        end
    end
    return false
end

return clickzone