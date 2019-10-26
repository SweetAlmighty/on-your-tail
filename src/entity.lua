
local lume = require("src/lib/lume")
local class = require("src/lib/middleclass")

Entity = class('Entity')

local collisionFilter = function() return 'cross' end

--[[
local showCollider = function(entity)
    local x, y, w, h = World:getRect(entity)
    love.graphics.rectangle("line", x, y, w, h)
end
local showPosition = function(entity) love.graphics.points(entity.x, entity.y) end
local showDebugInfo = function(entity) showCollider(entity) showPosition(entity) end
]]

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

Types = {
    Player = 0,
    Cat = 1
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
    local _, _, w, h = self.quad:getViewport()
    self.image = love.graphics.newImage("/data/" .. imagePath)
    self.width = (self.image == nil) and 1 or w
    self.height = (self.image == nil) and 1 or h

    scene:addEntity(self)
    World:add(self, x, y, self.width, self.height)
end

function Entity:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y, nil, nil, nil, nil, nil)
    --showDebugInfo(self)
end

function Entity:reset(x, y)
    self.x, self.y = x, y
    World:update(self, x, y)
    self.interacting = false
    self.interactable = false
end

function Entity:move(x, y)
    local _x, _y, cols = World:check(self, x, y, collisionFilter)
    Entity.handleCollisions(self, cols)
    Entity.clampToPlayBounds(self, _x, _y)
    World:update(self, self.x, self.y)
end

function Entity:handleCollisions(cols)
    if cols ~= nil then
        for i = 1, #self.collisions, 1 do
            local col, index = self.collisions[i], lume.find(cols, col)
            if index == nil then
                col.item.interactable = false
                col.item:setInteracting(false)

                col.other.interactable = false
                col.other:setInteracting(false)
            end
        end
    end

    for i=1, #cols do
        local skip = cols[i].item.type == Types.Cat and cols[i].other.type == Types.Cat
        if skip == false then
            local playerType = cols[i].item.type == Types.Player
            local cat = (playerType and cols[i].other or cols[i].item)
            local player = (playerType and cols[i].item or cols[i].other)

            if cat.limit ~= 0 then
                cat.interactable = true
                player.interactable = true
            end
        end
    end

    if cols ~= nil then self.collisions = cols end
end

function Entity:clampToPlayBounds(x, y)
    self.x = (self.type == Types.Player) and Entity.clampEntityToXBounds(self, x) or x
    self.y = Entity.clampEntityToYBounds(self, y)
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

    return _x
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

    return _y
end

function Entity:getY()
    return self.y + self.height
end
