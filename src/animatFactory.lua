lume = require("src/lib/lume")
json = require("src/lib/json")
animat = require("src/lib/animat")

AnimatFactory = class('AnimatFactory')

function AnimatFactory:initialize() end

function AnimatFactory:create(filename, frames)
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