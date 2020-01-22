
require "src/states/state"
require "src/entities/cat"
require "src/entities/cop"
require "src/entities/kitten"
require "src/entities/player"
require "src/entities/entityController"

Gameplay = class("Gameplay", Gameplay)

local mod = 0
local factor = love.math.random(5, 15)
local entityController = EntityController:new()

function Gameplay:initialize()
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
    self.hud = resources:LoadImage("stressbar")
    self.two = { x = self.width, y = 0, id = 0 }
    self.image = resources:LoadImage("background")
    self.batch = love.graphics.newSpriteBatch(self.image, 2)
    self.bar = love.graphics.newQuad(0, 0, 120, 20, 120, 40)
    self.barbg = love.graphics.newQuad(0, 20, 120, 20, 120, 40)
    self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.width, self.height)
    self.one.id = self.batch:add(self.quad, self.one.x, self.one.y)
    self.two.id = self.batch:add(self.quad, self.two.x, self.two.y)

    self.bgMusic = resources:LoadMusic("PP_Silly_Goose_FULL_Loop")
    self.bgMusic:setLooping(true)
    self.bgMusic:play()

    Gameplay.createEntities(self)
    love.graphics.setFont(menuFont)
end

function Gameplay:draw()
    self:drawBackground()
    self:drawEntities()
    self:drawUI()
end

function Gameplay:createEntities()
    player = Player:new()
    entityController:addEntity(player)
    for _=1, self.totalCats, 1 do entityController:addEntity(Cat:new()) end
end

function Gameplay:reset()
    currTime = self.elapsedTime
    self.elapsedTime = 0
    self.bgMusic:stop()
    entityController:reset()
end

function Gameplay:drawUI()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(table.concat(self.time), self.width - 75, 5)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.hud, self.barbg, 10, 10, nil, nil, nil, nil, nil)
    love.graphics.draw(self.hud, self.bar, 11, 10, nil, player.stress/121, 1, nil, nil)
end

function Gameplay:updateBackground(dt)
    self.one.x = ((self.one.x - speed) < self.threshold) and (self.width) or (self.one.x - speed)
    self.batch:set(self.one.id, self.quad, self.one.x, self.one.y)
    self.two.x = ((self.two.x - speed) < self.threshold) and (self.width) or (self.two.x - speed)
    self.batch:set(self.two.id, self.quad, self.two.x, self.two.y)
end

function Gameplay:checkForReset(dt)
    mod = mod + dt
    self.elapsedTime = self.elapsedTime + dt

    if player.stress >= 120 then
        self:reset()
        StateMachine:push(States.FailState)
    end
end

function Gameplay:update(dt)
    self:checkForReset(dt)
    self.time = { string.format("%.2f", self.elapsedTime), "s" }

    local integral, _ = math.modf(mod)
    if integral == factor then
        mod = 0
        if entityController:count() - 1 == self.totalCats then
            factor = love.math.random(5, 15)
            entityController:addEntity(Kitten:new())
        end
    end

    if moveCamera then self:updateBackground(dt) end
    entityController:update(dt)
end

function Gameplay:exit()
    self.bgMusic:stop()
    entityController:clear()
end

function Gameplay:enter() self.bgMusic:play() end
function Gameplay:pause() self.bgMusic:pause() end
function Gameplay:unpause() self.bgMusic:play() end
function Gameplay:drawEntities() entityController:draw() end
function Gameplay:drawBackground() love.graphics.draw(self.batch) end
function Gameplay:removeKitten(kitten) entityController:removeEntity(kitten) end