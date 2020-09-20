local Entity = require("src/lib/classic"):extend()

EntityTypes = { Player = 1, Cat = 2, Kitten = 3, Enemy = 4 }
EntityStates = { Idle = 1, Moving = 2, Action = 3, Fail = 4 }
playable_area = { x = 15, y = 150, width = 320/2, height = 240 }

local enemy_type = { 1, 2 }
local cat_type = { 1, 2, 3, 4, 5, 6, 7, 8 }

local function create_animations(type)
    local sheet_names = { "character", "cats", "kittens", "enemy" }

    local real_type = 1
    if type == EntityTypes.Enemy then
        real_type = lume.randomchoice(enemy_type)
    elseif type == EntityTypes.Cat or type == EntityTypes.Kitten then
        real_type = lume.randomchoice(cat_type)
    end

    local info = AnimationFactory.CreateAnimationSet(sheet_names[type])[real_type]

    if type == EntityTypes.Player then
        return { info[1], info[2], info[3], info[4] }
    elseif type == EntityTypes.Enemy then
        return { info[1], info[2], info[3] }
    elseif type == EntityTypes.Cat or type == EntityTypes.Kitten then
        return { info[3], info[2], info[3], info[2] }
    end
end

function Entity:new(type)
    self.type = type
    self.direction = 1
    self.collisions = { }
    self.current_state = EntityStates.Idle
    self.animations = create_animations(type)
    self.current_animation = self.animations[self.current_state]
end

function Entity:move(dx, dy)
    self.position.x = self.position.x + dx--math.floor((self.position.x + dx) + 0.5)
    if self.type == EntityTypes.Player then
        self.position.x = lume.clamp(self.position.x, playable_area.x, playable_area.width)
    end

    local _y = self.position.y + dy--math.floor((self.position.y + dy) + 0.5)
    self.position.y = lume.clamp(_y, playable_area.y, playable_area.height)
end

function Entity:draw()
    self.current_animation.Draw(self.position.x, self.position.y, self.direction == -1)
end

function Entity:collider()
    local frame = self.current_animation.CurrentFrame()
    return {
        x = frame.collider.x + (self.position.x - frame.offset.x),
        y = frame.collider.y + (self.position.y - frame.offset.y),
        w = frame.collider.w,
        h = frame.collider.h
    }
end

function Entity:set_state(state)
    if self.current_animation ~= self.animations[state] then
        self.current_state = state
        self.current_animation.Reset()
        self.current_animation = self.animations[state]
    end
end

function Entity:set_position(x, y)
    self.position = { x = _x, y = _y }
end

function Entity:set_direction(direction)
    if self.direction ~= direction then
        self.direction = lume.clamp(direction, -1, 1)
    end
end

function Entity:is_out_of_bounds()
    return self.position.x < -60
end

function Entity:collision_enter(other)
    local index = lume.find(self.collisions, other)
    if index == nil then
        table.insert(self.collisions, other)
        return true
    end
end

function Entity:collision_exit(other)
    local index = lume.find(self.collisions, other)
    if index then
        table.remove(self.collisions, index)
        return true
    end
end

function Entity:update(dt)
    self.current_animation.Update(dt)
end

return Entity