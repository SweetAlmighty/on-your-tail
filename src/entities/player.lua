require 'src/tools/input'

local newMesh = function()
    segments = segments or 40
	local vertices = {}

	-- The first vertex is at the center, and has a red tint. We're centering the circle around the origin (0, 0).
	table.insert(vertices, {0, 0, 0.5, 0.5, 1, 0, 0})

	-- Create the vertices at the edge of the circle.
	for i=0, segments do
		local angle = (i / segments) * math.pi * 2

		-- Unit-circle.
		local x = math.cos(angle) * 10
		local y = math.sin(angle) * 10

		-- Our position is in the range of [-1, 1] but we want the texture coordinate to be in the range of [0, 1].
		local u = (x + 1) * 0.5
		local v = (y + 1) * 0.5

		-- The per-vertex color defaults to white.
		table.insert(vertices, {x, y, u, v})
	end

	-- The 'fan' draw mode is perfect for our circle.
    return love.graphics.newMesh(vertices, 'fan')
end

return {
    new = function()
        local speed = 2
        local mesh = newMesh()
        local collisions = { }
        local transform = love.math.newTransform(0, 0)
        return {
            Draw = function()
                love.graphics.draw(mesh, transform)
            end,

            Update = function(dt)
                local dx, dy = 0, 0
                if love.keyboard.isDown(InputMap.down) then dy = speed end
                if love.keyboard.isDown(InputMap.right) then dx = speed end
                if love.keyboard.isDown(InputMap.up) then dy = (-speed) end
                if love.keyboard.isDown(InputMap.left) then dx = (-speed) end
                if dx ~= 0 or dy ~= 0 then transform = transform:translate(dx, dy) end
            end,

            CollisionEnter = function()
            end,

            CollisionExit = function()
            end,

            HandleCollisions = function(cols)
                -- Process new collisions
                for i = 1, #cols, 1 do
                    local index = findIndex(collisions, cols[i])
                    if index == nil then
                        CollisionEnter(cols[i])
                        --cols[i].CollisionEnter(self)
                    end
                end

                -- Find collisions to remove
                local remove = {}
                for i = 1, #collisions, 1 do
                    local index = findIndex(cols, collisions[i])
                    if index == nil then
                        remove[#remove + 1] = collisions[i]
                    end
                end

                -- Process collisions that are no longer valid
                for i = 1, #remove, 1 do
                    -- Exit
                    --remove[i]:CollisionExit(self)
                    CollisionExit(remove[i])
                end
            end
        }
    end
}