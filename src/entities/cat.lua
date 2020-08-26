local Entity = require 'src/entities/entity'

return {
    new = function()
        local x, y = 0, 0
        local deltaTime = 0
        local destination = nil
        local startX, startY = 0, 0
        local state = EntityStates.Action
        local moveTime = lume.random(0.5, 1)
        local idleTime = lume.random(0.5, 1)
        local speed = lume.random(0.001, 0.01)
        local entity = Entity.new(EntityTypes.Cat)

        entity.Type = function() return EntityTypes.Cat end

        entity.Update = function(dt)
            x, y = entity.Position()

            if state == EntityStates.Moving then
                deltaTime = deltaTime + speed

                if deltaTime >= moveTime then
                    deltaTime = 0
                    entity.SetState('action')
                    state = EntityStates.Action
                else
                    local dx = lume.lerp(startX, destination.x, deltaTime)-x
                    local dy = lume.lerp(startY, destination.y, deltaTime)-y
                    entity.Move(dx, dy)
                end
            elseif state == EntityStates.Action then
                deltaTime = deltaTime + dt
                if deltaTime >= idleTime then
                    deltaTime = 0
                    entity.SetState('move')
                    state = EntityStates.Moving

                    startX, startY =  x, y
                    destination = { x = lume.random(0, 320), y = lume.random(0, 240) }
                end
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}