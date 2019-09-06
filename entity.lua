
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
    this.image = image
    this.isInteracting = false
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

function Entity:Clamp(e)
    clampEntityToXBounds(e)
    clampEntityToYBounds(e)
end

function clampEntityToXBounds(e)
    local posX = e.body:getX()
    local width = e.width / 2

    if posX < scene.playableArea.x + width then
        posX = scene.playableArea.x + width
    elseif posX > scene.playableArea.maxX - width then
        posX = scene.playableArea.maxX - width
    end

    e.body:setX(posX)
end

function clampEntityToYBounds(e)    
    local posY = e.body:getY()
    local height = e.height / 2

    if posY < scene.playableArea.y + height then
        posY = scene.playableArea.y + height
    elseif posY > scene.playableArea.maxY - height then
        posY = scene.playableArea.maxY - height
    end

    e.body:setY(posY)
end