
require "src/scene"
require "src/entity"
require "love.graphics"

local class = require("src/middleclass")

Player = class('Player', Entity)

local stress = 0

-- Initalize player entity
function Player:initialize()
    Entity.initialize(self, 320 / 2, 240 / 2, love.graphics.newImage("/data/player.png"), World, 
        120, 2)
end

-- Update player data
function Player:update(dt)
    stress = stress + (dt * Scene:Speed())
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
function Player:reset(x, y)
    stress = 0
    self.body:setX(x)
    self.body:setY(y)
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
    Scene:SetSpeed((interacting == true) and 0 or 2)
    self.speed = (interacting == true) and 0 or 120
end

-- Handles interaction
function Player:interact(dt)
    if self.canInteract == true and self.interacting == false then
        self.setInteracting(true)
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
        self.setInteracting(false)
    end
end
