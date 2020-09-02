local NPC = require "src/entities/npc"

return {
    new = function(type)
        local y = 0
        local petting_limit = 30
        local entity = NPC.new(type)
        local current_limit = petting_limit

        entity.ActionUpdate = function(dt)
            current_limit = current_limit - (dt * 10)
            if current_limit < 0 then
                current_limit = 0
                entity.SetDestination(-100, y)
                entity.SetState(EntityStates.Fail)
            end
        end

        entity.Type = function() return EntityTypes.Cat end
        entity.Update = function(dt) entity.NPCUpdate(dt) end
        entity.CollisionEnter = function(other) entity.InternalCollisionEnter(other) end

        return entity
    end
}