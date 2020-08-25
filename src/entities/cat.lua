require 'src/tools/input'
local Entity = require 'src/entities/entity'

return {
    new = function()
        local x, y = 0, 0
        local timeStep = 0
        local destination = nil
        local traveling = false
        local startX, startY = 0, 0
        local entity = Entity.new(2)
        local speed = love.math.random(0.01, 0.09)

        return {
            Update = function(dt)
                x, y = entity.Position()

                if not traveling then
                    traveling = true
                    startX, startY =  x, y
                    destination = { x = love.math.random(0, 320), y = love.math.random(0, 240) }
                else
                    if timeStep >= 1 then
                        timeStep = 0
                        traveling = false
                    else
                        entity.Move(lerp(startX, destination.x, timeStep)-x, lerp(startY, destination.y, timeStep)-y)
                    end

                    timeStep = timeStep + speed
                end

                entity.Update(dt)
            end,
            Draw = function() entity.Draw() end,
            Collider = function() return entity.Collider() end,
            Collisions = function() return entity.Collisions() end,
            CollisionExit = function(other) entity.CollisionExit(other) end,
            CollisionEnter = function(other) entity.CollisionEnter(other) end,
        }
    end
}