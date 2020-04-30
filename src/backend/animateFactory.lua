AnimateFactory = class('AnimateFactory')

function AnimateFactory:initialize() end

local createAnimation = function (image)
    local frames = {}
    local duration = 10
    local frameTime = 0
    local frameCount = 1
    local totalFrames = 0

    return {
        AddFrame = function(x, y, w, h)
            totalFrames = totalFrames + 1
            frames[totalFrames] = {
                duration = data.Duration,
                quad = love.graphics.newQuad(x, y, w, h, image:getDimensions())
            }
        end,

        AddFrameWithData = function(data)
            local origin = nil
            local collider = nil

            for i = 1, #data.Properties do
                local property = data.Properties[i]

                if property.Name == "Collider" and collider == nil then
                    collider = property.Value
                elseif property.Name == "Origin" and origin == nil then
                    origin = property.Value
                end
            end

            local dim = data.Dimensions
            totalFrames = totalFrames + 1
            frames[totalFrames] = {
                origin = origin,
                dimension = dim,
                collider = collider,
                duration = data.Duration,
                quad = love.graphics.newQuad(dim.x, dim.y, dim.w, dim.h, image:getDimensions())
            }
        end,

        CurrentFrame = function()
            return frames[frameCount]
        end,

        Update = function(dt)
            if frameTime > (1 / duration) then
                frameCount = frameCount + 1
                if frameCount > totalFrames then
                    frameCount = 1
                    --duration = frames[frameCount].duration
                end
                frameTime = frameTime - (1 / duration)
            else
                frameTime = frameTime + dt
            end
        end,

        Draw = function(x, y, mirror)
            local offset = { x = 0, y = 0 }

            if frames[frameCount].origin ~= nil then
                offset = frames[frameCount].origin
            end

            if mirror then
                local _, _, w, _ = frames[frameCount].quad:getViewport()
                offset.x = w - offset.x
            end

            local xScale = mirror and -1 or 1
            love.graphics.draw(image, frames[frameCount].quad, x, y, 0, xScale, 1, offset.x, offset.y)
        end,

        Reset = function()
            frameCount = 1
        end
    }
end

function AnimateFactory:CreateAnimationSet(filename)
    local file = resources:LoadAnim(filename)
    if file ~= nil then
        local types = { }
        local image = resources:LoadImage(filename)

        for i = 1, #file.Types do
            local animats = { }

            for j = 1, #file.Types[i].Animations do
                local anim = createAnimation(image)
                for k = 1, #file.Types[i].Animations[j].Frames do
                    anim.AddFrameWithData(file.Types[i].Animations[j].Frames[k])
                end
                animats[#animats + 1] = anim 
            end

            types[#types + 1] = animats
        end

        return types
    end

    return nil
end