local Player = require 'src/entities/player'

EntityStates = {
    Idle     = 1,
    Moving   = 2,
    Interact = 3,
    Fail     = 4
}

EntityTypes = {
    Player = 1,
    Cat    = 2,
    Kitten = 3,
    Enemy  = 4
}

local entities = { }

-- Logic for the sort function for draw order sorting
local sortFunction = function(a, b)
    if a.entity.y == b.entity.y then
        if a.entity.type == EntityTypes.Player or b.entity.type == EntityTypes.Player then
            return a.entity.type == EntityTypes.Player
        else
            return a.index < b.index
        end
    else return a.entity.y < b.entity.y end
end

-- Sorts the entities by their Y to mock draw order
local sortDrawOrder = function()
    local newTable = { }
    for i=1, #entities, 1 do newTable[#newTable + 1] = { index = i, entity = entities[i] } end
    table.sort(newTable, sortFunction)
    entities = { }
    for i=1, #newTable, 1 do entities[#entities+1] = newTable[i].entity end
end

EntityController = {
    Draw = function()
        sortDrawOrder()
        for i=1, #entities, 1 do entities[i].Draw() end
    end,

    Update = function(dt)
        for i=1, #entities, 1 do
            local cols = { }
            for j=1, #entities, 1 do
                if i ~= j then --and not entities[i].skipCollisions then
                    if EntityController.CheckCollision(i, j) then cols[#cols+1] = entities[j] end
                end
            end
            entities[i].HandleCollisions(cols)
        end

        for i=1, #entities, 1 do if entities[i] ~= nil then entities[i].Update(dt) end end
    end,

    CheckCollision = function(one, two)
        local x1, y1 = entities[one].collider.x, entities[one].collider.y
        local w1, h1 = entities[one].collider.w, entities[one].collider.h
        local x2, y2 = entities[two].collider.x, entities[two].collider.y
        local w2, h2 = entities[two].collider.w, entities[two].collider.h
        return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
    end,

    AddEntity = function(type)
        local entity = nil
        if type == EntityTypes.Player then entity = Player.new() end
        entities[#entities+1] = entity
    end,

    RemoveEntity = function(entity)
        local newEntities = {}
        for i=1, #entities, 1 do
            if entities[i] ~= entity then
                newEntities[#newEntities + 1] = entities[i]
            end
        end
        entities = newEntities
    end,

    Count = function() return #entities end,
    Clear = function() for _=1, #entities, 1 do entities[#entities] = nil end end
}