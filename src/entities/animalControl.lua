local Entity = require 'src/entities/entity'

return {
    new = function()
        local x, y = 0, 0
        local deltaTime = 0
        local direction = 1
        local destination = { }
        local chasingPlayer = false
        local startX, startY = 0, 0
        local moveTime = lume.random(0.5, 1)
        local idleTime = lume.random(0.5, 1)
        local speed = lume.random(0.001, 0.01)
        local entity = Entity.new(EntityTypes.Enemy)

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

        local lookForPlayer = function(_x, _y)
            local p = { x = _x, y = _y }
            local a = { x =  x, y =  y }
            local b = { x = a.x + (170 * direction), y = a.y + 20 }
            local c = { x = a.x + (170 * direction), y = a.y - 20 }
            return pointInTriangle(p, a, b, c)
        end

        local checkForPlayer = function()
            local _x, _y = PLAYER.Position()
            if lookForPlayer(_x, _y) and not chasingPlayer then chasingPlayer = true end
            if chasingPlayer then setDestination(_x, _y) end
        end

        entity.SetPosition(200, 200)
        entity.Type = function() return EntityTypes.Enemy end
        entity.Move = function(dx, dy) entity.InternalMove(dx, dy) end
        entity.StartInteraction = function() entity.SetState(EntityStates.Action) end
        entity.CollisionExit = function(other) entity.InternalCollisionExit(other) end

        entity.EndInteraction = function()
            if state == EntityStates.Action then
                entity.SetState(EntityStates.Idle)
            end
        end

        entity.CollisionEnter = function(other)
            if entity.InternalCollisionEnter(other) then
                if other.Type() == EntityTypes.Player then
                    entity.StartInteraction()
                end
            end
        end

        entity.Update = function(dt)
            x, y = entity.Position()

            checkForPlayer()

            if entity.State() == EntityStates.Moving then
                deltaTime = deltaTime + speed
                if deltaTime >= moveTime then
                    deltaTime = 0
                    chasingPlayer = false
                    entity.SetState(EntityStates.Idle)
                else
                    entity.Move(lume.lerp(startX, destination.x, deltaTime) - x,
                                lume.lerp(startY, destination.y, deltaTime) - y)
                end
            elseif entity.State() == EntityStates.Idle then
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