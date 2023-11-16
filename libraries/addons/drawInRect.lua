function love.graphics.drawInRect(img, x, y, w, h, r, ox, oy, kx, ky)
    return love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

return love.graphics.drawInRect