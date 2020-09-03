local NPC = require "src/entities/npc"

return {
    new = function()
        local chasing_player = false
        local half_width = screen_width/2
        local entity = NPC.new(EntityTypes.Enemy)

        local function look_for_player(_x, _y)
            local x, y = entity.Position()
            local p = { x = _x, y = _y }
            local a = { x =  x, y =  y - 80 }
            local b = { x = a.x + (half_width * entity.Direction()), y = a.y + 20 }
            local c = { x = a.x + (half_width * entity.Direction()), y = a.y - 20 }
            --t = { a.x, a.y, b.x, b.y, c.x, c.y }
            return point_in_triangle(p, a, b, c)
        end

        local function check_for_player()
            local _x, _y = PLAYER.Position()
            if look_for_player(_x, _y - 80) and not chasing_player then chasing_player = true end
            if chasing_player then entity.SetDestination(_x, _y) end
        end

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
            check_for_player()
            entity.NPCUpdate(dt)
            if entity.State() == EntityStates.Idle and chasing_player then chasing_player = false end
        end

        return entity
    end
}