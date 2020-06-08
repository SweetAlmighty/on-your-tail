PropHandler = class('PropHandler')

local props = { }
local propCount = 8
local totalProps = 10
local currentProps = { }

local getNextPosition = function(index)
    local prev = index - 1 < 1 and propCount or index - 1
    return currentProps[prev].pos + currentProps[prev].width
end

function PropHandler:initialize()
    self.propTiles = animateFactory:CreateTileSet("Props")

    for i=1, totalProps, 1 do
        local _, _, w, _ = self.propTiles.GetFrameDimensions(i)
        props[#props+1] = {
            pos = 0,
            type = i,
            width = w
        }

        if i <= propCount then currentProps[#currentProps+1] = { } end
    end

    self:reset()
end

function PropHandler:draw()
    for i=1, #currentProps, 1 do
        self.propTiles.Draw(currentProps[i].type, currentProps[i].pos, 126)
    end
end

function PropHandler:reset()
    for i=1, propCount, 1 do
        local index = love.math.random(1, 10)
        local prop = props[index]
        currentProps[i] = {
            pos = love.math.random(0, screenWidth*2),
            type = index,
            width = prop.width
        }
    end
end

function PropHandler:update()
    for i=1, #currentProps, 1 do
        local newX = currentProps[i].pos - 2
        local threshold = (currentProps[i].width + 1)
        local offscreen = newX < -threshold

        if offscreen then
            -- Change Prop
            local index = love.math.random(1, 10)
            local prop = props[index]
            currentProps[i] = {
                pos = love.math.random(screenWidth, screenWidth*2),
                type = index,
                width = prop.width
            }
        else
            currentProps[i].pos = newX
        end
    end
end
