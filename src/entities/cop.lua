
require "src/entities/entity"

Cop = class("Cop", Entity)

copType = { 1, 2 }

local time = 0
local processMovement = function(cop)
    local _x = (cop.x + (cop.speed * cop.direction.x))
    local _y = (cop.y + (cop.speed * cop.direction.y))

    if cop.state == e_States.IDLE then
        -- Maintain Idle position
        _x = moveCamera and (cop.x - speed) or (cop.x)
        _y = cop.y
    else
        -- Move relative to the player, if the camera is moving
        if moveCamera then
            local deltaX = (cop.direction.x * player.delta.x)
            if cop.direction.x ~= -1 then deltaX = -player.delta.x end
            _x = _x + deltaX
        end
    end
    
    Entity.move(cop, _x, _y)
    if cop.x < (-cop.width) then cop:reset() end
end

local processAnims = function(dt, cop)
    if not cop.alerted then
        time = time + dt

        if time > 1 then
            time = 0
            cop.state = lume.randomchoice({e_States.IDLE, e_States.MOVING})
            if cop.state == e_States.MOVING then
                cop.direction = lume.randomchoice(DirectionsIndices)
            end
            shouldUpdate = true
        end

        if shouldUpdate then
            cop.state = e_States.INTERACT
            Entity.resetAnim(cop, cop.state)
            shouldUpdate = false
        end
    elseif not cop.interacting then
        local _x, _y = (player.x - cop.x), (player.y - cop.y)
        local denominator = math.sqrt((_x * _x) + (_y * _y))
        cop.direction = {
            x = _x/denominator,
            y = _y/denominator
        }
    end
end

function randomPosition()
    return { love.math.random(screenWidth, screenWidth * 2),
        love.math.random(playableArea.y, playableArea.height) }
end

function Cop:initialize()
    Entity.initialize(self, e_Types.COP, e_States.IDLE, 1)
    Entity.setPosition(self, {50, 150})

    local type = lume.randomchoice(copType)
    local info = animateFactory:CreateAnimationSet("cop")
    local animats = info[type]

    Entity.setAnims(self, {
        animats[1],
        animats[2],
        animats[3],
        info[1].Colliders
    })
end

function Cop:startInteraction()
    self.interacting = true
    self.state = e_States.INTERACT
    Entity.resetAnim(self, self.state)
end

function Cop:endInteraction()
    self.interacting = false
    self.state = e_States.MOVING
    Entity.resetAnim(self, self.state)
end

function Cop:update(dt)
    Entity.update(self, dt)

    local inRange = lume.distance(player.x, player.y, self.x, self.y) < 35
    if inRange and not self.interacting then
        Cop.startInteraction(self)
    elseif not inRange and self.interacting then
        Cop.endInteraction(self)
    elseif not inRange then
        processMovement(self)
    end

    processAnims(dt, self)

    if not self.alerted then
        if self.direction.x == -1 and player.x < self.x then
            self.alerted = true
            self.state = e_States.MOVING
            Entity.resetAnim(self, self.state)
        elseif self.direction.x == 1 and player.x > self.x then
            self.alerted = true
            self.state = e_States.MOVING
            Entity.resetAnim(self, self.state)
        end
    end
end

function Cop:finishInteraction()
    self.interacting = false
    self.interactable = false
end

function Cop:resetSelf()
    self.alerted = false
    Entity.reset(self, randomPosition(self))
end

function Cop:draw() Entity.draw(self) end
function Cop:reset() Entity.reset(self, randomPosition()) end
