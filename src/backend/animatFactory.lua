json = require("src/lib/json")
animat = require("src/lib/animat")

AnimatFactory = class('AnimatFactory')

function AnimatFactory:initialize() end

function AnimatFactory:CreateWithCollisions(filename)
    local file = resources:LoadAnim(filename)
    if file ~= nil then
        local types = { }
        local image = resources:LoadImage(filename)

        for i = 1, #file.Types do
            local animats = { }
            local colliders = { }

            for j = 1, #file.Types[i].Animations do
                local anim = animat.newAnimat(10)
                anim:addSheet(image)

                -- Used to keep colliders to one per animation
                local hasColldier = false
                for k = 1, #file.Types[i].Animations[j].Frames do
                    local dimension = file.Types[i].Animations[j].Frames[k].Dimensions
                    anim:addFrame(dimension["x"], dimension["y"], dimension["w"], dimension["h"])

                    for l = 1, #file.Types[i].Animations[j].Frames[k].Properties do
                        local property = file.Types[i].Animations[j].Frames[k].Properties[l]
                        if property.Name == "Collider" and not hasColldier then
                            hasColldier = true
                            colliders[#colliders + 1] = property.Value
                        end
                    end
                end

                animats[#animats + 1] = anim 
            end

            types[#types + 1] = {
                Animations = animats,
                Colliders = colliders
            }
        end

        return types
    end

    return nil
end



function AnimatFactory:create(filename)
    local file = resources:LoadAnim(filename)

    if file ~= nil then
        local animats = {}
        local frames = file["frames"]
        local tags = file["meta"]["frameTags"]
        local image = resources:LoadImage(filename)

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
        local slices = file["meta"]["slices"]
        for i=1, #slices, 1 do
            colliders[#colliders+1] = { [slices[i]["name"]] = slices[i]["keys"][1]["bounds"] }
        end

        animats[#animats+1] = colliders

        return animats
    end
end

function AnimatFactory:createWithFrames(filename, frames)
    local file = resources:LoadAnim(filename)

    if file ~= nil then
        local anim = animat.newAnimat(frameData["frames"][1]["duration"] / 10)
        anim:addSheet(resources:LoadImage(filename))

        for i=1, frames, 1 do
            local frame = frameData["frames"][i]["frame"]
            local x, y, w, h = frame["x"], frame["y"], frame["w"], frame["h"]
            anim:addFrame(x, y, w, h)
        end

        return anim
    end
end

function AnimatFactory:createWithLayer(filename, layerName)
    local file = resources:LoadAnim(filename)

    if file ~= nil then
        local animats = { }
        local currentFrames = { }
        local frames = file["frames"]
        local tags = file["meta"]["frameTags"]
        local image = resources:LoadImage(filename)

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

        local colliders = { }
        local slices = file["meta"]["slices"]
        for i=1, #slices, 1 do
            colliders[#colliders+1] = { [slices[i]["name"]] = slices[i]["keys"][1]["bounds"] }
        end

        animats[#animats+1] = colliders

        return animats
    end
end