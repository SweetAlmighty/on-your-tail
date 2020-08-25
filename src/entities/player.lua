require 'src/tools/input'
local Entity = require 'src/entities/entity'

return {
    new = function()
        local speed = 2
        local entity = Entity.new(1)

        return {
            Update = function(dt)
                local dx, dy = 0, 0
                if love.keyboard.isDown(InputMap.down) then dy = speed end
                if love.keyboard.isDown(InputMap.up) then dy = (-speed) end
                if love.keyboard.isDown(InputMap.left) then dx = speed entity.SetDirection(-1) end
                if love.keyboard.isDown(InputMap.right) then dx = speed entity.SetDirection(1) end

                if dx ~= 0 or dy ~= 0 then
                    entity.Move(dx, dy)
                    entity.SetState('move')
                else
                    entity.SetState('idle')
                end

                entity.Update(dt)
            end,
            Draw = function() entity.Draw() end,
            Collider = function() return entity.Collider() end,
            Collisions = function() return entity.Collisions() end,
            CollisionExit = function(other) entity.CollisionExit(other) end,
            CollisionEnter = function(other) entity.CollisionEnter(other) end,
        }
    end
}