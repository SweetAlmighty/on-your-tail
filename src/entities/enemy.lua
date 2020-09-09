local NPC = require("src/entities/npc")

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
    local _x, _y = PLAYER.Position()
    if look_for_player(self, _x, _y - 80) and not self.chasing_player then self.chasing_player = true end
    if self.chasing_player then self:set_destination(_x, _y) end
end

local function internal_collision_enter(self, other)
    if self:collision_enter(other) then
        if other.type == EntityTypes.Player then
            self:interact()
        end
    end
end

local function internal_update(self, dt)
    check_for_player(self)
    self:npc_update(dt)

    if self.current_state == EntityStates.Idle and self.chasing_player then
        self.chasing_player = false
    end
end

return {
    new = function()
        local enemy = NPC.new(EntityTypes.Enemy)

        enemy.chasing_player = false
        enemy.type = EntityTypes.Enemy
        enemy.update = internal_update
        enemy.collision_enter = internal_collision_enter
        enemy.end_interaction = self.internal_end_interaction

        return enemy
    end
}