-- Color multipler
local COLOR_MUL = love._version >= "11.0" and 1 or 255

function love.graphics.newGradient(dir, ...)
    -- Check for direction
    local isHorizontal = true
    if dir == "vertical" then
        isHorizontal = false
    elseif dir ~= "horizontal" then
        error("bad argument #1 to 'gradient' (invalid value)", 2)
    end

    -- Check for colors
    local colorLen = select("#", ...)
    if colorLen < 2 then
        error("color list is less than two", 2)
    end

    -- Generate mesh
    local meshData = {}
    if isHorizontal then
        for i = 1, colorLen do
            local color = select(i, ...)
            local x = (i - 1) / (colorLen - 1)

            meshData[#meshData + 1] = {x, 1, x, 1, color[1] / 255, color[2] / 255, color[3] / 255, color[4] or 255 / 255}
            meshData[#meshData + 1] = {x, 0, x, 0, color[1] / 255, color[2] / 255, color[3] / 255, color[4] or 255 / 255}
        end
    else
        for i = 1, colorLen do
            local color = select(i, ...)
            local y = (i - 1) / (colorLen - 1)

            meshData[#meshData + 1] = {1, y, 1, y, color[1] / 255, color[2] / 255, color[3] / 255, color[4] or 255 / 255}
            meshData[#meshData + 1] = {0, y, 0, y, color[1] / 255, color[2] / 255, color[3] / 255, color[4] or 255 / 255}
        end
    end

    -- Resulting Mesh has 1x1 image size
    return love.graphics.newMesh(meshData, "strip", "static")
end

return love.graphics.newGradient