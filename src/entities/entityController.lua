
EntityController = class('EntityController')

local entities = {}

-- Sorts the entities by their Y to mock draw order
local sortDrawOrder = function()
    local newTable = {}
    for i=1, #entities, 1 do newTable[#newTable + 1] = { entities[i]:getY(), entities[i] } end
    table.sort(newTable, function(a,b) return a[1] < b[1] end)
    entities = {}
    for i=1, #newTable, 1 do entities[#entities+1] = newTable[i][2] end
end

function EntityController:draw()
    sortDrawOrder()
    for i=1, #entities, 1 do entities[i]:draw() end
end

function EntityController:addEntity(entity)
    entities[#entities+1] = entity
    World:add(entity, entity.x, entity.y, entity.width, entity.height)
end

function EntityController:clear()
    for _=1, #entities, 1 do
        World:remove(entities[#entities])
        entities[#entities] = nil
    end
end

function EntityController:removeEntity(entity)
    local index = -1
    for i=1, #entities, 1 do
        if index == -1 then
            if entities[i] == entity then index = i end
        end
    end

    if index ~= -1 then
        entity = nil
        index = index - 1
        entities[index] = nil
    end
end

function EntityController:initialize() end
function EntityController:count() return #entities end
function EntityController:reset() for i=1, #entities, 1 do entities[i]:reset() end end
function EntityController:update(dt) for i=1, #entities, 1 do entities[i]:update(dt) end end