require("src/backend/resources")
require("src/backend/animatFactory")

entities = { }
local winston = nil
local animations = nil

local catType = {
    "Winston",
    "Snowflake",
    "Phoenix",
    "Arya",
    "Gadget",
    "Savannah",
    "Tux",
    "Layer 8"
}

e_States = {
    MOVING   = 1,
    IDLE     = 2,
    INTERACT = 3
}

e_Types = {
    PLAYER = 1,
    CAT    = 2,
    KITTEN = 3,
    COP    = 4
}


local drawCollider = function(entity)
    love.graphics.rectangle("line", collider(entity))
    love.graphics.points(entity.position.x, entity.position.y)
end

local draw = function(entity)
    love.graphics.draw(entity.image, entity.quad, entity.position.x, entity.position.y)
end

local animate = function (entity, dt)
    entity.anim():play(dt)
    entity.quad = entity.anim().currentFrame
end

local move = function(entity, dt)
    local percent = (entity.speed * dt)
    local dx = isDown('left') and (-percent) or (isDown('right') and (percent) or 0)
    local dy = isDown('up') and (-percent) or (isDown('down') and (percent) or 0)

    entity.transform = entity.transform:translate(dx, dy)
    entity.transform:translate(dx, dy)

    local _, _, _, x, _, _, _, y = entity.transform:getMatrix()
    entity.position = { x = x, y = y }
end


function loadImages()
    animations = createAnimationWithLayer("cat", catType[math.random(1, #catType)])
end

function createEntity(type)
    local entity = { }
    entity.type = type

    entity.state = e_States.MOVING
    entity.animations = animations
    entity.anim = function()
        return entity.animations[entity.state]
    end
    entity.image = entity.anim().img
    entity.quad = entity.anim().currentFrame

    local _x, _y, _w, _h = entity.quad:getViewport();
    entity.viewport = {
        x = _x, y = _y,
        w = _w, h = _h
    }

    -- Temp
    entity.speed = math.random(-100, 100)
    entity.transform = love.math.newTransform(math.random(320), math.random(240))

    -- Collisions
    entity.collisions = { }
    entity.enterCollision = function(other)
        entity.collisions[#entity.collisions+1] = other
    end
    entity.exitCollision = function(other)
        table.remove(entity.collisions, other)
    end

    entities[#entities+1] = entity
end

function createCat()
end

function moveEntities(dt)
    for i=1, #entities, 1 do
        move(entities[i], dt)
        animate(entities[i], dt)
    end
    checkCollisions()
end

function drawEntities()
    for i=1, #entities, 1 do
        draw(entities[i])
        --drawCollider(entities[i])
    end
end
