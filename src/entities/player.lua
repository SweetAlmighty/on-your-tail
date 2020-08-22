require 'src/tools/input'

return {
    new = function()
        local speed = 2
        local x, y = 0, 0
        local collisions = { }
        local transform = love.math.newTransform(0, 0)

        local info = AnimationFactory.CreateAnimationSet('character')
        local animations = {
            idle = info[1][1],
            move = info[1][2],
            fail = info[1][4],
            action = info[1][3],
        }

        local currentAnimation = animations.idle

        local dir = 1

        local setState = function(state)
            if currentAnimation ~= state then
                currentAnimation.Reset()
                currentAnimation = state
            end
        end

        return {
            Draw = function()
                currentAnimation.Draw(transform, di == -1)
            end,

            Collider = function()
                local frame = currentAnimation.CurrentFrame()
                return {
                    x = frame.collider.x + x,
                    y = frame.collider.y + y,
                    w = frame.collider.w,
                    h = frame.collider.h
                }
            end,

            Update = function(dt)
                local dx, dy = 0, 0
                if love.keyboard.isDown(InputMap.down) then dy = speed end
                if love.keyboard.isDown(InputMap.right) then
                    dx = speed
                    if dir ~= 1 then
                        transform = transform:scale(-1, 1)
                        dir = 1
                    end

                end
                if love.keyboard.isDown(InputMap.up) then dy = (-speed) end
                if love.keyboard.isDown(InputMap.left) then
                    dx = speed
                    if dir ~= -1 then
                        transform = transform:scale(-1, 1)
                        dir = -1
                    end
                end
                if dx ~= 0 or dy ~= 0 then
                    transform = transform:translate(dx, dy)
                    _, _, _, x, _, _, _, y = transform:getMatrix()
                    setState(animations.move)
                else
                    setState(animations.idle)
                end

                currentAnimation.Update(dt)
            end,

            Collisions = function() return collisions end,

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
            end
        }
    end
}