lume = require("src/lib/lume")

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

function EntityController:update(dt)
    for i=1, #entities, 1 do
        local cols = { }
        for j=1, #entities, 1 do
            if i ~= j then
                if EntityController:CheckCollision(i, j) then cols[#cols+1] = entities[j] end
            end
        end
        entities[i]:handleCollisions(cols)
    end

    for i=1, #entities, 1 do if entities[i] ~= nil then entities[i]:update(dt) end end
end

function EntityController:CheckCollision(colOne, colTwo)
    local x1, y1, w1, h1 = entities[colOne].x, entities[colOne].y, entities[colOne].width, entities[colOne].height
    local x2, y2, w2, h2 = entities[colTwo].x, entities[colTwo].y, entities[colTwo].width, entities[colTwo].height
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function EntityController:CheckCurrentCollisions(entity, collision)
    for i=1, #entity.collisions, 1 do
        if entity.collisions[i] == collision then
            return true
        end
    end

    return false
end

function EntityController:clear()
    for _=1, #entities, 1 do
        entities[#entities] = nil
    end
end

function EntityController:addEntity(entity)
    entities[#entities+1] = entity
end

function EntityController:removeEntity(entity)
    local newEntities = {}
    for i=1, #entities, 1 do
        if entities[i] ~= entity then
            newEntities[#newEntities + 1] = entities[i]
        end
    end
    entities = newEntities
end

function EntityController:initialize() end
function EntityController:count() return #entities end
function EntityController:reset() for i=1, #entities, 1 do entities[i]:reset() end end