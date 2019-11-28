
require "src/require"
Entity = class('Entity')

catLimit = 30
pettingReduction = 15

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

local collisionFilter = function() return 'cross' end

--[[
local showCollider = function(entity)
    local x, y, w, h = World:getRect(entity)
    love.graphics.rectangle("line", x, y, w, h)
end
local showPosition = function(entity) love.graphics.points(entity.x, entity.y) end
local showDebugInfo = function(entity) showCollider(entity) showPosition(entity) end
]]

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
end

function Entity:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y)
    --showDebugInfo(self)
end

function Entity:reset(x, y)
    self.x, self.y = x, y
    World:update(self, x, y)
end

function Entity:move(x, y)
    -- Determine collisions that will happen if Entity moves to x, y
    local _x, _y, cols = World:check(self, x, y, collisionFilter)
    self:handleCollisions(cols)
    self:clampToPlayBounds(_x, _y)

    -- Move Entity to new position
    World:update(self, self.x, self.y)
end

function Entity:collisionEnter(other)
    self.interactable = true
    self.collisions[#self.collisions + 1] = other
end

function Entity:collisionExit(other)
    local index = lume.find(self.collisions, other)
    if index ~= nil then
        self.interactable = false
        table.remove(self.collisions, index)
        if self.type == Types.Player then player:finishInteraction() end
    end
end

function Entity:handleCollisions(cols)
    -- Only process player collisions, for the time being.
    if self.type ~= Types.Player then return end

    -- Retrieve Entities from Collision Data
    local others = {}
    for i = 1, #cols, 1 do
        others[#others + 1] = cols[i].other
    end

    -- Process new collisions
    for i = 1, #others, 1 do
        local index = lume.find(self.collisions, others[i])
        if index == nil then
            -- Enter
            if others[i].limit >= catLimit then
                self:collisionEnter(others[i])
                others[i]:collisionEnter(self)
            end
        end
    end

    -- Find collisions to remove
    local remove = {}
    for i = 1, #self.collisions, 1 do
        local index = lume.find(others, self.collisions[i])
        if index == nil or self.collisions[i].limit < 0 then
            remove[#remove + 1] = self.collisions[i]
        end
    end

    -- Process collisions that are no longer valid
    for i = 1, #remove, 1 do
        -- Exit
        remove[i]:collisionExit(self)
        self:collisionExit(remove[i])
    end
end

function Entity:clampToPlayBounds(x, y)
    self.x = (self.type == Types.Player) and Entity.clampEntityToXBounds(self, x) or x
    self.y = Entity.clampEntityToYBounds(self, y)
end

function Entity:clampEntityToXBounds(x)
    local _x, width, area = x, self.width/2, playableArea
    if _x < area.x then
        _x = area.x
    elseif _x > area.width - width then
        _x = area.width - width
    end
    return _x
end

function Entity:clampEntityToYBounds(y)
    local _y, height, area = y, self.height, playableArea
    if _y < area.y - height/2 then
        _y = area.y - height/2
    elseif _y > area.height - height then
        _y = area.height - height
    end
    return _y
end

function Entity:startInteraction() end
function Entity:finishInteraction() end
function Entity:getY() return self.y + self.height end
