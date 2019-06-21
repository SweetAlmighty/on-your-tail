
require "entity"
require "love.graphics"

Cat = Entity:CreateEmpty()
Cat.__index = Cat

CatSprite = dofile("catSprite.lua")

function Cat:Create(x, y, world, category)
    local this = {}
    this.speed = 2
    this.image = nil
    this.width = 20
    this.height = 20
    this.body = love.physics.newBody(world, x, y, "dynamic")
    this.shape = love.physics.newRectangleShape(this.width, this.height)
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.isInteracting = false
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

function Cat:Draw(cat, index)
    love.graphics.draw(CatSprite.Image, CatSprite.Sprites[index], cat.body:getX(), cat.body:getY(), 
        nil, nil, nil, cat.width / 2, cat.height / 2)
end