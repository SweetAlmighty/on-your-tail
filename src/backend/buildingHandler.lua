BuildingHandler = class('BuildingHandler')

local buildings = { }
local buildingCount = 4
local currentBuildings = { }

local getNextPosition = function(index)
    local prev = index - 1 < 1 and buildingCount or index - 1
    return currentBuildings[prev].pos + currentBuildings[prev].width
end

function BuildingHandler:initialize()
    self.buildingTiles = animateFactory:CreateTileSet("Buildings")
    
    for i=1, 11, 1 do
        local _, _, w, _ = self.buildingTiles.GetFrameDimensions(i)
        buildings[#buildings+1] = {
            pos = 0,
            type = i,
            width = w
        }

        if i <= buildingCount then currentBuildings[#currentBuildings+1] = { } end
    end

    self:reset()
end

function BuildingHandler:draw()
    for i=1, #currentBuildings, 1 do
        self.buildingTiles.Draw(currentBuildings[i].type, currentBuildings[i].pos, 0)
    end
end

function BuildingHandler:reset()
    for i=1, buildingCount, 1 do
        local index = love.math.random(1, 11)
        local building = buildings[index]
        currentBuildings[i] = {
            pos = i == 1 and 0 or getNextPosition(i),
            type = index,
            width = building.width
        }
    end
end

function BuildingHandler:update()
    for i=1, #currentBuildings, 1 do
        local newX = currentBuildings[i].pos - 2
        local threshold = (currentBuildings[i].width + 1)
        local offscreen = newX < -threshold
        
        if offscreen then
            -- Change Building
            local index = love.math.random(1, 11)
            local building = buildings[index]
            currentBuildings[i] = {
                pos = getNextPosition(i),
                type = index,
                width = building.width
            }
        else
            currentBuildings[i].pos = newX
        end
    end
end
