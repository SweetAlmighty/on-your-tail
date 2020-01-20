
require "src/entities/entity"

Cop = class("Cop", Entity)

local time = 0
local processMovement = function(cop)
    local _x = (cop.x + (cop.speed * cop.direction.x))
    local _y = (cop.y + (cop.speed * cop.direction.y))

    if cop.state == e_States.IDLE then
        -- Maintain sitting position
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
    if not cop.interacting then
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
            Entity.resetAnim(cop, cop.state)
            shouldUpdate = false
        end

        cop.currentAnim:play(dt)
        cop.quad = cop.currentAnim.currentFrame
    end
end

function randomPosition(entity)
    return { love.math.random(screenWidth - entity.spriteWidth, screenWidth * 2),
        love.math.random(playableArea.y - entity.spriteHeight, playableArea.height) }
end

function Cop:initialize()
    Entity.initialize(self, Types.COP, 1)
    Entity.setState(self, e_States.IDLE)
    Entity.setPosition(self, {50, 150})
    Entity.setDirection(self, Directions.E)
    Entity.setImageDefaults(self, 120, 146, 40, 73)
    Entity.setAnims(self, animatFactory:create("cop"))
end

function Cop:update(dt)
    if not self.interacting then processMovement(self) end
    processAnims(dt, self)
    Entity.update(self, dt)
end

function Cop:finishInteraction()
    self.interacting = false
    self.interactable = false
end

function Cop:draw() Entity.draw(self) end
function Cop:startInteraction() self.interacting = true end
function Cop:reset() Entity.reset(self, randomPosition(self)) end
