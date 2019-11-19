
local class = require("src/lib/middleclass")

Player = class('Player', Entity)

function Player:initialize()
    self.stress = 0
    Entity.initialize(self, 50, 150, love.graphics.newQuad(0, 95, 23, 44, 118, 187),
        "player.png", 120, Types.Player)
end

function Player:update(dt)
    if self.interacting == false then
        self.stress = self.stress + (dt * 5)
        moveCamera = (((self.x + self.width / 2) == playableArea.width)
            and allowCameraMove)
    end
end

function Player:moveX(x)
    if self.interacting == false then
        allowCameraMove = (x ~= 0)
        Entity.move(self, (self.x + self.speed * x), self.y)
    end
end

function Player:moveY(y)
    if self.interacting == false then
        Entity.move(self, self.x, (self.y + self.speed * y))
    end
end

function Player:reset()
    self.stress = 0
    Entity.reset(self, 50, 150)
end

function Player:setInteracting(interacting)
    self.interacting = interacting
    self.speed = (interacting == true) and 0 or 120
    speed = ((interacting == true) and 0 or 2)
end

function Player:interact(dt)
    if self.interactable and self.interacting == false then
        self:setInteracting(true)
        allowCameraMove = false
        moveCamera = false
    end

    if self.interacting then
        self.stress = self.stress - (dt * (25 * #self.collisions))
        if self.stress < 0 then self.stress = 0 end
    end
end

function Player:finishInteraction()
    if self.interacting == true then
        self.interactable = false
        self:setInteracting(false)
    end
end

function Player:draw() Entity.draw(self) end
