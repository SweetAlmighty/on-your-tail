local NPC = require 'src/entities/npc'

return {
    new = function()
        local chasingPlayer = false
        local halfWidth = screenWidth/2
        local entity = NPC.new(EntityTypes.Enemy)

        local lookForPlayer = function(_x, _y)
            local x, y = entity.Position()
            local p = { x = _x, y = _y }
            local a = { x =  x, y =  y - 80 }
            local b = { x = a.x + (halfWidth * entity.Direction()), y = a.y + 20 }
            local c = { x = a.x + (halfWidth * entity.Direction()), y = a.y - 20 }
            --t = { a.x, a.y, b.x, b.y, c.x, c.y }
            return pointInTriangle(p, a, b, c)
        end

        local checkForPlayer = function()
            local _x, _y = PLAYER.Position()
            if lookForPlayer(_x, _y - 80) and not chasingPlayer then chasingPlayer = true end
            if chasingPlayer then entity.SetDestination(_x, _y) end
        end

        entity.SetPosition(200, 200)
        entity.Type = function() return EntityTypes.Enemy end
        entity.CollisionExit = function(other) entity.InternalCollisionExit(other) end

        entity.CollisionEnter = function(other)
            if entity.InternalCollisionEnter(other) then
                if other.Type() == EntityTypes.Player then
                    entity.StartInteraction()
                end
            end
        end

        entity.Update = function(dt)
            checkForPlayer()
            entity.NPCUpdate(dt)
            if entity.State() == EntityStates.Idle and chasingPlayer then chasingPlayer = false end
        end

        return entity
    end
}