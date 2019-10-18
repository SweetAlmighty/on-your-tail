
local class = require("src/lib/middleclass")

Player = class('Player', Entity)

local quad = love.graphics.newQuad(0, 95, 23, 44, 118, 187)

-- Initalize player entity
function Player:initialize()
    self.stress = 0
    Entity.initialize(self, 50, 150, quad, "player.png", 120, Types.Player)
end

-- Update player data
function Player:update(dt)
    if self.interacting == false then
        self.stress = self.stress + (dt * 5)
        moveCamera = (((self.x + self.width / 2) == scene.playableArea.width) 
            and allowCameraMove)
    end
end

-- Draw player to the screen
function Player:draw()
    Entity.draw(self);
end

-- Move the player along the X axis
function Player:moveX(x)
    if self.interacting == false then
        allowCameraMove = (x ~= 0)
        Entity.move(self, (self.x + self.speed * x), self.y)
    end
end

-- Move the player along the Y axis
function Player:moveY(y)
    Entity.move(self, self.x, (self.y + self.speed * y))
end

-- Resets the player's position and stress
function Player:reset()
    self.stress = 0
    Entity.reset(self, 50, 150)
end

-- Sets whether the player is currently interacting
function Player:setInteracting(interacting)
    self.interacting = interacting
    self.speed = (interacting == true) and 0 or 120
    scene.speed = ((interacting == true) and 0 or 2)
end

-- Handles interaction
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

-- Will stop an interaction if one is currently in progress
function Player:finishInteraction()
    if self.interacting == true then
        self.interactable = false;
        self:setInteracting(false)
    end
end
