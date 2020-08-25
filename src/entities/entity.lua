
EntityTypes = {
    Player = 1,
    Cat    = 2,
    Kitten = 3,
    Enemy  = 4
}

EntityStates = {
    Idle     = 1,
    Moving   = 2,
    Interact = 3,
    Fail     = 4
}

return {
    new = function(type)
        local x, y = 0, 0
        local direction = 1
        local collisions = { }
        local animations = { }
        local transform = love.math.newTransform(0, 0)

        if type == EntityTypes.Player then
            local info = AnimationFactory.CreateAnimationSet('character')[1]
            animations = { idle = info[1], move = info[2], fail = info[4], action = info[3] }
        elseif EntityTypes.Cat then
            local info = AnimationFactory.CreateAnimationSet('cats')[1]
            animations = { idle = info[1], move = info[2], action = info[3] }
        end

        local currentAnimation = animations.idle

        return {
            SetDirection = function(dir)
                if direction ~= dir then
                    direction = dir
                    transform = transform:scale(-1, 1)
                end
            end,

            Collider = function()
                local col = currentAnimation.CurrentFrame().collider
                return { x = col.x + x, y = col.y + y, w = col.w, h = col.h }
            end,

            InternalUpdate = function(dt)
                _, _, _, x, _, _, _, y = transform:getMatrix()
                currentAnimation.Update(dt)
            end,

            CollisionEnter = function(entity)
                local index = findIndex(collisions, entity)
                if index == nil then
                    table.insert(collisions, index)
                end
            end,

            CollisionExit = function(entity)
                local index = findIndex(collisions, entity)
                if index ~= nil then
                    table.remove(collisions, index)
                end
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
            Move = function(dx, dy) transform = transform:translate(dx, dy) end,
            Draw = function() currentAnimation.Draw(transform, direction == -1) end,
        }
    end
}