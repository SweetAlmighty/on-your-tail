
require "src/entity"
require "love.graphics"

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

Image = love.graphics.newImage("/data/cats.png")

function Cat:initialize()
    Entity.initialize(self, 320 / 2, 240 / 2, love.graphics.newImage("/data/cats.png"), World, 
        2, 1)
end

function Cat:setIndex(index)
    self.index = index
end

function Cat:update()--cat, speed, height)
    local catX = self.body:getX() - self.speed
    local catY = self.body:getY()

    if catX < (-self.width) then
        catX, catY = repositionCat(self)
    end

    self.body:setPosition(catX, catY)
end

function Cat:draw()
    love.graphics.draw(self.image, Sprites[self.index], self.body:getX(), self.body:getY(), 
        nil, nil, nil, self.width / 2, self.height / 2)
end