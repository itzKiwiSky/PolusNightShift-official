path = ...

local json = require(path .. ".json")

local object = {}
object.__index = object

--% Constructor %--

function object.new(_x, _y, _properties)
    local o = setmetatable({}, object)
    o.x = _x or 0
    o.y = _y or 0
    o.sizeX = 1
    o.sizeY = 1
    o.rotation = 0
    o.originX = 0
    o.originY = 0
    o.hitbox = {}
    o.hitbox.x = _x or 0
    o.hitbox.y = _y or 0
    o.hitbox.w = 0
    o.hitbox.h = 0
    o.animation = {}
    o.animation.animations = {}
    o.animation.type = "static"
    o.animation.frame = 1
    o.animation.currentAnimation = ""
    o.animation.frameRate = 1
    o.animation.speed = 1
    o.animation.animationPlaying = false
    o.meta = {}
    o.meta.image = nil
    o.meta.images = {}
    o.meta.quads = {}
    o.meta.animationTimer = 0
    o.meta.flipX = false
    o.meta.flipY = false
    o.meta.animationLoop = false
    o.meta.displayHitbox = false
    o.meta.isVisible = true
    o.properties = _properties or {}
    return o
end

--% Image management functions %--

function object:loadGraphic(_path)
    self.animation.type = "static"
    self.meta.image = love.graphics.newImage(_path)
end

function object:loadSparrow(_path)
    self.animation.type = "spritesheet"

    self.meta.image = love.graphics.newImage(_path .. ".png")
    local jsonData = love.filesystem.read(_path .. ".json")
    local sparrow = json.decode(jsonData)

    local Quads = {}
    for i = 1, #sparrow.frames, 1 do
        table.insert(
            self.meta.quads, love.graphics.newQuad(
            sparrow.frames[i].frame.x,
            sparrow.frames[i].frame.y,
            sparrow.frames[i].frame.w,
            sparrow.frames[i].frame.h,
            self.meta.image
            )
        )
    end
end

function object:loadSpritesheet(_path, _qw, _qh)
    self.animation.type = "spritesheet"
    self.meta.image = love.graphics.newImage(_path)

    for y = 0, self.meta.image:getHeight(), _qh do
        for x = 0, self.meta.image:getWidth(), _qw do
            table.insert(self.meta.quads, love.graphics.newQuad(x, y, _qw, _qh, self.meta.image))
        end
    end
end

function object:loadFolder(_path)
    self.animation.type = "sequencial"
    local items = love.filesystem.getDirectoryItems(_path)
    for i = 1, #items, 1 do
        table.insert(self.meta.images, love.graphics.newImage(_path .. "/" .. items[i]))
    end
end

--% Animation management %--

function object:registerAnimation(_name, _indexes)
    self.animation.animations[_name] = _indexes
end

function object:playAnimation(_animationName, _speed, _loop)
    self.animation.currentAnimation = _animationName or "idle"
    self.animation.frameRate = _speed or 1
    self.meta.animationLoop = _loop or false
    self.animation.animationPlaying = true
end

--% Object control %--

function object:centerScreen()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
end

function object:centerOrigin()
    if self.animation.type == "static" or self.animation.type == "sequencial" then
        self.originX, self.originY = self.meta.image:getWidth() / 2, self.meta.image:getHeight() / 2
    else
        local qx, qy, qw, qh = self.meta.quads[1]:getViewport()
        self.originX, self.originY = qw / 2, qh / 2
    end
end

function object:updateHitbox()
    if self.animation.type == "static" or self.animation.type == "sequencial" then
        self.hitbox.x, self.hitbox.y = self.x - (self.meta.image:getWidth() * (self.sizeX / 2)), self.y - (self.meta.image:getHeight() * (self.sizeY / 2))
        self.hitbox.w, self.hitbox.h = self.meta.image:getWidth() * self.sizeX, self.meta.image:getHeight() * self.sizeY
    else
        local x, y, w, h = self.meta.quads[1]:getViewport()
        self.hitbox.x, self.hitbox.y = self.x - (w * (self.sizeX / 2)), self.y - (h * (self.sizeY / 2))
        self.hitbox.w, self.hitbox.h = w * self.sizeX, h * self.sizeY
    end
end

function object:flipX(_flip)
    self.meta.flipX = _flip or false and true
    if self.meta.flipX then
        self.sizeX = -self.sizeX
    else
        self.sizeX = self.sizeX
    end
end

function object:flipY(_flip)
    self.meta.flipY = _flip or false and true
    if self.meta.flipY then
        self.sizeY = -self.sizeY
    else
        self.sizeY = self.sizeY
    end
end

function object:setVisible(_bool)
    self.meta.isVisible = _bool or true
end

--% super functions %--

function object:drawHitbox()
    love.graphics.rectangle("line", self.hitbox.x, self.hitbox.y, self.hitbox.w, self.hitbox.h)
end

function object:draw()
    if self.meta.isVisible then
        if self.animation.type == "static" then
            love.graphics.draw(self.meta.image, self.x, self.y, self.rotation, self.sizeX, self.sizeY, self.originX, self.originY)
        elseif self.animation.type == "sequencial" then
            love.graphics.draw(self.meta.images[self.animation.frame], self.x, self.y, self.rotation, self.sizeX, self.sizeY, self.originX, self.originY)
        else
            love.graphics.draw(self.meta.image, self.meta.quads[self.animation.frame], self.x, self.y, self.rotation, self.sizeX, self.sizeY, self.originX, self.originY)
        end
    end
end

function object:update(elapsed)
    if self.animation.animationPlaying then
        self.meta.animationTimer = self.animationTimer + 1
        if self.meta.animationTimer > self.animation.frameRate then
            self.animation.frame = self.animation.frame + 1
            if self.animation.type == "spritesheet" then
                if self.animation.frame > #self.meta.quads then
                    if self.meta.animationLoop then
                        self.animation.frame = 1
                    else
                        self.animation.frame =  #self.meta.quads
                    end
                end
            elseif self.animation.type == "sequencial" then
                if self.animation.frame > #self.meta.images then
                    if self.meta.animationLoop then
                        self.animation.frame = 1
                    else
                        self.animation.frame =  #self.meta.images
                    end
                end
            end
        end
    end
end

return object