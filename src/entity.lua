
local class = require "src/lib/middleclass"

Entity = class('Entity')

function Entity:initialize(x, y, quad, imagePath, speed, category)
    self.speed = speed
    self.quad = quad

    local x, y, w, h = self.quad:getViewport()

    self.interacting = false
    self.interactable = false
    self.image = love.graphics.newImage("/data/" .. imagePath)
    self.width = (self.image == nil) and 1 or w
    self.height = (self.image == nil) and 1 or h
    self.body = love.physics.newBody(World, x, y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setCategory(category)

    scene:addEntity(self)
end

function Entity:draw()
    love.graphics.draw(self.image, self.quad, self.body:getX(), self.body:getY(), nil, nil, nil, 
        self.width / 2, self.height)
end

function Entity:setQuad(quad)
    self.quad = quad
end

function Entity:reset(x, y)
    self.interactable = false
    self.interacting = false
    self.body:setPosition(x, y)
end

function Entity:clampToPlayBounds()
    Entity.clampEntityToXBounds(self)
    Entity.clampEntityToYBounds(self)
end

function Entity:clampEntityToXBounds()
    local posX = self.body:getX()
    local width = self.width / 2
    local area = scene:getPlayableArea()

    if posX < area.x + width then
        posX = area.x + width
    elseif posX > area.maxX - width then
        posX = area.maxX - width
    end

    self.body:setX(posX)
end

function Entity:clampEntityToYBounds()    
    local posY = self.body:getY()
    local height = self.height/2
    local area = scene:getPlayableArea()

    if posY < area.y + height then
        posY = area.y + height
    elseif posY > area.maxY then
        posY = area.maxY
    end

    self.body:setY(posY)
end