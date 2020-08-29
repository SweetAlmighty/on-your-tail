--t = nil
--po = false

--local color = po and { 1, 0, 0 } or { 1, 1, 1 }
--love.graphics.setColor(color[1], color[2], color[3])
--love.graphics.polygon('line', t)
--love.graphics.setColor(1, 1, 1)

--t = { a.x, a.y, b.x, b.y, c.x, c.y }

function findIndex(table, entry)
    for i=1, #table, 1 do if table[i] == entry then return i end end
    return nil
end

local sign = function(p, a, b)
    return lume.sign((b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x))
end

function pointInTriangle(p, p0, p1, p2)
    local d1 = sign(p, p0, p1)
    local d2 = sign(p, p1, p2)
    local d3 = sign(p, p2, p0)
    return ((d1 == d2) and (d2 == d3))
end

function drawDebugInfo(entity)
    local col = entity.Collider()
    local x, y = entity.Position()

    love.graphics.points(x, y)

    local color = #entity.Collisions() == 0 and {1, 1, 1} or {1, 0, 0}

    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle('line', col.x, col.y, col.w, col.h)
    love.graphics.setColor(1, 1, 1)
end