function love.graphics.SetColor(r, g, b, a)
    love.graphics.setColor(r or 255 / 255, g or 255 / 255, b or 255 / 255, a or 255 / 255)
end

return love.graphics.SetColor