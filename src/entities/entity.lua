EntityTypes = { Player = 1, Cat = 2, Kitten = 3, Enemy = 4 }
EntityStates = { Idle = 1, Moving = 2, Action = 3, Fail = 4 }
playableArea = { x = 15, y = 150, width = 320/2, height = 240 }
local sheet_names = { "character", "cats", "kittens", "animalControl" }

local function create_animations(type)
    local info = AnimationFactory.CreateAnimationSet(sheet_names[type])[1]
    if type == EntityTypes.Player then
        return { info[1], info[2], info[3], info[4] }
    elseif type == EntityTypes.Enemy then
        return { info[1], info[2], info[3] }
    elseif type == EntityTypes.Cat or type == EntityTypes.Kitten then
        return { info[3], info[2], info[3], info[2] }
    end
end

return {
    new = function(type)
        local x, y = 0, 0
        local direction = 1
        local collisions = { }
        local entity_state = EntityStates.Idle
        local animations = create_animations(type)
        local current_animation = animations[entity_state]

        return {
            Position = function() return x, y end,
            State = function() return entity_state end,
            Direction = function() return direction end,
            Update = function(dt) InternalUpdate(dt) end,
            Collisions = function() return collisions end,
            SetPosition = function(_x, _y) x, y = _x, _y end,
            InternalUpdate = function(dt) current_animation.Update(dt) end,
            Draw = function() current_animation.Draw(x, y, direction == -1) end,
            DrawY = function() return y + current_animation.CurrentFrame().dimensions.h end,
            SetDirection = function(dir) if direction ~= dir then direction = lume.clamp(dir, -1, 1) end end,

            Collider = function()
                local frame = current_animation.CurrentFrame()
                return {
                    x = frame.collider.x + (x - frame.offset.x),
                    y = frame.collider.y + (y - frame.offset.y),
                    w = frame.collider.w,
                    h = frame.collider.h
                }
            end,

            InternalCollisionEnter = function(entity)
                local index = lume.find(collisions, entity)
                if index == nil then table.insert(collisions, entity) return true end
            end,

            InternalCollisionExit = function(entity)
                local index = lume.find(collisions, entity)
                if index then table.remove(collisions, index) return true end
            end,

            SetState = function(state)
                if current_animation ~= animations[state] then
                    entity_state = state
                    current_animation.Reset()
                    current_animation = animations[state]
                end
            end,

            InternalMove = function(dx, dy)
                x = math.floor((x + dx) + 0.5)
                if type == EntityTypes.Player then
                    x = lume.clamp(x, playableArea.x, playableArea.width)
                end

                y = math.floor((y + dy) + 0.5)
                y = lume.clamp(y, playableArea.y, playableArea.height)
            end
        }
    end
}