
require "src/backend/require"

Entity = class('Entity')

catLimit = 30
pettingReduction = 15

e_States = {
    IDLE     = 1,
    MOVING   = 2,
    INTERACT = 3
}

e_Types = {
    PLAYER = 1,
    CAT    = 2,
    KITTEN = 3,
    COP    = 4
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


local showPosition  = function(entity) love.graphics.points(entity.x, entity.y) end
local showCollider  = function(col) love.graphics.rectangle("line", col.x, col.y, col.w, col.h) end
local showDebugInfo = function(entity) showCollider(entity.collider) showPosition(entity) end


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
    self.direction = Directions.E
end

function Entity:setAnims(anims)
    self.idleAnim = anims[1]
    self.moveAnim = anims[2]
    self.interactAnim = anims[3]
    self.colliders = anims[#anims]
    self:resetAnim(e_States.IDLE)
end

function Entity:resetAnim(state)
    if state == e_States.IDLE then
        self.currentAnim = self.idleAnim
    elseif state == e_States.MOVING then
        self.currentAnim = self.moveAnim
    elseif state == e_States.INTERACT then
        self.currentAnim = self.interactAnim
    end

    self.currentAnim:reset()
    self.quad = self.currentAnim.currentFrame

    self:updateCollider()
end

function Entity:updateCollider()
    self.collider = {
        x = self.colliders[self.state]["x"] + self.x,
        y = self.colliders[self.state]["y"] + self.y,
        w = self.colliders[self.state]["w"],
        h = self.colliders[self.state]["h"]
    }
end

function Entity:setPosition(position)
    self.x = position[1]
    self.y = position[2]
end

function Entity:draw()
    local rot = (self.direction.x == -1) and -1 or 1
    local offset = (rot == -1) and self.width or 0

    love.graphics.draw(self.currentAnim.img, self.quad, self.x, self.y, 0, rot, 1, offset, 0)

    showDebugInfo(self)
end

function Entity:update(dt)
    _, _, self.width, self.height = self.quad:getViewport()
    self:updateCollider()
end

function Entity:reset(_position)
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
        if self.type == e_Types.PLAYER and self.interacting then
            player:finishInteraction()
        end
    end
end

function Entity:handleCollisions(cols)
    -- Only process player collisions, for the time being.
    if self.type ~= e_Types.PLAYER then return end

    -- Process new collisions
    for i = 1, #cols, 1 do
        local index = lume.find(self.collisions, cols[i])
        if index == nil then
            -- Enter
            if cols[i].type == e_Types.CAT or cols[i].type == e_Types.KITTEN then
                if cols[i].limit >= catLimit then
                    self:collisionEnter(cols[i])
                    cols[i]:collisionEnter(self)
                end
            end
        end
    end

    -- Find collisions to remove
    local remove = {}
    for i = 1, #self.collisions, 1 do
        local index = lume.find(cols, self.collisions[i])
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
    self.x = (self.type == e_Types.PLAYER) and self:clampEntityToXBounds(x) or x
    self.y = self:clampEntityToYBounds(y)
end

function Entity:clampEntityToXBounds(x)
    local _x = x
    if _x < playableArea.x - self.collider.x then
        _x = playableArea.x - self.collider.x
    elseif _x > playableArea.width - self.collider.w then
        _x = playableArea.width - self.collider.w
    end return _x
end

function Entity:clampEntityToYBounds(y)
    local _y = y
    local height = self.height - (self.collider.h/2)
    if (_y + height) < playableArea.y then
        _y = playableArea.y - height
    elseif _y > playableArea.height - self.height then
        _y = playableArea.height - self.height
    end return _y
end

function Entity:startInteraction() end
function Entity:finishInteraction() end
