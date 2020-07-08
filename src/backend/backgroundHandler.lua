BackgroundHandler = class('BackgroundHandler')

local props = { }
local lightPos = 2
local propCount = 9
local totalProps = 9
local buildingCount = 4
local currentProps = { }
local buildingProps = { }
local totalBuildings = 10
local lightOffset = false
local buildingFrames = { }
local currentBuildings = { }

local getNextPosition = function(index)
    local prev = index - 1 < 1 and buildingCount or index - 1
    return currentBuildings[prev].pos + (currentBuildings[prev].width - 20)
end

local getPropPositionOnBuilding = function(building, prop)
    local propWidth = prop.dimensions.w
    local propAreas = building.properties

    for i=1, #propAreas, 1 do
        local area = propAreas[i].Value
        if area.w > propWidth then
            return love.math.random(area.x, (area.x + area.w) - propWidth)
        end
    end

    return nil
end

local initializeBuildings = function()
    local buildingTiles = animateFactory:CreateTileSet("Buildings")

    buildingProps = { }
    buildingFrames = { }
    currentBuildings = { }

    for i=1, totalBuildings, 1 do
        buildingFrames[#buildingFrames+1] = buildingTiles.GetFrame(i)
        if i <= buildingCount then
            buildingProps[#buildingProps+1] = { }
            currentBuildings[#currentBuildings+1] = { }
        end
    end

    return buildingTiles
end

local initializeProps = function()
    local propTiles = animateFactory:CreateTileSet("Props")

    currentProps = { }

    for i=1, totalProps, 1 do
        props[#props+1] = propTiles.GetFrame(i)
        if i <= propCount then currentProps[#currentProps+1] = { } end
    end

    return propTiles
end

local updateBuildings = function()
    for i=1, #currentBuildings, 1 do
        local newX = currentBuildings[i].pos - 2
        local threshold = (currentBuildings[i].width + 1)
        local offscreen = newX < -threshold

        if offscreen then
            -- Change Building
            local index = love.math.random(1, totalBuildings)
            local building = buildingFrames[index]
            currentBuildings[i] = {
                pos = getNextPosition(i),
                type = index,
                width = building.dimensions.w
            }

            -- Change Building Prop
            index = love.math.random(2, 8)
            local prop = props[index]
            local propPos = getPropPositionOnBuilding(building, prop)
            if propPos ~= nil then
                buildingProps[i] = {
                    type = index,
                    width = prop.dimensions.w,
                    pos = currentBuildings[i].pos + getPropPositionOnBuilding(building, prop)
                }
            else
                buildingProps[i] = nil
            end
        else
            currentBuildings[i].pos = newX

            if buildingProps[i] ~= nil then
                buildingProps[i].pos = buildingProps[i].pos - 2
            end
        end
    end
end

local updateLampPost = function()
    if currentProps[1].pos == nil then
        currentProps[1].pos = currentBuildings[2].pos
    end

    if currentProps[1].pos < -(currentProps[1].width + 1) then
        lightOffset = not lightOffset
        lightPos = lightOffset and 4 or 2
    end

    currentProps[1].pos = currentBuildings[lightPos].pos
end

local updateHydrant = function()
    if currentProps[9].pos == nil then
        currentProps[9].pos = currentBuildings[2].pos
    end

    currentProps[9].pos = currentBuildings[1].pos
end

local updateProps = function()
    updateHydrant()
    updateLampPost()
end

local resetBuildings = function()
    for i=1, buildingCount, 1 do
        local index = love.math.random(1, totalBuildings)
        local building = buildingFrames[index]
        currentBuildings[i] = {
            type = index,
            width = building.dimensions.w,
            pos = i == 1 and 0 or getNextPosition(i)
        }
        
        -- Change Building Prop
        index = love.math.random(2, 8)
        local prop = props[index]
        local propPos = getPropPositionOnBuilding(building, prop)
        if propPos ~= nil then
            buildingProps[i] = {
                type = index,
                width = prop.dimensions.w,
                pos = currentBuildings[i].pos + getPropPositionOnBuilding(building, prop)
            }
        else
            buildingProps[i] = nil
        end
    end
end

local resetProps = function()
    for i=1, propCount, 1 do
        local index = i
        local prop = props[index]
        currentProps[i] = {
            pos = nil,
            type = index,
            width = prop.dimensions.w
        }
    end

    updateProps()
end

function BackgroundHandler:initialize()
    self.buildingTiles = initializeBuildings()
    self.propTiles = initializeProps()
    self:reset()
end

function BackgroundHandler:draw()
    for i=1, #currentBuildings, 1 do
        self.buildingTiles.Draw(currentBuildings[i].type, currentBuildings[i].pos, 0)
    end
    
    for i=1, #buildingProps, 1 do
        if buildingProps[i] ~= nil then
            self.propTiles.Draw(buildingProps[i].type, buildingProps[i].pos, 85)
        end
    end

    self.propTiles.Draw(currentProps[1].type, currentProps[1].pos, 12)
    self.propTiles.Draw(currentProps[9].type, currentProps[9].pos, 115)
end

function BackgroundHandler:reset()
    resetBuildings()
    resetProps()
end

function BackgroundHandler:update()
    updateBuildings()
    updateProps()
end
