local button = {}
button.__index = button

function button.new(_x, _y, _w, _h)
    local b = setmetatable({}, button)
    b.x = _x or 0
    b.y = _y or 0
    b.w = _w or 32
    b.h = _h or 32
    return b
end

function button:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function button:isHover(elapsed)
    if love.mouse.getX() >= self.x and love.mouse.getX() < self.x + self.w and love.mouse.getY() >= self.y and love.mouse.getY() < self.y + self.h then
        return true
    end
end

function button:mousepressed(x, y, button)
    if button == 1 then
        if x >= self.x and x < self.x + self.w and y >= self.y and y < self.y + self.h then
            return true
        end
    end
    return false
end

return button