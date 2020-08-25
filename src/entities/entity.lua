return {
    new = function(type)
        local x, y = 0, 0
        local direction = 1
        local collisions = { }
        local animations = { }
        local transform = love.math.newTransform(0, 0)

        if type == 1 then
            local info = AnimationFactory.CreateAnimationSet('character')[1]
            animations = { idle = info[1], move = info[2], fail = info[4], action = info[3] }
        else
            local info = AnimationFactory.CreateAnimationSet('cats')[1]
            animations = { idle = info[1], move = info[2], action = info[3] }
        end

        local currentAnimation = animations.idle

        return {
            Position = function() return x, y end,
            Collisions = function() return collisions end,
            Move = function(dx, dy) transform = transform:translate(dx, dy) end,
            Draw = function() currentAnimation.Draw(transform, direction == -1) end,

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

            Update = function(dt)
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
            end
        }
    end
}