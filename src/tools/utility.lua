function findIndex(table, entry)
    for i=1, #table, 1 do if table[i] == entry then return i end end
    return nil
end

function drawDebugInfo(entity)
    local col = entity.Collider()
    love.graphics.rectangle('line', col.x, col.y, col.w, col.h)
end

function dist(x1, y1, x2, y2)
    return ((x2-x1)^2+(y2-y1)^2)^0.5
end

--function lerp(a,b,t)
--    return (1-t)*a + t*b
--end

function lerp(a,b,t) return a+(b-a)*t end

function normalize(x,y)
    local l=(x*x+y*y)^.5
    if l==0 then
        return 0,0,0
    else
        return x/l,y/l,l
    end
end