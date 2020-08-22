Spritesheet = {
    new = function(image)
        local frames = { }
        local totalFrames = 0

        return {
            AddFrame = function(frame)
                totalFrames = totalFrames + 1
                frames[totalFrames] = {
                    properties = frame.Properties,
                    dimensions = frame.Dimensions,
                    quad = love.graphics.newQuad(
                        frame.Dimensions.x,
                        frame.Dimensions.y,
                        frame.Dimensions.w,
                        frame.Dimensions.h,
                        image:getDimensions())
                }
            end,

            GetFrame = function(frame)
                return frames[frame]
            end,

            GetProperty = function(frame)
                return frames[frame].properties[1].Value
            end,

            GetProperties = function(frame)
                return frames[frame].properties
            end,

            GetFrameDimensions = function(frame)
                return frames[frame].dimensions
            end,

            SetImageWrap = function(horizontal, vertical)
                image:setWrap(horizontal, vertical)
            end,

            Draw = function(frame, x, y)
                local offset = { x = 0, y = 0 }
                love.graphics.draw(image, frames[frame].quad, x, y, 0, 1, 1, offset.x, offset.y)
            end,

            DrawScroll = function(frame, x, y, pos)
                local dims = frames[frame].dimensions
                frames[frame].quad = love.graphics.newQuad(-pos, dims.y, dims.w, dims.h, image:getDimensions())
                love.graphics.draw(image, frames[frame].quad, x, y, 0)
            end,
        }
    end
}