json = require("src/lib/json")
animat = require("src/lib/animat")

AnimatFactory = class('AnimatFactory')

function AnimatFactory:initialize() end

function AnimatFactory:create(filename)
    local file = "/data/" .. filename .. ".json"

    if love.filesystem.getInfo(file) then
        local frameData = json.decode(love.filesystem.read(file))

        if frameData == nil then
            print("Load Error: Frame Data is null")
            return nil
        end

        local animats = {}
        local frames = frameData["frames"]
        local tags = frameData["meta"]["frameTags"]
        local image = love.graphics.newImage("/data/" .. filename .. ".png")

        for i=1, #tags, 1 do
            local from, to = tags[i]["from"]+1, tags[i]["to"]+1
            local a = animat.newAnimat(frames[1]["duration"] / 10)
            a:addSheet(image)

            for j=from, to, 1 do
                local frame = frames[j]["frame"]
                local x, y, w, h = frame["x"], frame["y"], frame["w"], frame["h"]
                a:addFrame(x, y, w, h)
            end

            animats[#animats+1] = a
        end

        local colliders = { }
        local slices = frameData["meta"]["slices"]
        for i=1, #slices, 1 do
            colliders[#colliders+1] = { [slices[i]["name"]] = slices[i]["keys"][1]["bounds"] }
        end

        animats[#animats+1] = colliders 

        return animats
    end
end

function AnimatFactory:createWithFrames(filename, frames)
    local file = "/data/" .. filename .. ".json"

    if love.filesystem.getInfo(file) then
        local frameData = json.decode(love.filesystem.read(file))

        if frameData == nil then
            print("Load Error: Frame Data is null")
            return nil
        end

        local anim = animat.newAnimat(frameData["frames"][1]["duration"] / 10)
        anim:addSheet(love.graphics.newImage("/data/" .. filename .. ".png"))

        for i=1, frames, 1 do
            local frame = frameData["frames"][i]["frame"]
            local x, y, w, h = frame["x"], frame["y"], frame["w"], frame["h"]
            anim:addFrame(x, y, w, h)
        end

        return anim
    end
end

function AnimatFactory:createWithLayer(filename, layerName)
    local file = "/data/" .. filename .. ".json"

    if love.filesystem.getInfo(file) then
        local frameData = json.decode(love.filesystem.read(file))

        if frameData == nil then
            print("Load Error: Frame Data is null")
            return nil
        end

        local animats = { }
        local currentFrames = { }
        local frames = frameData["frames"]
        local tags = frameData["meta"]["frameTags"]
        local image = love.graphics.newImage("/data/" .. filename .. ".png")

        -- Loop through all available frames
        for i=1, #frames, 1 do
            local name = frames[i]["filename"]
            if string.find(name, layerName) then
                -- Loop through all available tags
                for j=1, #tags, 1 do
                    if string.find(name, tags[j]["name"]) then
                        currentFrames[#currentFrames+1] = frames[i]
                    end
                end
            end
        end

        for i=1, #tags, 1 do
            -- Frame tags contain indices for the animation the tag represents
            -- Indices are zero-based, while lua tables are one-based
            local from, to = tags[i]["from"]+1, tags[i]["to"]+1
            local a = animat.newAnimat(currentFrames[1]["duration"] / 10)
            a:addSheet(image)

            for j=from, to, 1 do
                local frame = currentFrames[j]["frame"]
                local x, y, w, h = frame["x"], frame["y"], frame["w"], frame["h"]
                a:addFrame(x, y, w, h)
            end

            animats[#animats+1] = a
        end

        return animats
    end
end