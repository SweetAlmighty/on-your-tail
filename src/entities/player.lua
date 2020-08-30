require 'src/tools/input'
local Entity = require 'src/entities/entity'

return {
    new = function()
        local speed = 2
        local deltaX = 0
        local failTime = 1.5
        local startFailTime = 0
        local startFailState = false
        local entity = Entity.new(EntityTypes.Player)

        entity.DeltaX = function() return deltaX end
        entity.Type = function() return EntityTypes.Player end
        entity.Move = function(dx, dy) entity.InternalMove(dx, dy) end
        entity.EndInteraction = function() entity.SetState(EntityStates.Idle) end

        entity.StartInteraction = function()
            if #entity.Collisions() > 0 then
                local valid = 0

                for _, v in ipairs(entity.Collisions()) do
                    if v.State() ~= EntityStates.Fail then
                        valid = valid + 1
                        v.StartInteraction()
                    end
                end

                if valid ~= 0 then entity.SetState(EntityStates.Action) end
            end
        end

        entity.CollisionEnter = function(other)
            if entity.InternalCollisionEnter(other) then
                if other.Type() == EntityTypes.Enemy then
                    startFailState = true
                    entity.SetState(EntityStates.Fail)
                end
            end
        end

        entity.CollisionExit = function(other)
            if entity.InternalCollisionExit(other) then
                if #entity.Collisions() == 0 then entity.EndInteraction() end
            end
        end

        entity.Update = function(dt)
            local dx, dy = 0, 0

            if entity.State() == EntityStates.Fail then
                if startFailState then
                    startFailTime = startFailTime + dt
                    if startFailTime > failTime then
                        startFailState = false
                        StateMachine.Push(GameStates.FailMenu)
                    end
                end
            else
                if love.keyboard.isDown(InputMap.b) then entity.StartInteraction() end

                if entity.State() ~= EntityStates.Action then
                    if love.keyboard.isDown(InputMap.up) then dy = -speed end
                    if love.keyboard.isDown(InputMap.down) then dy = speed end
                    if love.keyboard.isDown(InputMap.right) then dx = speed entity.SetDirection(1) end
                    if love.keyboard.isDown(InputMap.left) then dx = -speed entity.SetDirection(-1) end

                    if dx ~= 0 or dy ~= 0 then
                        entity.Move(dx, dy)
                        entity.SetState(EntityStates.Moving)

                        local _x = entity.Position()
                        deltaX = _x == screenWidth/2 and dx or 0
                    else
                        entity.SetState(EntityStates.Idle)
                    end
                end
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}