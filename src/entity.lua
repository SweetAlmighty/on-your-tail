
local lume = require("src/lib/lume")
local class = require("src/lib/middleclass")

Entity = class('Entity')

Types = {
    Player = 0,
    Cat = 1
}

local directions = {
    N  = { x = 0,  y = 1 },
    NE = { x = 1,  y = 1 },
    E  = { x = 1,  y = 0 },
    SE = { x = 1,  y = -1 },
    S  = { x = 0,  y = -1 },
    SW = { x = -1, y = -1 },
    W  = { x = -1, y = 0 },
    NW = { x = -1, y = 1 }
}

Directions = {
    directions.N, directions.NE, directions.E, directions.SE,
    directions.S, directions.SW, directions.W, directions.NW
}

function Entity:initialize(x, y, quad, imagePath, speed, type)
    self.x = x
    self.y = y
    self.type = type
    self.quad = quad
    self.speed = speed
    self.collisions = {}
    self.interacting = false
    self.interactable = false
    self.direction = directions.W
    local _x, _y, w, h = self.quad:getViewport()
    self.image = love.graphics.newImage("/data/" .. imagePath)
    self.width = (self.image == nil) and 1 or w
    self.height = (self.image == nil) and 1 or h

    scene:addEntity(self)
    World:add(self, x, y, self.width, self.height)
end

function Entity:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y, nil, nil, nil, nil, nil)
    --Entity.showDebugInfo(self)
end

function Entity:reset(x, y)
    self.x, self.y = x, y
    World:update(self, x, y)
    self.interacting = false
    self.interactable = false
end

function Entity:move(x, y)
    local _x, _y, cols, len = World:move(self, x, y, filter)

    if self.type == Types.Player then
        Entity.handleCollisions(self, cols)
    end

    Entity.clampToPlayBounds(self, _x, _y)
end

function Entity:handleCollisions(collisions)
    if collisions ~= nil then
        for i = 1, #self.collisions, 1 do
            local curr = self.collisions[i]
            local index = lume.find(collisions, curr)

            if index == nil then
                curr.item.interactable = false
                curr.item:setInteracting(false)
                
                curr.other.interactable = false
                curr.other:setInteracting(false)
            end
        end
    end

    for i=1, #collisions do
        local player, cat = collisions[i].item, collisions[i].other
        if cat.affectionLimit ~= 0 then
            cat.interactable = true
            player.interactable = true
        end
    end

    if collisions ~= nil then
        self.collisions = collisions
    end
end

function Entity:clampToPlayBounds(x, y)
    if self.type == Types.Player then
        Entity.clampEntityToXBounds(self, x)
    end
    Entity.clampEntityToYBounds(self, y)
end

function Entity:clampEntityToXBounds(x)
    local _x = x
    local width = self.width/2
    local area = scene.playableArea

    if _x < area.x then
        _x = area.x
    elseif _x > area.width - width then
        _x = area.width - width
    end

    self.x = _x
end

function Entity:clampEntityToYBounds(y)
    local _y = y
    local height = self.height
    local area = scene.playableArea

    if _y < area.y - height/2 then
        _y = area.y - height/2
    elseif _y > area.height - height then
        _y = area.height - height
    end

    self.y = _y
end

function Entity:showDebugInfo()
    Entity.showCollider(self)
    Entity.showPosition(self)
end

function Entity:showCollider()
    local x, y, w, h = World:getRect(self)
    love.graphics.rectangle("line", x, y, w, h)
end

function Entity:showPosition()
    love.graphics.points(self.x, self.y)
end

function Entity:getY()
    return self.y + self.height
end

-- Collision Filter --
function filter(item, other)
    return 'cross'
end
----------------------