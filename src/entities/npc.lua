local NPC = require("src/entities/entity"):extend()

local function determine_new_destination(entity)
    local _x = lume.randomchoice({ 1, -1 })
    local _y = lume.randomchoice({ 1, -1 })
    local x = entity.position.x + (lume.random(20, 100) * _x)
    local y = entity.position.y + (lume.random(20, 100) * _y)

    return {
        x = lume.clamp(x, playable_area.x, playable_area.width * 2),
        y = lume.clamp(y, playable_area.y, playable_area.height)
    }
end

function NPC:new(type)
    NPC.super.new(self, type)

    self.speed = 1
    self.delta_time = 0
    self.delta = { x = 0, y = 0 }
    self.idle_time = lume.random(1, 5)
    self.destination = { x = 0, y = 0 }
    self.position = {
        x = lume.random(playable_area.width*2, playable_area.width*4),
        y = lume.random(playable_area.y, playable_area.height)
    }
end

function NPC:fail_update(dt) end
function NPC:action_update(dt) end

function NPC:idle_update(dt)
    if self.delta_time >= self.idle_time then
        self.delta_time = 0
        self:set_destination()
        self:set_state(EntityStates.Moving)
    end
end

function NPC:moving_update(dt)
    local _x = self.destination.x - self.position.x
    local _y = self.destination.y - self.position.y
    local done_moving = math.abs(_x) < 1 and math.abs(_y) < 1
    if done_moving and self.current_state == EntityStates.Moving then
        self.delta_time = 0
        self:set_state(EntityStates.Idle)
    else
        local c = math.sqrt(_x*_x + _y*_y)
        self.delta.x = ((_x/c) * self.speed) + self.delta.x
        self.delta.y = ((_y/c) * self.speed)
    end
end

function NPC:interact()
    self:set_state(EntityStates.Action)
end

function NPC:reset()
    self.speed = 1
    self.delta_time = 0
    self.delta = { x = 0, y = 0 }
    self:set_state(EntityStates.Idle)
    self.idle_time = lume.random(1, 5)
    self.destination = { x = 0, y = 0 }
    self.position = {
        x = lume.random(playable_area.width*2, playable_area.width*4),
        y = lume.random(playable_area.y, playable_area.height)
    }
end

function NPC:end_interaction()
    if self.current_state == EntityStates.Action then
        self:set_state(EntityStates.Idle)
    end
end

function NPC:npc_update(dt)
    self.delta = { x = 0, y = 0 }
    self.delta_time = self.delta_time + dt

    if moving then
        self.delta.x = -2
        self.destination.x = self.destination.x + self.delta.x
    end

    if self.current_state == EntityStates.Idle then
        self:idle_update(dt)
    elseif self.current_state == EntityStates.Action then
        self:action_update(dt)
    else
        self:moving_update(dt)
    end

    if self.delta.x ~= 0 or self.delta.y ~= 0 then
        self:move(self.delta.x, self.delta.y)
    end

    NPC.super.update(self, dt)
end

function NPC:set_destination(x, y)
    local destination = determine_new_destination(self)

    self.delta_time = 0
    self.destination = { x = destination.x, y = destination.y }

    if self.destination.x < self.position.x and self.direction == 1 then
        self:set_direction(-1)
    elseif self.destination.x > self.position.x and self.direction == -1 then
        self:set_direction(1)
    end
end

return NPC