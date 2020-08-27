function findIndex(table, entry)
    for i=1, #table, 1 do if table[i] == entry then return i end end
    return nil
end

function drawDebugInfo(entity)
    local col = entity.Collider()
    local color = #entity.Collisions() == 0 and {1, 1, 1} or {1, 0, 0}

    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle('line', col.x, col.y, col.w, col.h)
    love.graphics.setColor(1, 1, 1)
end