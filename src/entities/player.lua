require "src/tools/input"
local Entity = require "src/entities/entity"

return {
    new = function()
        local speed = 2
        local fail_time = 1.5
        local start_fail_time = 0
        local start_fail_state = false
        local entity = Entity.new(EntityTypes.Player)

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
                    start_fail_state = true
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
                if start_fail_state then
                    start_fail_time = start_fail_time + dt
                    if start_fail_time > fail_time then
                        start_fail_state = false
                        MenuStateMachine:push(GameMenus.FailMenu)
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
                    else
                        entity.SetState(EntityStates.Idle)
                    end
                end

                local _x = entity.Position()
                moving = (_x == screen_width/2 and dx ~= 0)
            end

            entity.InternalUpdate(dt)
        end

        return entity
    end
}