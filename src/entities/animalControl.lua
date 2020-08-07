
require "src/entities/entity"

AnimalControl = class("AnimalControl", Entity)

animalControlType = { 1, 2 }

local time = 0
local processMovement = function(animalControl)
    local _x = (animalControl.x + (animalControl.speed * animalControl.direction.x))
    local _y = (animalControl.y + (animalControl.speed * animalControl.direction.y))

    if animalControl.state == EntityStates.IDLE then
        -- Maintain Idle position
        _x = moveCamera and (animalControl.x - speed) or (animalControl.x)
        _y = animalControl.y
    else
        -- Move relative to the player, if the camera is moving
        if moveCamera then
            local deltaX = (animalControl.direction.x * player.delta.x)
            if animalControl.direction.x ~= -1 then deltaX = -player.delta.x end
            _x = _x + deltaX
        end
    end

    Entity.move(animalControl, _x, _y)
    if animalControl.x < (-animalControl.width) then animalControl:reset() end
end

local processAnims = function(dt, animalControl)
    if not animalControl.alerted then
        time = time + dt

        if time > 1 then
            time = 0
            animalControl.state = lume.randomchoice({EntityStates.IDLE, EntityStates.MOVING})
            if animalControl.state == EntityStates.MOVING then
                animalControl.direction = lume.randomchoice(DirectionsIndices)
            end
            shouldUpdate = true
        end

        if shouldUpdate then
            animalControl.state = EntityStates.INTERACT
            Entity.resetAnim(animalControl, animalControl.state)
            shouldUpdate = false
        end
    elseif not animalControl.interacting then
        local _x, _y = (player.x - animalControl.x), (player.y - animalControl.y)
        local denominator = math.sqrt((_x * _x) + (_y * _y))
        animalControl.direction = {
            x = _x/denominator,
            y = _y/denominator
        }
    end
end

function randomPosition()
    return { love.math.random(screenWidth, screenWidth * 2),
        love.math.random(playableArea.y, playableArea.height) }
end

function AnimalControl:initialize()
    Entity.initialize(self, EntityTypes.ANIMALCONTROL, EntityStates.IDLE, 1)
    Entity.setPosition(self, {50, 150})

    local type = lume.randomchoice(animalControlType)
    local info = animateFactory:CreateAnimationSet("animalControl")
    local animats = info[type]

    Entity.setAnims(self, {
        animats[1],
        animats[2],
        animats[3],
        info[1].Colliders
    })
end

function AnimalControl:startInteraction()
    self.interacting = true
    self.state = EntityStates.INTERACT
    Entity.resetAnim(self, self.state)
end

function AnimalControl:endInteraction()
    self.interacting = false
    self.state = EntityStates.MOVING
    Entity.resetAnim(self, self.state)
end

function AnimalControl:update(dt)
    Entity.update(self, dt)

    if not self.interacting then
        processMovement(self)
    end

    processAnims(dt, self)

    if not self.alerted then
        if self.direction.x == -1 and player.x < self.x then
            self.alerted = true
            self.state = EntityStates.MOVING
            Entity.resetAnim(self, self.state)
        elseif self.direction.x == 1 and player.x > self.x then
            self.alerted = true
            self.state = EntityStates.MOVING
            Entity.resetAnim(self, self.state)
        end
    end
end

function AnimalControl:finishInteraction()
    self.interacting = false
    self.interactable = false
end

function AnimalControl:resetSelf()
    self.alerted = false
    Entity.reset(self, randomPosition(self))
end

function AnimalControl:collisionEnter(other)
    Entity.collisionEnter(self, other)
    if other.type == EntityTypes.PLAYER then
        AnimalControl.startInteraction(self)
    end
end

function AnimalControl:draw() Entity.draw(self) end
function AnimalControl:reset()
    Entity.reset(self, randomPosition())
    AnimalControl.endInteraction(self)
end
