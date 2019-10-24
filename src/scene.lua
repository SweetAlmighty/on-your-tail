
require "src/cat"
require "src/player"

local bump = require("src/lib/bump")
local class = require("src/lib/middleclass")

Scene = class("Scene")
World = bump.newWorld(20)

local totalCats = 8
local elapsedTime = 0

local checkForReset = function(dt)
    elapsedTime = elapsedTime + dt
    if player.stress >= 120 then
        elapsedTime = 0
        scene:reset()
    end
end

function Scene:initialize()
    self.speed = 2
    self.width = 320
    self.height = 240
    self.entities = { }
    self.coords = { x = 0, y = 0, }
    self.threshold = -(self.width - 1)
    self.image = love.graphics.newImage("/data/background.png")
    self.image:setWrap('repeat', 'clampzero')
    self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.width, self.height)
    self.playableArea = { x = 0, y = 110, width = self.width/2, height = self.height }
end

function Scene:draw()
    scene:drawBackground()
    scene:drawEntities()
    scene:drawUI()
end

function Scene:drawBackground()
    local sx = love.graphics:getWidth() / self.image:getWidth()
    local sy = love.graphics:getHeight() / self.image:getHeight()
    love.graphics.draw(self.image, self.quad, 0, 0, 0, sx, sy)
end

function Scene:createEntities()
    player = Player:new()
    for i = 1, totalCats, 1 do cat = Cat:new() end
end

function Scene:drawEntities()
    scene:sortDrawOrder()
    for i=1, #self.entities, 1 do self.entities[i]:draw() end
end

function Scene:drawUI()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 10, 10, 120, 20)
    
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 10, player.stress, 20)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 10, 10, 120, 20)

    love.graphics.print(string.format("Time: %.3f", elapsedTime), self.width - 100, 10)
end

function Scene:update(dt)
    checkForReset(dt)
    if moveCamera then
        local x1 = self.coords.x - self.speed
        self.coords.x = (x1 < self.threshold) and (self.width) or (x1)
        self.quad = love.graphics.newQuad(-self.coords.x, 0, self.image:getWidth() * 2,
            self.image:getHeight() * 2, self.image:getWidth(), self.image:getHeight())
    end

    for i=1, #scene.entities, 1 do self.entities[i]:update(dt) end
end

function Scene:addEntity(entity)
    self.entities[#self.entities+1] = entity
end

function Scene:reset()
    for i=1, #scene.entities, 1 do self.entities[i]:reset() end
end

-- Sorts the entities by their Y to mock draw order
function Scene:sortDrawOrder()
    local newTable = {}
    for i=1, #scene.entities, 1 do
        newTable[#newTable+1] = { scene.entities[i]:getY(), scene.entities[i] } 
    end
    table.sort(newTable, function(a,b) return a[1] < b[1] end)
    scene.entities = {}
    for i=1, #newTable, 1 do 
        local v = newTable[i]
        scene.entities[#scene.entities+1] = v[2]
    end
end
