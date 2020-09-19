local NPC = require("src/entities/entity"):extend()

function NPC:new(type)
    NPC.super.new(self, type)

    self.delta_time = 0
    self.destination = { }
    self.start = { x = 0, y = 0 }
    self.move_time = lume.random(0.5, 1)
    self.idle_time = lume.random(0.5, 1)
    self.speed = lume.random(0.001, 0.01)
    self.position = {
        x = lume.random(playable_area.width*2, playable_area.width*4),
        y = lume.random(playable_area.y, playable_area.height)
    }
end

function NPC:action_update(dt) end

function NPC:collision_enter(other)
    return NPC.super.collision_enter(self, other)
end

function NPC:collision_exit(other)
    return NPC.super.collision_exit(self, other)
end

function NPC:interact()
    self:set_state(EntityStates.Action)
end

function NPC:reset()
    self.delta_time = 0
    self.destination = { }
    self.start = { x = 0, y = 0 }
    self:set_state(EntityStates.Idle)
    self.move_time = lume.random(0.5, 1)
    self.idle_time = lume.random(0.5, 1)
    self.speed = lume.random(0.001, 0.01)
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
    local delta_x = moving and -2 or 0
    if self.current_state == EntityStates.Idle then
        self.delta_time = self.delta_time + dt
        if self.delta_time >= self.idle_time then
            self.delta_time = 0
            self:set_state(EntityStates.Moving)
            self:set_destination(lume.random(0, playable_area.width * 3),
                lume.random(playable_area.y, playable_area.height))
        end
        self:move(delta_x, 0)
    elseif self.current_state == EntityStates.Action then
        self:action_update(dt)
    else
        self.delta_time = self.delta_time + self.speed
        if self.delta_time >= self.move_time and self.current_state == EntityStates.Moving then
            self.delta_time = 0
            self:set_state(EntityStates.Idle)
        else
            self.start.x = self.start.x + delta_x
            self.destination.x = self.destination.x + delta_x

            local _x = lume.lerp(self.start.x, self.destination.x, self.delta_time) - self.position.x
            local _y = lume.lerp(self.start.y, self.destination.y, self.delta_time) - self.position.y
            self:move(_x, _y)
        end
    end

    NPC.super.update(self, dt)
end

function NPC:set_destination(x, y)
    if self.destination.x ~= x or self.destination.y ~= y then
        self.delta_time = 0
        self.destination = { x = x, y = y }
        self.start = { x = self.position.x, y = self.position.y }

        if self.destination.x < self.position.x and self.direction == 1 then
            self:set_direction(-1)
        elseif self.destination.x > self.position.x and self.direction == -1 then
            self:set_direction(1)
        end
    end
end

return NPC