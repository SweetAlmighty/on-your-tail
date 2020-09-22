local Enemy = require("src/entities/npc"):extend()

local function look_for_player(self, _x, _y)
    local pos = self.position
    local p = { x = _x, y = _y }
    local a = { x =  pos.x, y =  pos.y - 80 }
    local b = { x = a.x + ((screen_width/2) * self.direction), y = a.y + 20 }
    local c = { x = a.x + ((screen_width/2) * self.direction), y = a.y - 20 }
    return point_in_triangle(p, a, b, c)
end

local function check_for_player(self)
    local pos = player.position
    if look_for_player(self, pos.x, pos.y - 80) and not self.chasing_player then
        self.chasing_player = true
    end

    if self.chasing_player then
        self:set_destination(pos.x,  pos.y)
    end
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
end

function Enemy:collision_enter(other)
    if Enemy.super.collision_enter(self, other) then
        if other.type == EntityTypes.Player then
            Enemy.super.interact(self)
        end
    end
end

return Enemy