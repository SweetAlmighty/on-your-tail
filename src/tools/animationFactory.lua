local SpriteSheet = {
    new = function(image)
        local frames = { }
        local totalFrames = 0

        return {
            GetFrame = function(frame) return frames[frame] end,
            GetProperties = function(frame) return frames[frame].properties end,
            GetFrameDimensions = function(frame) return frames[frame].dimensions end,
            GetProperty = function(frame) return frames[frame].properties[1].Value end,
            SetImageWrap = function(horizontal, vertical) image:setWrap(horizontal, vertical) end,

            AddFrame = function(frame)
                local dim = frame.Dimensions
                totalFrames = totalFrames + 1
                frames[totalFrames] = {
                    dimensions = dims,
                    properties = frame.Properties,
                    quad = love.graphics.newQuad(dim.x, dim.y, dim.w, dim.h, image:getDimensions())
                }
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

local Animation = {
    new = function(image)
        local frames = { }
        local duration = 10
        local frameTime = 0
        local frameCount = 1
        local totalFrames = 0

        return {
            Reset = function() frameCount = 1 end,
            CurrentFrame = function() return frames[frameCount] end,
            Draw = function(x, y, mirror)
                local sx, ox = 1, 0
                if mirror then sx, ox = -1, frames[frameCount].dimensions.w end
                love.graphics.draw(image, frames[frameCount].quad, x, y, 0, sx, 1, ox)
            end,

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
        }
    end
}

AnimationFactory = {
    CreateAnimationSet = function(filename)
        local file = Resources.LoadAnim(filename)
        if file ~= nil then
            local types = { }
            local image = Resources.LoadImage(filename)

            for i = 1, #file.Types do
                local animats = { }

                for j = 1, #file.Types[i].Animations do
                    local anim = Animation.new(image)
                    for k = 1, #file.Types[i].Animations[j].Frames do
                        anim.AddFrameWithData(file.Types[i].Animations[j].Frames[k])
                    end
                    animats[#animats+1] = anim
                end

                types[#types+1] = animats
            end

            return types
        end

        return nil
    end,

    CreateTileSet = function(filename)
        local file = Resources.LoadSheet(filename)
        if file ~= nil then
            local image = Resources.LoadImage(filename)
            local sheet = SpriteSheet.new(image)

            for i = 1, #file.Frames do sheet.AddFrame(file.Frames[i]) end

            return sheet
        end

        return nil
    end
}