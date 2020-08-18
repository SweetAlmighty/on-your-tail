local data = { }
local defaultScores = {
    { "AAA", 0 },
    { "AAA", 0 },
    { "AAA", 0 }
}
local defaultSettings = {
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
local newFilename = "data.txt"
local filename = "highscores.txt"

function initializeData()
    if love.filesystem.getInfo(filename) then
        love.filesystem.remove(filename)
    end

    if love.filesystem.getInfo(newFilename) then
        local info, message = lume.deserialize(love.filesystem.read(newFilename))
        if message == nil then
            data = info
        else print("Load Error: " .. message) end
    else
        data = { settings = defaultSettings, scores = defaultScores }
        love.filesystem.write(newFilename, lume.serialize(data))
    end

    love.audio.setVolume(data.settings.volume / 10)

    local resolution = resolutions[data.settings.resolution]
    love.window.setMode(resolution.w, resolution.h, {fullscreen = data.settings.fullscreen})
    lovesize.resize(resolution.w, resolution.h)
end

function saveData()
    local _, error = love.filesystem.write(newFilename, lume.serialize(data))
    if error ~= nil then print("Save Error: " .. error) end
end

function addScore(score)
    scores[#scores+1] = score
    table.sort(scores, function(a, b) return a[2] > b[2] end)
    table.remove(scores, #scores)
    saveData()
end

function getScores()
    return data.scores
end

function getSettings()
    return data.settings
end

function setVolume(volume)
    local value = math.max(0, math.min(data.settings.volume + volume, 10))

    if value ~= data.settings.volume then
        love.audio.setVolume(value / 10)
        data.settings.volume = value
        return true
    end

    return false
end

function setResolution(index, fullscreen)
    local change = false
    local resolution = resolutions[data.settings.resolution]
    local value = math.max(1, math.min(data.settings.resolution + index, #resolutions))

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
end