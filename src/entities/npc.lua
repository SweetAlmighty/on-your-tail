local Entity = require 'src/entities/entity'

return {
    new = function(type)
        local x, y = 0, 0
        local deltaTime = 0
        local destination = { }
        local startX, startY = 0, 0
        local entity = Entity.new(type)
        local moveTime = lume.random(0.5, 1)
        local idleTime = lume.random(0.5, 1)
        local speed = lume.random(0.001, 0.01)

        local lerpMove = function()
            local _x = lume.lerp(startX, destination.x, deltaTime) - x
            local _y = lume.lerp(startY, destination.y, deltaTime) - y
            entity.Move(_x, _y)
        end

        entity.ActionUpdate = function(dt) end
        entity.Move = function(dx, dy) entity.InternalMove(dx, dy) end
        entity.StartInteraction = function() entity.SetState(EntityStates.Action) end
        entity.CollisionExit = function(other) entity.InternalCollisionExit(other) end

        entity.EndInteraction = function()
            if entity.State() == EntityStates.Action then
                entity.SetState(EntityStates.Idle)
            end
        end

        entity.SetDestination = function(_x, _y)
            if destination.x ~= _x or destination.y ~= _y then
                deltaTime = 0
                startX, startY =  x, y
                destination = { x = _x, y = _y }

                if destination.x < x and entity.Direction() == 1 then
                    entity.SetDirection(-1)
                elseif destination.x > x and entity.Direction() == -1 then
                    entity.SetDirection(1)
                end
            end
        end

        entity.NPCUpdate = function(dt)
            x, y = entity.Position()

            if entity.State() == EntityStates.Idle then
                deltaTime = deltaTime + dt
                if deltaTime >= idleTime then
                    deltaTime = 0
                    entity.SetState(EntityStates.Moving)
                    entity.SetDestination(lume.random(0, 320), lume.random(0, 240))
                end
            elseif entity.State() == EntityStates.Action then
                entity.ActionUpdate(dt)
            else
                deltaTime = deltaTime + speed
                if deltaTime >= moveTime and entity.State() == EntityStates.Moving then
                    deltaTime = 0
                    entity.SetState(EntityStates.Idle)
                else
                    lerpMove()
                end
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}