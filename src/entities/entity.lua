EntityTypes = { Player = 1, Cat = 2, Kitten = 3, Enemy = 4 }
EntityStates = { Idle = 1, Moving = 2, Action = 3, Fail = 4 }
playable_area = { x = 15, y = 150, width = 320/2, height = 240 }

local function create_animations(type)
    local sheet_names = { "character", "cats", "kittens", "enemy" }
    local info = AnimationFactory.CreateAnimationSet(sheet_names[type])[1]
    if type == EntityTypes.Player then
        return { info[1], info[2], info[3], info[4] }
    elseif type == EntityTypes.Enemy then
        return { info[1], info[2], info[3] }
    elseif type == EntityTypes.Cat or type == EntityTypes.Kitten then
        return { info[3], info[2], info[3], info[2] }
    end
end

local function internal_collider(self)
    local frame = self.current_animation.CurrentFrame()
    return {
        x = frame.collider.x + (self.position.x - frame.offset.x),
        y = frame.collider.y + (self.position.y - frame.offset.y),
        w = frame.collider.w,
        h = frame.collider.h
    }
end

local function internal_collision_enter(self, other)
    local index = lume.find(self.collisions, other)
    if index == nil then table.insert(self.collisions, other) return true end
end

local function internal_collision_exit(self, other)
    local index = lume.find(self.collisions, other)
    if index then table.remove(self.collisions, index) return true end
end

local function internal_set_state(self, state)
    if self.current_animation ~= self.animations[state] then
        self.current_state = state
        self.current_animation.Reset()
        self.current_animation = self.animations[state]
    end
end

local function internal_move(self, dx, dy)
    self.position.x = math.floor((self.position.x + dx) + 0.5)
    if self.type == EntityTypes.Player then
        self.position.x = lume.clamp(self.position.x, playable_area.x, playable_area.width)
    end

    local _y = math.floor((self.position.y + dy) + 0.5)
    self.position.y = lume.clamp(_y, playable_area.y, playable_area.height)
end

local function internal_draw(self)
    self.current_animation.Draw(self.position.x, self.position.y, self.direction == -1)
end

local function internal_set_direction(self, dir)
    if self.direction ~= dir then self.direction = lume.clamp(dir, -1, 1) end
end

local function internal_update(self, dt) self.current_animation.Update(dt) end
local function internal_is_out_of_bounds(self) return self.position.x < -60 end
local function internal_set_position(self, _x, _y) self.position = { x = _x, y = _y } end

return {
    new = function(type)
        local entity = {
            type = type,
            direction = 1,
            collisions = { },
            position = { x = 0, y = 0 },
            current_state = EntityStates.Idle,
            animations = create_animations(type),

            move = internal_move,
            draw = internal_draw,
            collider = internal_collider,
            set_state = internal_set_state,
            internal_update = internal_update,
            set_position = internal_set_position,
            set_direction = internal_set_direction,
            is_out_of_bounds = internal_is_out_of_bounds,
            internal_collision_exit = internal_collision_exit,
            internal_collision_enter = internal_collision_enter,
        }

        entity.current_animation = entity.animations[entity.current_state]

        return entity
    end
}