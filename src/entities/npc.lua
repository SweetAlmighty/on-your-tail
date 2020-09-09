local Entity = require("src/entities/entity")

local function internal_end_interaction(self)
    if self.current_state == EntityStates.Action then
        self:set_state(EntityStates.Idle)
    end
end

local function internal_set_destination(self, _x, _y)
    if self.destination.x ~= _x or self.destination.y ~= _y then
        self.delta_time = 0
        self.destination = { x = _x, y = _y }
        self.start = { x = self.position.x, y = self.position.y }

        if self.destination.x < self.position.x and self.direction == 1 then
            self:set_direction(-1)
        elseif self.destination.x > self.position.x and self.direction == -1 then
            self:set_direction(1)
        end
    end
end

local function internal_npc_update(self, dt)
    if self.current_state == EntityStates.Idle then
        self.delta_time = self.delta_time + dt
        if self.delta_time >= self.idle_time then
            self.delta_time = 0
            self:set_state(EntityStates.Moving)
            self:set_destination(lume.random(0, 320), lume.random(playable_area.y, playable_area.height))
        end
    elseif self.current_state == EntityStates.Action then
        self:action_update(dt)
    else
        self.delta_time = self.delta_time + self.speed
        if self.delta_time >= self.move_time and self.current_state == EntityStates.Moving then
            self.delta_time = 0
            self:set_state(EntityStates.Idle)
        else
            local _x = lume.lerp(self.start.x, self.destination.x, self.delta_time) - self.position.x
            local _y = lume.lerp(self.start.y, self.destination.y, self.delta_time) - self.position.y
            self:move(_x, _y)
        end
    end

    self:internal_update(dt)
end

local function internal_interact(self)
    self:set_state(EntityStates.Action)
end

local function internal_collision_exit(self)
    self:internal_collision_exit()
end

local function internal_collision_enter(self)
    self:internal_collision_enter()
end

return {
    new = function(type)
        local npc = Entity.new(type)

        npc.delta_time = 0
        npc.destination = { }
        npc.start = { x = 0, y = 0 }
        npc.move_time = lume.random(0.5, 1)
        npc.idle_time = lume.random(0.5, 1)
        npc.speed = lume.random(0.001, 0.01)

        npc.interact = internal_interact
        npc.action_update = function(dt) end
        npc.npc_update = internal_npc_update
        npc.collision_exit = internal_collision_exit
        npc.set_destination = internal_set_destination
        npc.collision_enter = internal_collision_enter
        npc.internal_end_interaction = internal_end_interaction

        npc:set_position(lume.random(0, 320), lume.random(playable_area.y, playable_area.height))

        return npc
    end
}