local Entity = require 'src/entities/entity'

return {
    new = function(type)
        local x, y = 0, 0
        local deltaTime = 0
        local direction = 1
        local pettingLimit = 30
        local destination = { }
        local startX, startY = 0, 0
        local entity = Entity.new(type)
        local currentLimit = pettingLimit
        local moveTime = lume.random(0.5, 1)
        local idleTime = lume.random(0.5, 1)
        local speed = lume.random(0.001, 0.01)

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
        entity.CollisionExit = function(other) entity.InternalCollisionExit(other) end
        entity.CollisionEnter = function(other) entity.InternalCollisionEnter(other) end

        entity.StartInteraction = function()
            if currentLimit > 0 then
                entity.SetState(EntityStates.Action)
            end
        end

        entity.EndInteraction = function()
            if entity.State() == EntityStates.Action then
                entity.SetState(EntityStates.Idle)
            end
        end

        entity.Update = function(dt)
            x, y = entity.Position()

            if entity.State() == EntityStates.Idle then
                deltaTime = deltaTime + dt
                if deltaTime >= idleTime then
                    deltaTime = 0
                    entity.SetState(EntityStates.Moving)
                    setDestination(lume.random(0, 320), lume.random(0, 240))
                end
            elseif entity.State() == EntityStates.Action then
                currentLimit = currentLimit - (dt * 10)
                if currentLimit < 0 then
                    currentLimit = 0
                    entity.SetState(EntityStates.Fail)
                    setDestination(-100, y)
                end
            else
                deltaTime = deltaTime + speed
                if deltaTime >= moveTime and entity.State() == EntityStates.Moving then
                    deltaTime = 0
                    entity.SetState(EntityStates.Idle)
                else
                    entity.Move(lume.lerp(startX, destination.x, deltaTime) - x,
                                lume.lerp(startY, destination.y, deltaTime) - y)
                end
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}