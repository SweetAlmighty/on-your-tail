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
            animations = { idle = info[1], move = info[2], action = info[3] }
        end

        local currentAnimation = animations.idle

        return {
            Collider = function()
                local col = currentAnimation.CurrentFrame().collider
                return { x = col.x + x, y = col.y + y, w = col.w, h = col.h }
            end,

            CollisionEnter = function(entity)
                local index = findIndex(collisions, entity)
                if index == nil then table.insert(collisions, index) end
            end,

            CollisionExit = function(entity)
                local index = findIndex(collisions, entity)
                if index ~= nil then table.remove(collisions, index) end
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
            Move = function(dx, dy) x, y = x + dx, y + dy end,
            InternalUpdate = function(dt) currentAnimation.Update(dt) end,
            Draw = function() currentAnimation.Draw(x, y, direction == -1) end,
            SetDirection = function(dir) if direction ~= dir then direction = dir end end,
        }
    end
}