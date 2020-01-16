
require "src/require"
Entity = class('Entity')

catLimit = 30
pettingReduction = 15

e_States = {
    IDLE     = 0,
    MOVING   = 1,
    INTERACT = 2
}

Types = {
    PLAYER = 0,
    CAT    = 1,
    KITTEN = 2
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
local showCollider = function(entity)
    love.graphics.rectangle("line", entity.x, entity.y, entity.width, entity.height)
end
local showPosition = function(entity) love.graphics.points(entity.x, entity.y) end
local showDebugInfo = function(entity) showCollider(entity) showPosition(entity) end
]]

function Entity:initialize(type, speed)
    self.type = type
    self.speed = speed
    self.collisions = {}
    self.interacting = false
    self.interactable = false
end

function Entity:setImageDefaults(imageWidth, imageHeight, spriteWidth, spriteHeight)
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.spriteWidth = spriteWidth
    self.spriteHeight = spriteHeight
end

function Entity:setAnims(anims)
    self.idleAnim = anims[1]
    self.moveAnim = anims[2]
    self.interactAnim = anims[3]
    self.colliders = anims[#anims]
    Entity.resetAnim(self, e_States.IDLE)
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

    Entity.setCollider(self)
end

function Entity:setCollider()
    local _, _, w, h = self.quad:getViewport()

    local type = ""
    local index = 0

    if self.state == e_States.IDLE or self.state == e_States.MOVING then
        index = 1
        type  = (self.type == Types.PLAYER) and "idle" or "Walk"
    elseif self.state == e_States.INTERACT then
        index = 2
        type  = (self.type == Types.PLAYER) and "petting" or "Idle"
    end

    self.offsetX = (index == 0) and 0 or self.colliders[index][type]["x"]
    self.offsetY = (index == 0) and 0 or self.colliders[index][type]["y"]
    self.width   = (index == 0) and w or self.colliders[index][type]["w"]
    self.height  = (index == 0) and h or self.colliders[index][type]["h"]
end

function Entity:setDirection(direction)
    self.direction = direction
end

function Entity:setPosition(position)
    self.x = position[1]
    self.y = position[2]
end

function Entity:setState(state)
    self.state = state
end

function Entity:draw()
    local rot = (self.direction.x == -1) and -1 or 1
    local offset = (rot == -1) and self.width or 0

    -- HACK: "(rot == -1 and 20 or offset)" because offset retrieved from file
    -- produces too large an offset
    offset = (self.type == Types.PLAYER) and offset * 2 or (rot == -1 and 20 or offset)

    love.graphics.draw(self.currentAnim.img, self.quad, self.x - self.offsetX,
        self.y, 0, rot, 1, offset, 0)
    --showDebugInfo(self)
end

function Entity:reset(_position)
    Entity.setPosition(self, _position)
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
    if index ~= nil then
        self.interactable = false
        table.remove(self.collisions, index)
        if self.type == Types.PLAYER and self.interacting then
            player:finishInteraction()
        end
    end
end

function Entity:handleCollisions(cols)
    -- Only process player collisions, for the time being.
    if self.type ~= Types.PLAYER then return end

    -- Process new collisions
    for i = 1, #cols, 1 do
        local index = lume.find(self.collisions, cols[i])
        if index == nil then
            -- Enter
            if cols[i].limit >= catLimit then
                self:collisionEnter(cols[i])
                cols[i]:collisionEnter(self)
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
    self.x = (self.type == Types.PLAYER) and Entity.clampEntityToXBounds(self, x) or x
    self.y = Entity.clampEntityToYBounds(self, y)
end

function Entity:clampEntityToXBounds(x)
    local _x, width = x, self.width/2
    if _x < playableArea.x then
        _x = playableArea.x
    elseif _x > playableArea.width - width then
        _x = playableArea.width - width
    end
    return _x
end

function Entity:clampEntityToYBounds(y)
    local _y, height = y, self.height
    if _y < playableArea.y - height/2 then
        _y = playableArea.y - height/2
    elseif _y > playableArea.height - height then
        _y = playableArea.height - height
    end
    return _y
end

function Entity:startInteraction() end
function Entity:finishInteraction() end
function Entity:getY() return self.y + self.height end
