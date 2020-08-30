EntityTypes = { Player = 1, Cat = 2, Kitten = 3, Enemy = 4 }
EntityStates = { Idle = 1, Moving = 2, Action = 3, Fail = 4 }

local sheetNames = { 'character', 'cats', 'kittens', 'animalControl' }

local createAnimations = function(type)
    local info = AnimationFactory.CreateAnimationSet(sheetNames[type])[1]
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
        local entityState = EntityStates.Idle
        local animations = createAnimations(type)
        local currentAnimation = animations[entityState]
        local playableArea = { x = 15, y = 150, width = screenWidth/2, height = screenHeight }

        return {
            Position = function() return x, y end,
            State = function() return entityState end,
            Direction = function() return direction end,
            Update = function(dt) InternalUpdate(dt) end,
            Collisions = function() return collisions end,
            SetPosition = function(_x, _y) x, y = _x, _y end,
            InternalUpdate = function(dt) currentAnimation.Update(dt) end,
            Draw = function() currentAnimation.Draw(x, y, direction == -1) end,
            DrawY = function() return y + currentAnimation.CurrentFrame().dimensions.h end,
            SetDirection = function(dir) if direction ~= dir then direction = math.min(1, math.max(-1, dir)) end end,

            Collider = function()
                local col = currentAnimation.CurrentFrame().collider
                return { x = col.x + x, y = col.y + y, w = col.w, h = col.h }
            end,

            InternalCollisionEnter = function(entity)
                local index = lume.find(collisions, entity)
                if index == nil then table.insert(collisions, entity) return true end
            end,

            InternalCollisionExit = function(entity)
                local index = lume.find(collisions, entity)
                if index ~= nil then table.remove(collisions, index) return true end
            end,

            SetState = function(state)
                if currentAnimation ~= animations[state] then
                    entityState = state
                    currentAnimation.Reset()
                    currentAnimation = animations[state]
                end
            end,

            InternalMove = function(dx, dy)
                x = math.floor((x + dx) + 0.5)
                if type == EntityTypes.Player then
                    x = math.min(playableArea.width, math.max(playableArea.x, x))
                end

                local _y = math.floor((y + dy) + 0.5)
                y = math.min(playableArea.height, math.max(playableArea.y, _y))
            end,
        }
    end
}