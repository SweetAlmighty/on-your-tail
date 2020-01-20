
require "src/entities/entity"
require "src/gameplay/interactButton"

Cat = class("Cat", Entity)

local time = 0
local shouldUpdate = false

catType = {
    "Winston",
    "Snowflake",
    "Phoenix",
    "Arya",
    "Gadget",
    "Savannah",
    "Tux",
    "Layer 8"
}

local processMovement = function(cat)
    local _x = (cat.x + (cat.speed * cat.direction.x))
    local _y = (cat.y + (cat.speed * cat.direction.y))

    if cat.state == e_States.INTERACT then
        -- Maintain sitting position
        _x = moveCamera and (cat.x - speed) or (cat.x)
        _y = cat.y
    else
        -- Move relative to the player, if the camera is moving
        if moveCamera then
            local deltaX = (cat.direction.x * player.delta.x)
            if cat.direction.x ~= -1 then deltaX = -player.delta.x end
            _x = _x + deltaX
        end
    end

    Entity.move(cat, _x, _y)
    if cat.x < (-cat.width) then
        if cat.type == Types.KITTEN then
            StateMachine:current():removeKitten(cat)
        else
            cat:reset()
        end
    end
end

local beginOffscreenTransition = function (cat)
    cat.limit = -1
    cat.state = e_States.MOVING
    Entity.resetAnim(cat, cat.state)
    cat.direction = Directions.W
end

local beingPettingTransition = function (cat)
    cat.state = e_States.INTERACT
    Entity.resetAnim(cat, cat.state)
end

local processAnims = function(dt, cat)
    if not cat.interacting then
        time = time + dt

        if time > 1 and cat.limit > 0 then
            time = 0
            cat.state = lume.randomchoice({e_States.INTERACT, e_States.MOVING})
            if cat.state == e_States.MOVING then
                cat.direction = lume.randomchoice(DirectionsIndices)
            end
            shouldUpdate = true
        end

        if shouldUpdate then
            Entity.resetAnim(cat, cat.state)
            shouldUpdate = false
        end

        cat.currentAnim:play(dt)
        cat.quad = cat.currentAnim.currentFrame
    end
end

function Cat:initialize()
    Entity.initialize(self, Types.CAT, 1)

    Entity.setState(self, e_States.IDLE)
    Entity.setDirection(self, Directions.E)
    Entity.setImageDefaults(self, 126, 120, 20, 20)
    Entity.setPosition(self, Entity.randomPosition(self))

    local animats = animatFactory:createWithLayer("cat", lume.randomchoice(catType))
    Entity.setAnims(self, { animats[2], animats[1], animats[2], animats[3] })

    self.limit = catLimit
    self.stressReduction = 8
    self.button = InteractButton:new()
end

function Cat:draw()
    Entity.draw(self)
    if self.interactable and self.limit > 0 then
        self.button:draw(self.x + 20, self.y)
    end
end

function Cat:reset()
    self.limit = catLimit
    Entity.reset(self, Entity.randomPosition(self))
end

function Cat:update(dt)
    if self.interacting then
        self.button:update(dt)
        self.limit = self.limit - (dt * 10)
        if self.limit < 0 and self.interacting then
            self.limit = 0
            self:finishInteraction()
            self.interactable = false
        end
    else processMovement(self) end

    processAnims(dt, self)

    Entity.update(self, dt)
end

function Cat:startInteraction()
    self.interacting = true
    beingPettingTransition(self)
end

function Cat:finishInteraction()
    self.button:reset()
    self.interacting = false
    self.interactable = false
    beginOffscreenTransition(self)
end