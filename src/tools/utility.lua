function find_index(table, entry)
    for i=1, #table, 1 do if table[i] == entry then return i end end
    return nil
end

local function sign(p, a, b)
    return lume.sign((b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x))
end

function point_in_triangle(p, p0, p1, p2)
    local d1 = sign(p, p0, p1)
    local d2 = sign(p, p1, p2)
    local d3 = sign(p, p2, p0)
    return ((d1 == d2) and (d2 == d3))
end

function draw_path_info(entity)
    love.graphics.line(entity.position.x, entity.position.y, entity.destination.x, entity.destination.y)

    love.graphics.setColor(0, 1, 0)
    love.graphics.points(entity.position.x, entity.position.y)

    love.graphics.setColor(1, 0, 0)
    love.graphics.points(entity.destination.x, entity.destination.y)

    love.graphics.setColor(1, 1, 1)
end

function draw_debug_info(entity)
    local col = entity:collider()
    local pos = entity.position

    local color = #entity.collisions == 0 and {1, 1, 1} or {1, 0, 0}

    love.graphics.setColor(color[1], color[2], color[3])
    love.graphics.rectangle("line", col.x, col.y, col.w, col.h)

    love.graphics.setColor(0, 0, 0)
    love.graphics.points(pos.x, pos.y)

    love.graphics.setColor(1, 1, 1)
end