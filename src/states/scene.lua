
require "src/states/state"
require "src/entities/cat"
require "src/entities/kitten"
require "src/entities/player"
require "src/entities/entityController"

local bump = require("src/lib/bump")

Scene = class("Scene", State)
World = bump.newWorld(20)

local mod = 0
local factor = love.math.random(5, 15)
local entityController = EntityController:new()

function Scene:initialize()
    self.time = {}
    self.speed = 2
    self.totalCats = 8
    self.entities = { }
    self.elapsedTime = 0
    self.width = screenWidth
    self.height = screenHeight
    self.type = States.Gameplay
    self.coords = { x = 0, y = 0, }
    self.threshold = -(self.width - 1)
    self.one = { x = 0, y = 0, id = 0 }
    self.two = { x = self.width, y = 0, id = 0 }
    self.hud = love.graphics.newImage("/data/stressbar.png")
    self.bar = love.graphics.newQuad(0, 0, 120, 20, 120, 40)
    self.barbg = love.graphics.newQuad(0, 20, 120, 20, 120, 40)
    self.image = love.graphics.newImage("/data/background.png")
    self.batch = love.graphics.newSpriteBatch(self.image, 2)
    self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.width, self.height)
    self.one.id = self.batch:add(self.quad, self.one.x, self.one.y)
    self.two.id = self.batch:add(self.quad, self.two.x, self.two.y)

    Scene.createEntities(self)
    love.graphics.setFont(menuFont)
end

function Scene:removeKitten(kitten)
    entityController:removeEntity(kitten)
end

function Scene:update(dt)
    self:checkForReset(dt)
    self.time = { string.format("%.2f", self.elapsedTime), "s" }

    --local integral, _ = math.modf(mod)
    --if integral == factor then
    --    mod = 0
    --    if entityController:count() - 1 == self.totalCats then
    --        factor = love.math.random(5, 15)
    --        entityController:addEntity(Kitten:new())
    --    end
    --end

    if moveCamera then self:updateBackground(dt) end
    entityController:update(dt)
end

function Scene:draw()
    self:drawBackground()
    self:drawEntities()
    self:drawUI()
end

function Scene:drawUI()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(table.concat(self.time), self.width - 75, 5)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.hud, self.barbg, 10, 10, nil, nil, nil, nil, nil)
    love.graphics.draw(self.hud, self.bar, 11, 10, nil, player.stress/121, 1, nil, nil)
end

function Scene:updateBackground(dt)
    local x1 = self.one.x - speed
    self.one.x = (x1 < self.threshold) and (self.width) or (x1)
    self.batch:set(self.one.id, self.quad, self.one.x, self.one.y)

    x1 = self.two.x - speed
    self.two.x = (x1 < self.threshold) and (self.width) or (x1)
    self.batch:set(self.two.id, self.quad, self.two.x, self.two.y)
end

function Scene:checkForReset(dt)
    mod = mod + dt
    self.elapsedTime = self.elapsedTime + dt

    if player.stress >= 120 then
        self:reset()
        StateMachine:push(States.FailState)
    end
end

function Scene:createEntities()
    player = Player:new()
    entityController:addEntity(player)
    for _=1, self.totalCats, 1 do entityController:addEntity(Cat:new()) end
end

function Scene:reset()
    currTime = self.elapsedTime
    self.elapsedTime = 0
    entityController:reset()
end

function Scene:cleanup() entityController:clear() end
function Scene:drawEntities() entityController:draw() end
function Scene:drawBackground() love.graphics.draw(self.batch) end
