
function collider(entity)
    return entity.position.x, entity.position.y, entity.viewport.w, entity.viewport.h
end

function checkCollision(one, two)
    local x1, y1, w1, h1 = collider(entities[one])
    local x2, y2, w2, h2 = collider(entities[two])
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function checkCollisions()  
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

function handleCollisions(entity, collisions)
    -- Process new collisions
    for i=1, #collisions, 1 do
        local index = findIndex(entity.collisions, collisions[i])
        if index == nil then
            -- Enter
            collisionEnter()
            entity.enterCollision(collisions[i])
        end
    end

    -- Find collisions to remove
    local remove = {}
    for i=1, #entity.collisions, 1 do
        local index = findIndex(collisions, entity.collisions[i])
        if index == nil then
            remove[#remove + 1] = entity.collisions[i]
        end
    end

    -- Process collisions that are no longer valid
    for i=1, #remove, 1 do
        -- Exit
        collisionExit()
        entity.exitCollision(i)
    end
end

function collisionEnter()
    --print("Enter")
end

function collisionExit()
    --print("Exit")
end