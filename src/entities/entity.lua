EntityTypes = {
    Player = 1,
    Cat    = 2,
    Kitten = 3,
    Enemy  = 4
}

EntityStates = {
    Idle   = 1,
    Moving = 2,
    Action = 3,
    Fail   = 4
}

return {
    new = function(type)
        local x, y = 0, 0
        local direction = 1
        local collisions = { }
        local animations = { }

        if type == EntityTypes.Player then
            local info = AnimationFactory.CreateAnimationSet('character')[1]
            animations = { idle = info[1], move = info[2], fail = info[4], action = info[3] }
        elseif EntityTypes.Cat then
            local info = AnimationFactory.CreateAnimationSet('cats')[1]
            animations = { idle = info[3], move = info[2], action = info[3] }
        end

        local currentAnimation = animations.idle

        return {
            SetDirection = function(dir)
                if direction ~= dir then direction = math.min(1, math.max(-1, dir)) end
                return direction
            end,

            Collider = function()
                local col = currentAnimation.CurrentFrame().collider
                return { x = col.x + x, y = col.y + y, w = col.w, h = col.h }
            end,

            CollisionEnter = function(entity)
                local index = lume.find(collisions, entity)
                if index == nil then
                    table.insert(collisions, entity)
                end
            end,

            CollisionExit = function(entity)
                local index = lume.find(collisions, entity)
                if index ~= nil then table.remove(collisions, index) end
                if #collisions == 0 then entity.EndInteraction() end
            end,

            SetState = function(state)
                if currentAnimation ~= animations[state] then
                    currentAnimation.Reset()
                    currentAnimation = animations[state]
                end
            end,

            Position = function() return x, y end,
            Update = function(dt) InternalUpdate(dt) end,
            Collisions = function() return collisions end,
            InternalUpdate = function(dt) currentAnimation.Update(dt) end,
            Draw = function() currentAnimation.Draw(x, y, direction == -1) end,
            InternalMove = function(dx, dy) x, y = math.floor((x + dx) + 0.5), math.floor((y + dy) + 0.5) end,
        }
    end
}