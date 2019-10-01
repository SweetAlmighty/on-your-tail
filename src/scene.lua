
local class = require("src/lib/middleclass")

Scene = class("Scene")

function Scene:initialize()
    self.speed = 2
    self.width = 320
    self.height = 240
    self.image = love.graphics.newImage("/data/background_two.png")
    self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.width, self.height)
    self.one = { x = 0, y = 0, }
    self.two = { x = self.width, y = 0 }
    self.playableArea = 
    {
        x = 0,
        y = 110,
        maxX = self.width,
        maxY = self.height
    }
    self.entities = { }
end

function Scene:draw()
    love.graphics.draw(self.image, self.quad, self.one.x, self.one.y)
    love.graphics.draw(self.image, self.quad, self.two.x, self.two.y)
        
    for i, entity in ipairs(self.entities) do
        entity:draw()
    end
end

function Scene:update(dt)
    local x = self.one.x - self.speed
    self.one.x = (x < (-self.width)) and (self.width) or (x)

    x = self.two.x - self.speed
    self.two.x = (x < (-self.width)) and (self.width) or (x)
    
    for i, entity in ipairs(self.entities) do
        entity:update(dt)
    end
end

function Scene:setSpeed(s)
    self.speed = s
end

function Scene:getWidth()
    return self.width
end

function Scene:getHeight()
    return self.height
end

function Scene:getSpeed()
    return self.speed
end

function Scene:getPlayableArea()
    return self.playableArea;
end

function Scene:addEntity(entity)
    table.insert(self.entities, entity)
end

function Scene:reset()
    for i, entity in ipairs(self.entities) do
        entity:reset()
    end
end