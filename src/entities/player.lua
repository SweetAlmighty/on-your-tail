
local class = require("src/lib/middleclass")

Player = class('Player', Entity)

function Player:initialize()
    self.stress = 0
    self.currentCats = 0
    self.delta = { x = 0, y = 0 }
    Entity.initialize(self, 50, 150, love.graphics.newQuad(0, 95, 23, 44, 118, 187),
        "player.png", 120, Types.Player)
end

function Player:update(dt)
    Entity.move(self, self.x, self.y)
    if self.interacting == false then
        self.stress = self.stress + (dt * 5)
    end

    speed = (self.interacting) and 0 or 2
    self.speed = (self.interacting) and 0 or 120
    moveCamera = (((self.x + self.width / 2) == playableArea.width) and allowCameraMove)
end

function Player:moveX(x)
    allowCameraMove = (x ~= 0)
    self.delta.x = self.speed * x
    Entity.move(self, (self.x + self.delta.x), self.y)
end

function Player:moveY(y)
    self.delta.y = self.speed * y
    Entity.move(self, self.x, (self.y + self.delta.y))
end

function Player:reset()
    self.stress = 0
    Entity.reset(self, 50, 150)
end

function Player:petCats(dt)
    if #self.collisions ~= 0 then
        self:startInteraction();
        for i=1, #self.collisions, 1 do
            self.collisions[i]:startInteraction()
        end
    end

    if self.interacting then
        self.currentCats = #self.collisions
        self.stress = self.stress - (dt * (pettingReduction * self.currentCats))
        if self.stress < 0 then self.stress = 0 end
    end
end

function Player:draw() Entity.draw(self) end
function Player:startInteraction() self.interacting = true end
function Player:finishInteraction() if #self.collisions == 0 then self.interacting = false end end