
local class = require("src/middleclass")

Cat = class("Cat")

Sprites = {
    love.graphics.newQuad(0, 0, 20, 20, 60, 40),
    love.graphics.newQuad(0, 20, 20, 20, 60, 40),
    love.graphics.newQuad(20, 0, 20, 20, 60, 40),
    love.graphics.newQuad(20, 20, 20, 20, 60, 40),
    love.graphics.newQuad(40, 0, 20, 20, 60, 40),
    love.graphics.newQuad(40, 20, 20, 20, 60, 40)
}

function Cat:initialize()
    Entity.initialize(self, scene:getWidth()/2, scene:getHeight()/2, Sprites[1], "cats.png", 2, 1)
end

function Cat:draw()
    Entity.draw(self);
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
end
