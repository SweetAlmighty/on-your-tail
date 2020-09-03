local data = { }
local default_scores = {
    { "AAA", 0 },
    { "AAA", 0 },
    { "AAA", 0 }
}
local default_settings = {
    volume = 5,
    resolution = 1,
    fullscreen = false
}
local resolutions = {
    { w = 320, h = 240 },
    { w = 640, h = 480 },
    { w = 800, h = 600 },
    { w = 1024, h = 768 },
    { w = 1280, h = 960 }
}
local new_filename = "data.txt"
local filename = "highscores.txt"

Data = {
    Initialize = function()
        if love.filesystem.getInfo(filename) then love.filesystem.remove(filename) end

        if love.filesystem.getInfo(new_filename) then
            local info, message = lume.deserialize(love.filesystem.read(new_filename))
            if message == nil then
                data = info
            else print("Load Error: " .. message) end
        else
            data = { settings = default_settings, scores = default_scores }
            love.filesystem.write(new_filename, lume.serialize(data))
        end

        love.audio.setVolume(data.settings.volume / 10)

        local resolution = resolutions[data.settings.resolution]
        love.window.setMode(resolution.w, resolution.h, {fullscreen = data.settings.fullscreen})
        lovesize.resize(resolution.w, resolution.h)
    end,

    Save = function()
        local _, error = love.filesystem.write(new_filename, lume.serialize(data))
        if error then print("Save Error: " .. error) end
    end,

    AddScore = function(score)
        scores[#scores+1] = score
        table.sort(scores, function(a, b) return a[2] > b[2] end)
        table.remove(scores, #scores)
        Data.Save()
    end,

    SetVolume = function(volume)
        local value = lume.clamp(data.settings.resolution + volume, 1, 10)

        if value ~= data.settings.volume then
            love.audio.setVolume(value / 10)
            data.settings.volume = value
            return true
        end

        return false
    end,

    SetResolution = function(index, fullscreen)
        local change = false
        local resolution = resolutions[data.settings.resolution]
        local value = lume.clamp(data.settings.resolution + index, 1, #resolutions)

        if fullscreen ~= data.settings.fullscreen then
            change = true
            data.settings.fullscreen = fullscreen
        end

        if value ~= data.settings.resolution then
            change = true
            data.settings.resolution = value
            resolution = resolutions[data.settings.resolution]
        end

        if change then
            love.window.setMode(resolution.w, resolution.h, { fullscreen = data.settings.fullscreen })
            lovesize.resize(resolution.w, resolution.h)
            return true
        end

        return false
    end,

    GetScores = function() return data.scores end,
    GetSettings = function() return data.settings end
}