
require "src/cat"
require "src/state"
require "src/player"
require "src/entityController"

local bump = require("src/lib/bump")
local class = require("src/lib/middleclass")

Scene = class("Scene", State)
World = bump.newWorld(20)

local entityController = EntityController:new()

local checkForReset = function(scene, dt)
    scene.elapsedTime = scene.elapsedTime + dt
    if player.stress >= 120 then
        scene.elapsedTime = 0
        scene:reset()
    end
end

function Scene:initialize()
    self.speed = 2
    self.totalCats = 8
    self.entities = { }
    self.elapsedTime = 0
    self.width = screenWidth
    self.height = screenHeight
    self.type = States.Gameplay
    self.coords = { x = 0, y = 0, }
    self.threshold = -(self.width - 1)
    self.image = love.graphics.newImage("/data/background.png")
    self.image:setWrap('repeat', 'clampzero')
    self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.width, self.height)

    Scene.createEntities(self)
end

function Scene:draw()
    self:drawBackground()
    self:drawEntities()
    self:drawUI()
end

function Scene:drawBackground()
    local sx = love.graphics:getWidth() / self.image:getWidth()
    local sy = love.graphics:getHeight() / self.image:getHeight()
    love.graphics.draw(self.image, self.quad, 0, 0, 0, sx, sy)
end

function Scene:createEntities()
    player = Player:new()
    entityController:addEntity(player)
    for _=1, self.totalCats, 1 do entityController:addEntity(Cat:new()) end
end

function Scene:drawUI()
    local font = gameFont
    local time = {string.format("%.2f", self.elapsedTime), "s"}

    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 10, 10, 120, 20)
    love.graphics.print(table.concat(time), self.width - 75, 5)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 10, player.stress, 20)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 10, 10, 120, 20)
end

function Scene:update(dt)
    checkForReset(self, dt)
    if moveCamera then
        local x1 = self.coords.x - self.speed
        self.coords.x = (x1 < self.threshold) and (self.width) or (x1)
        self.quad = love.graphics.newQuad(-self.coords.x, 0, self.image:getWidth() * 2,
            self.image:getHeight() * 2, self.image:getWidth(), self.image:getHeight())
    end

    entityController:update(dt)
end

function Scene:reset() entityController:reset() end
function Scene:cleanup() entityController:clear() end
function Scene:drawEntities() entityController:draw() end
function Scene:handleInteractions(dt) entityController:handleInteractions(dt) end
