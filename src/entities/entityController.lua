local Cat = require 'src/entities/cat'
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

local checkCollision = function(one, two)
    local colOne = entities[one].Collider()
    local colTwo = entities[two].Collider()
    return colOne.x < colTwo.x + colTwo.w and
           colTwo.x < colOne.x + colOne.w and
           colOne.y < colTwo.y + colTwo.h and
           colTwo.y < colOne.y + colOne.h
end

local handleCollisions = function(entity, collisions)
    local entityCollisions = entity.Collisions()

    -- Process new collisions
    for i=1, #collisions, 1 do
        local index = findIndex(entityCollisions, collisions[i])
        if index == nil then
            -- Enter
            collisions[i].CollisionEnter(entity)
            entity.CollisionEnter(collisions[i])
        end
    end

    -- Find collisions to remove
    local remove = {}
    for i=1, #entityCollisions, 1 do
        local index = findIndex(collisions, entityCollisions[i])
        if index == nil then
            remove[#remove + 1] = entityCollisions[i]
        end
    end

    -- Process collisions that are no longer valid
    for i=1, #remove, 1 do
        -- Exit
        remove[i].CollisionExit(entity)
        entity.CollisionExit(remove[i])
    end
end

local checkCollisions = function()
    for i=1, #entities, 1 do
        local collisions = { }
        for j=1, #entities, 1 do
            if i ~= j then
                if checkCollision(i, j) then
                    collisions[#collisions+1] = entities[j]
                end
            end
        end
        handleCollisions(entities[i], collisions)
    end
end

EntityController = {
    Draw = function()
        sortDrawOrder()
        for i=1, #entities, 1 do entities[i].Draw() end
        --drawDebugInfo(entities[1])
    end,

    Update = function(dt)
        checkCollisions()
        for i=1, #entities, 1 do if entities[i] ~= nil then entities[i].Update(dt) end end
    end,

    AddEntity = function(type)
        local entity = nil
        if type == EntityTypes.Player then entity = Player.new()
        elseif type == EntityTypes.Cat then entity = Cat.new() end
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