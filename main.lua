
require "src/backend/input"
require "src/backend/require"
require "src/backend/resources"
require "src/states/stateMachine"
require "src/backend/animateFactory"

lovesize = require("src/lib/lovesize")

speed = 2
currTime = 0
screenWidth = 320
screenHeight = 240
input = Input:new()
resources = Resources:new()
stateMachine = StateMachine:new()
animateFactory = AnimateFactory:new()
titleFont = resources:LoadFont("KarmaFuture", 50)
menuFont = resources:LoadFont("8bitOperatorPlusSC-Bold", 15)
playableArea = { x = 0, y = 150, width = screenWidth/2, height = screenHeight }

local game = nil
local color = 50/255
local newFilename = "data.txt"
local filename = "highscores.txt"
local defaultScore = { "AAA", 0 }
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

function setResolution(index, fullscreen)
    local value = game.settings.resolution + index

    if value < 1 then
        value = 1
    elseif value > #resolutions then
        value = #resolutions
    end

    if value ~= game.settings.resolution or fullscreen ~= game.settings.fullscreen then
        game.settings.resolution = value
        game.settings.fullscreen = fullscreen

        local resolution = resolutions[game.settings.resolution]
        love.window.setMode(resolution.w, resolution.h, {fullscreen = game.settings.fullscreen})
        lovesize.resize(resolution.w, resolution.h)
    end
end

function setVolume(volume)
    local value = game.settings.volume + volume

    if value < 0 then
        value = 0
    elseif value > 10 then
        value = 10
    end

    if value ~= game.settings.volume then
        love.audio.setVolume(value / 10)
        game.settings.volume = value
    end
end

function setTime(time)
    game.scores[#game.scores+1] = time
    table.sort(game.scores, function(a, b) return a[2] > b[2] end)
    table.remove(game.scores, #game.scores)

    local _, error = love.filesystem.write(newFilename, lume.serialize(game))
    if error ~= nil then print("Save Error: " .. error) end
end

function setSettings(settings)
    game.settings = settings

    local _, error = love.filesystem.write(newFilename, lume.serialize(game))
    if error ~= nil then print("Save Error: " .. error) end
end

function loadSettings()
    if love.filesystem.getInfo(newFilename) then
        local info, message = lume.deserialize(love.filesystem.read(newFilename))
        if message == nil then
            game = info
        else print("Load Error: " .. message) end
    end
end

function getScores()
    return game.scores
end

function getSettings()
    return game.settings
end

function love.load()
    lovesize.set(screenWidth, screenHeight)

    stateMachine:push(States.MainMenu)

    love.math.setRandomSeed(os.time())

    if love.filesystem.getInfo(filename) then
        love.filesystem.remove(filename)
    end

    if love.filesystem.getInfo(newFilename) then
        loadSettings()
    else
        game = { settings = defaultSettings, scores = { } }
        for i=1, 3, 1 do table.insert(game.scores, i, ((i==index) and time or defaultScore)) end
        love.filesystem.write(newFilename, lume.serialize(game))
    end

    love.audio.setVolume(game.settings.volume / 10)

    local resolution = resolutions[game.settings.resolution]
    love.window.setMode(resolution.w, resolution.h, {fullscreen = game.settings.fullscreen})
    lovesize.resize(resolution.w, resolution.h)
end

function love.resize(width, height)
    lovesize.resize(width, height)
end

function love.update(dt)
    local state = stateMachine:current()
    state:update(dt)
    if state.type == States.Gameplay then
        input:process(dt)
     end
end

function love.quit()
    local _, error = love.filesystem.write(newFilename, lume.serialize(game))
    if error ~= nil then print("Save Error: " .. error) end
end

function love.draw()
    love.graphics.clear(color, color, color)
    lovesize.begin()
        stateMachine:draw()
    lovesize.finish()
end
