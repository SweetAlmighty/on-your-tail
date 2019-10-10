
require "src/entity"
require "src/interactButton"
local class = require("src/lib/middleclass")

Cat = class("Cat", Entity)
    
local Sprites = {
    love.graphics.newQuad(0, 0, 20, 20, 60, 40),
    love.graphics.newQuad(0, 20, 20, 20, 60, 40),
    love.graphics.newQuad(20, 0, 20, 20, 60, 40),
    love.graphics.newQuad(20, 20, 20, 20, 60, 40),
    love.graphics.newQuad(40, 0, 20, 20, 60, 40),
    love.graphics.newQuad(40, 20, 20, 20, 60, 40)
}

function Cat:initialize()
    self.affectionLimit = 2.5
    self.button = InteractButton:new()
    Entity.initialize(self, scene:getWidth()/2, scene:getHeight()/2, Sprites[1], "cats.png", 2, 1)
end

function Cat:draw()
    Entity.draw(self);

    if self.interactable then
        self.button:draw(self.x + 10, self.y - 20)
    end
end

function Cat:update(dt)
    if player.interacting and self.interacting then
        self.button:update(dt)
    elseif moveCamera then    
        local _x, _y, cols, len = World:move(self, (self.x - self.speed), self.y, filter)

        if _x < (-self.width) then
            Cat.reposition(self)
        else
            self.x = _x
        end
    end

    Entity.clampEntityToYBounds(self, self.y)
end

function Cat:randomPosition()
    return math.random(scene:getWidth() - self.width, scene:getWidth() * 2), 
        math.random(scene.playableArea.y - self.height, scene.playableArea.maxY)
end

function Cat:reset()
    self.affectionLimit = 2.5
    Entity.reset(self, Cat.randomPosition(self))
end

function Cat:reposition()
    self.affectionLimit = 2.5
    local _x, _y = Cat.randomPosition(self)
    _x, _y = World:move(self, _x, _y, filter)
    self.x, self.y = _x, _y
end

function Cat:setIndex(index)
    Entity.setQuad(self, Sprites[index])
    self.name = index
end

-- Sets whether the cat is currently interacting
function Cat:setInteracting(interacting)
    self.interacting = interacting
    self.speed = (interacting == true) and 0 or 2
end

-- Handles interaction
function Cat:interact(dt)
    if self.interactable == true and self.interacting == false then
        self.interacting = true
    end
    
    if self.interacting == true then
        self.button:update(dt)
        self.affectionLimit = self.affectionLimit - (dt * 10)

        if self.affectionLimit < 0 then
            self.affectionLimit = 0
            Cat.finishInteraction(self)
        end
    end
end

-- Will stop an interaction if one is currently in progress
function Cat:finishInteraction()
    if self.interacting == true then
        self.button:reset()
        self.interactable = false;
        player:finishInteraction()
        Cat.setInteracting(self, false)
    end
end