local Enemy = require("src/entities/npc"):extend()

local half_width = 320/2

local function look_for_player(self, _x, _y)
    local pos = self.position
    local p = { x = _x, y = _y }
    local a = { x =  pos.x, y =  pos.y - 80 }
    local b = { x = a.x + (half_width * self.direction), y = a.y + 20 }
    local c = { x = a.x + (half_width * self.direction), y = a.y - 20 }
    return point_in_triangle(p, a, b, c)
end

local function check_for_player(self)
    local pos = player.position
    if look_for_player(self, pos.x, pos.y - 80) and not self.chasing_player then self.chasing_player = true end
    if self.chasing_player then self:set_destination(pos.x, pos.y) end
end

function Enemy:new()
    Enemy.super.new(self, EntityTypes.Enemy)
    self.chasing_player = false
end

function Enemy:reset()
    Enemy.super.reset(self)
    self.chasing_player = false
end

function Enemy:update(dt)
    check_for_player(self)
    self:npc_update(dt)

    if self.current_state == EntityStates.Idle and self.chasing_player then
        self.chasing_player = false
    end
end

function Enemy:action_update(dt)
    self.current_limit = self.current_limit - (dt * 10)
    if self.current_limit < 0 then self:end_interaction() end
end

function Enemy:collision_enter(other)
    if Enemy.super.collision_enter(self, other) then
        if other.type == EntityTypes.Player then
            self:interact()
        end
    end
end

return Enemy