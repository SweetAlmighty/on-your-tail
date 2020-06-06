require "src/backend/require"
require "src/states/state"
require "src/entities/cat"
require "src/entities/cop"
require "src/entities/kitten"
require "src/entities/player"
require "src/entities/entityController"

Gameplay = class("Gameplay", Gameplay)

local copMod = 0
local kittenMod = 0
local copFactor = love.math.random(1, 5)
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

local checkForCopSpawn = function(scene)
    local integral, _ = math.modf(copMod)
    if integral == copFactor then
        copMod = 0
        if entityController:count() - 1 == scene.totalCats then
            copFactor = love.math.random(1, 5)
            entityController:addEntity(Cop:new())
        end
    end
end


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

    self.street = animateFactory:CreateTileSet("Street")
    self.street.SetImageWrap('repeat', 'clampzero')

    self.bar = love.graphics.newQuad(0, 0, 122, 20, 122, 42)
    self.barbg = love.graphics.newQuad(0, 21, 122, 20, 122, 42)

    self.bgMusic = resources:LoadMusic("PP_Silly_Goose_FULL_Loop")
    self.bgMusic:setLooping(true)
    self.bgMusic:play()

    Gameplay.createEntities(self)
    Gameplay.createBuildings(self)
    love.graphics.setFont(menuFont)
end

function Gameplay:createBuildings()
    self.two = { one = 0, two = 0, three = 0, four = 0 }
    self.buildings = animateFactory:CreateTileSet("Buildings")

    for i=1, 3, 1 do
        local _, _, w, _ = self.buildings.GetFrameDimensions(i)
        if i == 1 then
            self.two.two = w
        elseif i == 2 then
            self.two.three = self.two.two + w
        elseif i == 3 then
            self.two.four = self.two.three + w
        end
    end
end

function Gameplay:draw()
    self.street.DrawScroll(1, 0, 126, self.one.x)
    
    for i=1, 4, 1 do
        self.buildings.Draw(i, self:getBuildingPosition(i), 0)
    end

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
    love.graphics.draw(self.hud, self.bar, 11, 10, nil, player.stress/121, 1, nil, nil)
    love.graphics.draw(self.hud, self.barbg, 10, 10, nil, nil, nil, nil, nil)
end

function Gameplay:getBuildingPosition(index)
    if index == 1 then
        return self.two.one
    elseif index == 2 then
        return self.two.two
    elseif index == 3 then
        return self.two.three
    elseif index == 4 then
        return self.two.four
    end
end

function Gameplay:updateBackground(dt)
    self:updateBuildings()
    self.one.x = self.one.x - self.speed
end

function Gameplay:updateBuildings()
    self.two.one = ((self.two.one - speed) < self.threshold) and (self.width) or (self.two.one - speed)
    self.two.two = ((self.two.two - speed) < self.threshold) and (self.width) or (self.two.two - speed)
    self.two.three = ((self.two.three - speed) < self.threshold) and (self.width) or (self.two.three - speed)
    self.two.four = ((self.two.four - speed) < self.threshold) and (self.width) or (self.two.four - speed)
end

function Gameplay:checkForReset(dt)
    copMod = copMod + dt
    kittenMod = kittenMod + dt

    self.elapsedTime = self.elapsedTime + dt

    if player.stress >= 120 then
        self:reset()
        StateMachine:push(States.FailState)
    end
end

function Gameplay:update(dt)
    self:checkForReset(dt)
    self.time = { string.format("%.2f", self.elapsedTime), "s" }
    
    checkForCopSpawn(self)
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