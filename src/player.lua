
local class = require("src/middleclass")

Player = class('Player', Entity)

local stress = 0

-- Initalize player entity
function Player:initialize()
    Entity.initialize(self, scene:getWidth()/2, scene:getHeight()/2, 
        love.graphics.newQuad(0, 95, 23, 44, 118, 187), "player.png", 120, 2)
end

-- Update player data
function Player:update(dt)
    stress = stress + (dt * scene:getSpeed())
    Entity.clampToPlayBounds(self)
end

-- Draw player to the screen
function Player:draw()
    Entity.draw(self);
end

-- Move the player along the X axis
function Player:moveX(x)
    self.body:setX(self.body:getX() + self.speed * x)
end

-- Move the player along the Y axis
function Player:moveY(y)
    self.body:setY(self.body:getY() + self.speed * y)
end

-- Returns the player's stress level
function Player:stress()
    return stress;
end

-- Resets the player's position and stress
function Player:reset()
    stress = 0
    Entity.reset(self, scene:getWidth() / 2, scene:getHeight() / 2)
end

-- Sets whether the player can interact
function Player:setInteractable(interactable)
    self.canInteract = interactable
end

-- Returns whether the player is interacting with something
function Player:isInteracting()
    return self.interacting
end

-- Sets whether the player is currently interacting
function Player:setInteracting(interacting)
    self.interacting = interacting
    self.speed = (interacting == true) and 0 or 120
    scene:setSpeed((interacting == true) and 0 or 2)
end

-- Handles interaction
function Player:interact(dt)
    if self.canInteract == true and self.interacting == false then
        Player.setInteracting(self, true)
    elseif self.interacting == true then
        stress = stress - (dt * 10)
        if stress < 0 then
            stress = 0
        end
    end
end

-- Will stop an interaction if one is currently in progress
function Player:finishInteraction()
    if self.interacting == true then
        Player.setInteracting(self, false)
    end
end
