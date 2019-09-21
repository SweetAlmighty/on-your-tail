local class = require "src/middleclass"

Entity = class('Entity')

function Entity:initialize(x, y, image, world, speed, category)
    self.speed = speed
    self.image = image
    self.interacting = false
    self.width = (self.image == nil) and 1 or self.image:getWidth()
    self.height = (self.image == nil) and 1 or self.image:getHeight()
    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setCategory(category)
end

function Entity:draw()
    love.graphics.draw(self.image, self.body:getX(), self.body:getY(), nil, nil, nil,
        self.width / 2, self.height / 2)
end

function Entity:clampToPlayBounds()
    Entity.clampEntityToXBounds(self)
    Entity.clampEntityToYBounds(self)
end

function Entity:clampEntityToXBounds()
    local posX = self.body:getX()
    local width = self.width / 2

    if posX < Scene:PlayableArea().x + width then
        posX = Scene:PlayableArea().x + width
    elseif posX > Scene:PlayableArea().maxX - width then
        posX = Scene:PlayableArea().maxX - width
    end

    self.body:setX(posX)
end

function Entity:clampEntityToYBounds()    
    local posY = self.body:getY()
    local height = self.height / 2

    if posY < Scene:PlayableArea().y + height then
        posY = Scene:PlayableArea().y + height
    elseif posY > Scene:PlayableArea().maxY - height then
        posY = Scene:PlayableArea().maxY - height
    end

    self.body:setY(posY)
end