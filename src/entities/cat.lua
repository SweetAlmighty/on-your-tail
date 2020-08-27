local Entity = require 'src/entities/entity'

return {
    new = function()
        local x, y = 0, 0
        local deltaTime = 0
        local direction = 1
        local destination = nil
        local startX, startY = 0, 0
        local state = EntityStates.Action
        local moveTime = lume.random(0.5, 1)
        local idleTime = lume.random(0.5, 1)
        local speed = lume.random(0.001, 0.01)
        local entity = Entity.new(EntityTypes.Cat)

        local setDestination = function(_x, _y)
            if destination.x ~= _x or destination.y ~= _y then
                deltaTime = 0
                startX, startY =  x, y
                destination = { x = _x, y = _y }

                if destination.x < x and direction == 1 then
                    direction = entity.SetDirection(-1)
                elseif destination.x > x and direction == -1 then
                    direction = entity.SetDirection(1)
                end
            end
        end

        entity.Type = function() return EntityTypes.Cat end
        entity.Move = function(dx, dy) entity.InternalMove(dx, dy) end
        entity.StartInteraction = function() entity.SetState('action') end

        entity.EndInteraction = function()
            if state == EntityStates.Action then
                entity.SetState(EntityStates.Idle)
            end
        end

        entity.Update = function(dt)
            x, y = entity.Position()

            if entity.State() == EntityStates.Moving then
                deltaTime = deltaTime + speed

                if deltaTime < moveTime then
                    entity.Move(lume.lerp(startX, destination.x, deltaTime) - x,
                                lume.lerp(startY, destination.y, deltaTime) - y)
                else
                    deltaTime = 0
                    entity.SetState(EntityStates.Action)
                end
            elseif entity.State() == EntityStates.Action then
                deltaTime = deltaTime + dt
                if deltaTime >= idleTime then
                    deltaTime = 0
                    entity.SetState(EntityStates.Moving)
                    setDestination(lume.random(0, 320), lume.random(0, 240))
                end
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}