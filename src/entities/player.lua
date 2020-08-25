require 'src/tools/input'
local Entity = require 'src/entities/entity'

return {
    new = function()
        local speed = 2
        local entity = Entity.new(EntityTypes.Player)

        entity.Type = function() return EntityTypes.Player end

        entity.Update = function(dt)
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

            entity.InternalUpdate(dt)
        end

        return entity
    end
}