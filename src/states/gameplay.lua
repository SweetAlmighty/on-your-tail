require "src/states/state"
require "src/entities/cat"
require "src/entities/animalControl"
require "src/entities/kitten"
require "src/entities/player"
require "src/backend/require"
require "src/backend/backgroundHandler"
require "src/entities/entityController"

Gameplay = class("Gameplay", Gameplay)

local animalControlMod = 0
local kittenMod = 0
local pause = false
local pauseTime = 0
local unpause = false
local animalControlFactor = love.math.random(1, 5)
local kittenFactor = love.math.random(5, 15)
local entityController = EntityController:new()

local checkForKittenSpawn = function(scene)
    local integral, _ = math.modf(kittenMod)
    if integral == kittenFactor then
        kittenMod = 0
        if entityController:count() - 1 == scene.totalCats then
            kittenFactor = love.math.random(5, 15)
            entityController:addEntity(Kitten:new())
        end
    end
end

local checkForAnimalControlSpawn = function(scene)
    local integral, _ = math.modf(animalControlMod)
    if integral == animalControlFactor then
        animalControlMod = 0
        if entityController:count() - 1 == scene.totalCats then
            animalControlFactor = love.math.random(1, 5)
            entityController:addEntity(AnimalControl:new())
        end
    end
end

function Gameplay:initialize()
    self.time = { }
    self.speed = 2
    self.totalCats = 8
    self.entities = { }
    self.elapsedTime = 0
    self.streetPosition = 0
    self.width = screenWidth
    self.height = screenHeight
    self.type = States.Gameplay
    self.threshold = -(self.width - 1)

    self.street = animateFactory:CreateTileSet("Street")
    self.street.SetImageWrap('repeat', 'clampzero')

    self.bar = love.graphics.newQuad(0, 0, 122, 20, 122, 42)
    self.barbg = love.graphics.newQuad(0, 21, 122, 20, 122, 42)

    self.bgMusic = resources:LoadMusic("PP_Silly_Goose_FULL_Loop")
    self.bgMusic:setLooping(true)
    self.bgMusic:play()

    self.backgroundHandler = BackgroundHandler:new()

    Gameplay.createEntities(self)
    love.graphics.setFont(menuFont)
end

function Gameplay:draw()
    self.street.DrawScroll(1, 0, 126, self.streetPosition)
    self.backgroundHandler:draw()
    self:drawEntities()
    self:drawUI()
end

function Gameplay:createEntities()
    player = Player:new()
    entityController:addEntity(player)
    for _=1, self.totalCats, 1 do entityController:addEntity(Cat:new()) end
end

function Gameplay:reset()
    pause = false
    unpause = false
    player:reset()
    entityController:reset()
    self.backgroundHandler:reset()
end

function Gameplay:drawUI()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(table.concat(self.time), self.width - 75, 5)
    love.graphics.setColor(1, 1, 1)
end

function Gameplay:updateBackground(dt)
    self.backgroundHandler:update()
    self.streetPosition = self.streetPosition - self.speed
end

function Gameplay:checkForReset(dt)
    kittenMod = kittenMod + dt
    animalControlMod = animalControlMod + dt
    self.elapsedTime = self.elapsedTime + dt
end

function Gameplay:Fail()
    pause = true
end

function Gameplay:checkPauseState(dt)
    if pause and unpause then self:reset() end

    if pause then
        pauseTime = pauseTime + dt
        if pauseTime > 1.5 then
            unpause = true
            pauseTime = 0

            currTime = self.elapsedTime
            self.elapsedTime = 0

            self.bgMusic:stop()
            StateMachine:push(States.FailMenu)
        end
    end
end

function Gameplay:update(dt)
    self:checkPauseState(dt)
    self:checkForReset(dt)
    
    self.time = { string.format("%.2f", self.elapsedTime), "s" }

    checkForAnimalControlSpawn(self)
    checkForKittenSpawn(self)

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