Animation = {
    new = function(image)
        local frames = { }
        local duration = 10
        local frameTime = 0
        local frameCount = 1
        local totalFrames = 0

        return {
            AddFrame = function(x, y, w, h)
                totalFrames = totalFrames + 1
                frames[totalFrames] = {
                    --duration = data.Duration,
                    quad = love.graphics.newQuad(x, y, w, h, image:getDimensions())
                }
            end,

            AddFrameWithData = function(data)
                local offset = data.Offset
                local collider = nil

                for i = 1, #data.Properties do
                    local property = data.Properties[i]

                    if property.Name == 'Collider' and collider == nil then
                        collider = property.Value
                    end
                end

                local dim = data.Dimensions
                totalFrames = totalFrames + 1
                frames[totalFrames] = {
                    offset = offset,
                    dimensions = dim,
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

            Draw = function(transform, mirror)
                love.graphics.draw(image, frames[frameCount].quad, transform)
            end,

            Reset = function()
                frameCount = 1
            end
        }
    end
}