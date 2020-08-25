local Entity = require 'src/entities/entity'

return {
    new = function()
        local x, y = 0, 0
        local timeStep = 0
        local destination = nil
        local traveling = false
        local startX, startY = 0, 0
        local entity = Entity.new(EntityTypes.Cat)
        local speed = love.math.random(0.01, 0.09)

        entity.Type = function() return EntityTypes.Cat end

        entity.Update = function(dt)
            x, y = entity.Position()

            if not traveling then
                traveling = true
                startX, startY =  x, y
                destination = { x = love.math.random(0, 320), y = love.math.random(0, 240) }
            else
                if timeStep >= 1 then
                    timeStep = 0
                    traveling = false
                else
                    local dx, dy = lerp(startX, destination.x, timeStep)-x, lerp(startY, destination.y, timeStep)-y
                    entity.Move(dx, dy)
                end

                timeStep = timeStep + speed
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}