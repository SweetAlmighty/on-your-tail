
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
        self.button:draw(self.body:getX() + 10, self.body:getY() - 20)
    end
end

function Cat:update(dt)
    local catX = self.body:getX() - self.speed

    if catX < (-self.width) then
        Cat.reposition(self)
    else
        self.body:setX(catX)
    end

    Entity.clampEntityToYBounds(self)
end

function Cat:randomPosition()
    return math.random(scene:getWidth() - self.width, scene:getWidth() * 2), 
        math.random(scene:getPlayableArea().y - self.height, scene:getPlayableArea().maxY)
end

function Cat:reset()
    Entity.reset(self, Cat.randomPosition(self))
end

function Cat:reposition()
    self.body:setPosition(Cat.randomPosition(self))
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
        self.affectionLimit = self.affectionLimit - (dt * 10)
        
        self.button:update(dt)

        if self.affectionLimit < 0 then
            self.affectionLimit = 0
            Cat.finishInteraction(self)
        end
    end
end

-- Will stop an interaction if one is currently in progress
function Cat:finishInteraction()
    if self.interacting == true then
        Cat.setInteracting(self, false)
        self.interactable = false;

        self.button:reset()

        player:finishInteraction()
    end
end