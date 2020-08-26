require 'src/tools/input'
local Entity = require 'src/entities/entity'

return {
    new = function()
        local speed = 2
        local interacting = false
        local entity = Entity.new(EntityTypes.Player)

        entity.Type = function() return EntityTypes.Player end

        entity.StartInteraction = function()
            interacting = true
            entity.SetState('interact')

            for _, v in ipairs(entity.Collisions()) do
                v.StartInteraction()
            end
        end

        entity.Update = function(dt)
            local dx, dy = 0, 0
            if love.keyboard.isDown(InputMap.down) then dy = speed end
            if love.keyboard.isDown(InputMap.up) then dy = -speed end
            if love.keyboard.isDown(InputMap.left) then dx = -speed entity.SetDirection(-1) end
            if love.keyboard.isDown(InputMap.right) then dx = speed entity.SetDirection(1) end

            if dx ~= 0 or dy ~= 0 then
                entity.Move(dx, dy)
                entity.SetState('move')
            else
                entity.SetState('idle')
            end

            if love.keyboard.isDown(InputMap.b) and not interacting then
                entity.StartInteraction()
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}