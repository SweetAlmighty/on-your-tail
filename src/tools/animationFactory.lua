local sprite_sheet = {
    new = function(image)
        local frames = { }
        local total_frames = 0

        return {
            GetFrame = function(frame) return frames[frame] end,
            GetProperties = function(frame) return frames[frame].Properties end,
            GetFrameDimensions = function(frame) return frames[frame].dimensions end,
            GetProperty = function(frame) return frames[frame].Properties[1].Value end,
            SetImageWrap = function(horizontal, vertical) image:setWrap(horizontal, vertical) end,

            AddFrame = function(frame)
                local dim = frame.Dimensions
                total_frames = total_frames + 1
                frames[total_frames] = {
                    dimensions = frame.Dimensions,
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
            end
        }
    end
}

local animation = {
    new = function(image)
        local frames = { }
        local duration = 10
        local frame_time = 0
        local frame_count = 1
        local total_frames = 0

        return {
            Reset = function() frame_count = 1 end,
            CurrentFrame = function() return frames[frame_count] end,
            Draw = function(x, y, mirror)
                local frame = frames[frame_count]
                local scale_x = mirror and -1 or 1
                local offset = frame.offset and frame.offset or { x = 0, y = 0 }
                love.graphics.draw(image, frame.quad, x, y, 0, scale_x, 1, offset.x, offset.y)
            end,

            AddFrame = function(x, y, w, h)
                total_frames = total_frames + 1
                frames[total_frames] = {
                    --duration = data.Duration,
                    quad = love.graphics.newQuad(x, y, w, h, image:getDimensions())
                }
            end,

            AddFrameWithData = function(data)
                local offset = data.Offset
                local collider = nil

                for i = 1, #data.Properties do
                    local property = data.Properties[i]

                    if property.Name == "Collider" and collider == nil then
                        collider = property.Value
                    end
                end

                local dim = data.Dimensions
                total_frames = total_frames + 1
                frames[total_frames] = {
                    offset = offset,
                    dimensions = dim,
                    collider = collider,
                    duration = data.Duration,
                    quad = love.graphics.newQuad(dim.x, dim.y, dim.w, dim.h, image:getDimensions())
                }
            end,

            Update = function(dt)
                if frame_time > (1 / duration) then
                    frame_count = frame_count + 1
                    if frame_count > total_frames then
                        frame_count = 1
                        --duration = frames[frame_count].duration
                    end
                    frame_time = frame_time - (1 / duration)
                else
                    frame_time = frame_time + dt
                end
            end
        }
    end
}

AnimationFactory = {
    CreateAnimationSet = function(filename)
        local file = Resources.LoadAnim(filename)
        if file then
            local types = { }
            local image = Resources.LoadImage(filename)

            for i = 1, #file.Types do
                local animats = { }

                for j = 1, #file.Types[i].Animations do
                    local anim = animation.new(image)
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
        if file then
            local image = Resources.LoadImage(filename)
            local sheet = sprite_sheet.new(image)

            for i = 1, #file.Frames do
                sheet.AddFrame(file.Frames[i])
            end

            return sheet
        end

        return nil
    end
}