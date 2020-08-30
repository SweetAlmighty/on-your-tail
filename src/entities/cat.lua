local NPC = require 'src/entities/npc'

return {
    new = function(type)
        local y = 0
        local pettingLimit = 30
        local entity = NPC.new(type)
        local currentLimit = pettingLimit

        entity.ActionUpdate = function(dt)
            currentLimit = currentLimit - (dt * 10)
            if currentLimit < 0 then
                currentLimit = 0
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