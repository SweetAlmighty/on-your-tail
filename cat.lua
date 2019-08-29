
require "entity"
require "love.graphics"

Cat = Entity:CreateEmpty()
Cat.__index = Cat

Sprites = {
    love.graphics.newQuad(0, 0, 20, 20, 60, 40),
    love.graphics.newQuad(0, 20, 20, 20, 60, 40),
    love.graphics.newQuad(20, 0, 20, 20, 60, 40),
    love.graphics.newQuad(20, 20, 20, 20, 60, 40),
    love.graphics.newQuad(40, 0, 20, 20, 60, 40),
    love.graphics.newQuad(40, 20, 20, 20, 60, 40)
}

Image = love.graphics.newImage("data/cats.png")

function Cat:Create(x, y, world, category, index)
    local this = {}
    this.speed = 2
    this.image = nil
    this.width = 20
    this.height = 20
    this.index = index
    this.isInteracting = false
    this.body = love.physics.newBody(world, x, y, "dynamic")
    this.shape = love.physics.newRectangleShape(this.width, this.height)
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setCategory(category)
    setmetatable(this, Cat)
    return this
end

function Cat:Update(cat, speed, height)
    local catX = cat.body:getX()
    local catY = cat.body:getY() + speed

    if catY > (height - speed + cat.height) then
        catX, catY = repositionCat(cat)
    end

    cat.body:setPosition(catX, catY)
end

function Cat:Draw(cat)
    love.graphics.draw(Image, Sprites[cat.index], cat.body:getX(), cat.body:getY(), 
        nil, nil, nil, cat.width / 2, cat.height / 2)
end