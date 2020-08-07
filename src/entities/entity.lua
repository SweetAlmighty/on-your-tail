
require "src/backend/require"

Entity = class('Entity')

catLimit = 30
pettingReduction = 15

EntityStates = {
    IDLE     = 1,
    MOVING   = 2,
    INTERACT = 3,
    FAIL     = 4
}

EntityTypes = {
    PLAYER        = 1,
    CAT           = 2,
    KITTEN        = 3,
    ANIMALCONTROL = 4
}

Directions = {
    N  = { x = 0,  y = 1 },
    NE = { x = 1,  y = 1 },
    E  = { x = 1,  y = 0 },
    SE = { x = 1,  y = -1 },
    S  = { x = 0,  y = -1 },
    SW = { x = -1, y = -1 },
    W  = { x = -1, y = 0 },
    NW = { x = -1, y = 1 }
}

DirectionsIndices = {
    Directions.N,
    Directions.NE,
    Directions.E,
    Directions.SE,
    Directions.S,
    Directions.SW,
    Directions.W,
    Directions.NW,
}

--[[
local showPosition  = function(entity) love.graphics.points(entity.x, entity.y) end
local showCollider  = function(col) love.graphics.rectangle("line", col.x, col.y, col.w, col.h) end
local showDebugInfo = function(entity) showCollider(entity.collider) showPosition(entity) end
--]]

function Entity:initialize(type, state, speed)
    self.width = 0
    self.height = 0
    self.type = type
    self.speed = speed
    self.state = state
    self.collider = { }
    self.collisions = { }
    self.interacting = false
    self.interactable = false
    self.skipCollisions = false
    self.direction = Directions.E
end

function Entity:setAnims(anims)
    self.idleAnim = anims[1]
    self.moveAnim = anims[2]
    self.interactAnim = anims[3]
    self.failAnim = anims[4]
    self.colliders = anims[#anims]
    self:resetAnim(EntityStates.IDLE)
end

function Entity:resetAnim(state)
    if state == EntityStates.IDLE then
        self.currentAnim = self.idleAnim
    elseif state == EntityStates.MOVING then
        self.currentAnim = self.moveAnim
    elseif state == EntityStates.INTERACT then
        self.currentAnim = self.interactAnim
    elseif state == EntityStates.FAIL then
        self.currentAnim = self.failAnim
    end

    self.currentAnim.Reset()
    self.collider = { x = 0,  y = 0, w = 0,  h = 0 }
end

function Entity:updateCollider()
    local frame = self.currentAnim.CurrentFrame()
    self.collider = {
        x = frame.collider.x + (self.x - frame.offset.x),
        y = frame.collider.y + (self.y - frame.offset.y),
        w = frame.collider.w,
        h = frame.collider.h
    }
end

function Entity:setPosition(position)
    self.x = position[1]
    self.y = position[2]
end

function Entity:draw()
    self.currentAnim.Draw(self.x, self.y, self.direction.x < 0)
    --showDebugInfo(self)
end

function Entity:update(dt)
    self.currentAnim.Update(dt)
    self:updateCollider()

    local dim = self.currentAnim.CurrentFrame().dimensions
    self.width = dim.w
    self.height = dim.h
end

function Entity:reset(_position)
    self.skipCollisions = false
    self:setPosition(_position)
end

function Entity:move(x, y)
    self:clampToPlayBounds(x, y)
end

function Entity:collisionEnter(other)
    self.interactable = true
    self.collisions[#self.collisions + 1] = other
end

function Entity:collisionExit(other)
    local index = lume.find(self.collisions, other)
    if index ~= nil and not other.interacting then
        self.interactable = false
        table.remove(self.collisions, index)
        if self.type == EntityTypes.PLAYER and self.interacting then
            player:finishInteraction()
        end
    end
end

function Entity:handleCollisions(cols)
    -- Only process player collisions, for the time being.
    if self.type ~= EntityTypes.PLAYER then return end

    -- Process new collisions
    for i = 1, #cols, 1 do
        local index = lume.find(self.collisions, cols[i])
        if index == nil then
            self:collisionEnter(cols[i])
            cols[i]:collisionEnter(self)
        end
    end

    -- Find collisions to remove
    local remove = {}
    for i = 1, #self.collisions, 1 do
        local index = lume.find(cols, self.collisions[i])
        if index == nil then
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
    if self.type == EntityTypes.PLAYER then
        if x < playableArea.x then
            self.x = playableArea.x
        elseif x > playableArea.width then
            self.x = playableArea.width
        else
            self.x = x
        end
    else
        self.x = x
    end

    self.x = math.floor(self.x + 0.5)

    local _y = y + self.height
    if _y < playableArea.y + self.height then
        self.y = playableArea.y
    elseif y > playableArea.height then
        self.y = playableArea.height
    else
        self.y = y
    end

    self.y = math.floor(self.y + 0.5)
end

function Entity:startInteraction() end
function Entity:finishInteraction() end
