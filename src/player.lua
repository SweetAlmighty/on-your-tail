
local lume = require("src/lib/lume")
local class = require("src/lib/middleclass")

Player = class('Player', Entity)

local stress = 0

-- Initalize player entity
function Player:initialize()
    Entity.initialize(self, 50, 200, love.graphics.newQuad(0, 95, 23, 44, 118, 187), 
        "player.png", 120, 2)
end

-- Update player data
function Player:update(dt)
    if self.interacting == false then
        stress = stress + (dt * 5)
        moveCamera = (((self.x + self.width / 2) == scene.playableArea.maxX) 
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
    end
    
    Entity.move(self, (self.x + self.speed * x), self.y)
end

-- Move the player along the Y axis
function Player:moveY(y)
    Entity.move(self, self.x, (self.y + self.speed * y))
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

-- Sets whether the player is currently interacting
function Player:setInteracting(interacting)
    self.interacting = interacting
    self.speed = (interacting == true) and 0 or 120
    scene:setSpeed((interacting == true) and 0 or 2)
end

-- Handles interaction
function Player:interact(dt)
    if self.interactable and self.interacting == false then
        Player.setInteracting(self, true)
        allowCameraMove = false
        moveCamera = false
    end

    if self.interacting then
        stress = stress - (dt * (25 * lume.count(cats)))

        if stress < 0 then
            stress = 0
        end
    end
end

-- Will stop an interaction if one is currently in progress
function Player:finishInteraction()
    if self.interacting == true then
        self.interactable = false;
        Player.setInteracting(self, false)
    end
end
