
require "src/entities/entity"

AnimalControl = class("AnimalControl", Entity)

animalControlType = { 1, 2 }

local time = 0
local processMovement = function(animalControl)
    local _x = (animalControl.x + (animalControl.speed * animalControl.direction.x))
    local _y = (animalControl.y + (animalControl.speed * animalControl.direction.y))

    if animalControl.state == e_States.IDLE then
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
            animalControl.state = lume.randomchoice({e_States.IDLE, e_States.MOVING})
            if animalControl.state == e_States.MOVING then
                animalControl.direction = lume.randomchoice(DirectionsIndices)
            end
            shouldUpdate = true
        end

        if shouldUpdate then
            animalControl.state = e_States.INTERACT
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
    Entity.initialize(self, e_Types.ANIMALCONTROL, e_States.IDLE, 1)
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
    self.state = e_States.INTERACT
    Entity.resetAnim(self, self.state)
end

function AnimalControl:endInteraction()
    self.interacting = false
    self.state = e_States.MOVING
    Entity.resetAnim(self, self.state)
end

function AnimalControl:update(dt)
    Entity.update(self, dt)

    local inRange = lume.distance(player.x, player.y, self.x, self.y) < 35
    if inRange and not self.interacting then
        AnimalControl.startInteraction(self)
    elseif not inRange and self.interacting then
        AnimalControl.endInteraction(self)
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

function AnimalControl:finishInteraction()
    self.interacting = false
    self.interactable = false
end

function AnimalControl:resetSelf()
    self.alerted = false
    Entity.reset(self, randomPosition(self))
end

function AnimalControl:draw() Entity.draw(self) end
function AnimalControl:reset() Entity.reset(self, randomPosition()) end
