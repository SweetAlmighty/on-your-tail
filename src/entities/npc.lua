local Entity = require "src/entities/entity"

return {
    new = function(type)
        local x, y = 0, 0
        local delta_time = 0
        local destination = { }
        local start_x, start_y = 0, 0
        local entity = Entity.new(type)
        local move_time = lume.random(0.5, 1)
        local idle_time = lume.random(0.5, 1)
        local speed = lume.random(0.001, 0.01)

        entity.SetPosition(lume.random(0, 320), lume.random(playable_area.y, playable_area.height))

        local function lerp_move()
            local _x = lume.lerp(start_x, destination.x, delta_time) - x
            local _y = lume.lerp(start_y, destination.y, delta_time) - y
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
                delta_time = 0
                start_x, start_y =  x, y
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
                delta_time = delta_time + dt
                if delta_time >= idle_time then
                    delta_time = 0
                    entity.SetState(EntityStates.Moving)
                    entity.SetDestination(lume.random(0, 320), lume.random(playable_area.y, playable_area.height))
                end
            elseif entity.State() == EntityStates.Action then
                entity.ActionUpdate(dt)
            else
                delta_time = delta_time + speed
                if delta_time >= move_time and entity.State() == EntityStates.Moving then
                    delta_time = 0
                    entity.SetState(EntityStates.Idle)
                else
                    lerp_move()
                end
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}