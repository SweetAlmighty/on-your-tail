function findIndex(table, entry)
    for i=1, #table, 1 do if table[i] == entry then return i end end
    return nil
end

function drawDebugInfo(entity)
    local col = entity.Collider()
    love.graphics.rectangle('line', col.x, col.y, col.w, col.h)
end