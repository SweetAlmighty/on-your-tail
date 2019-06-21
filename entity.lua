
Entity = 
{
    speed = 0,
    image = nil,
    width = 0,
    height = 0,
    body = nil,
    shape = nil,
    fixture = nil,
    isInteracting = false
}
Entity.__index = Entity

function Entity:Create(x, y, image, world, speed, category)
    local this = {}
    this.speed = speed
    this.isInteracting = false
    this.image = image
    this.width = (this.image == nil) and 1 or this.image:getWidth()
    this.height = (this.image == nil) and 1 or this.image:getHeight()
    this.body = love.physics.newBody(world, x, y, "dynamic")
    this.shape = love.physics.newRectangleShape(this.width, this.height)
    this.fixture = love.physics.newFixture(this.body, this.shape, 1)
    this.fixture:setCategory(category)
    setmetatable(this, Entity)
    return this
end

function Entity:CreateEmpty()
    local this = {}
    setmetatable(this, Entity)
    return this
end

function Entity:Draw(entity)
    love.graphics.draw(entity.image, entity.body:getX(), entity.body:getY(), nil, nil, nil, 
        entity.width / 2, entity.height / 2)
end