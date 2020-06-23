require "src/states/menus/menu"

OptionsMenu = class("OptionsMenu", Menu)

local volume = 10
local resolutionIndex = 1
local isFullscreen = false

local resolutions = {
    { w = 320, h = 240 },
    { w = 640, h = 480 },
    { w = 800, h = 600 },
    { w = 1024, h = 768 },
    { w = 1280, h = 960 }
}

local volumePosition = { x = 225, y = 80 }
local resolutionPosition = { x = 225, y = 120 }
local fullscreenPosition = { x = 225, y = 160 }

local volumeFont, resolutionFont, fullscreenFont

local setVolume = function(value)
    volume = volume + value
    love.audio.setVolume(volume / 10)
    volumeFont = love.graphics.newText(menuFont, volume)
end

local setResolution = function(value)
    if value ~= 0 then
        resolutionIndex = resolutionIndex + value
        local res = resolutions[resolutionIndex];
        love.window.setMode(res.w, res.h, { fullscreen = isFullscreen })
        lovesize.resize(res.w, res.h)
    end
    resolutionFont = love.graphics.newText(menuFont, resolutions[resolutionIndex].w)
    fullscreenFont = love.graphics.newText(menuFont, isFullscreen and "[X]" or "[ ]")
end

function OptionsMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "Extras")
    
    setVolume(0)
    setResolution(0)

    self.type = States.OptionsMenu
    self.startHeight = screenHeight/3
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }
    self.options = {
        love.graphics.newText(menuFont, "Volume: "),
        love.graphics.newText(menuFont, "Resolution: "),
        love.graphics.newText(menuFont, "Fullscreen: "),
        love.graphics.newText(menuFont, "Back")
    }
end

function OptionsMenu:left()
    if self.index == 1 then
        if volume > 0 then setVolume(-1) end
    elseif self.index == 2 then
        if resolutionIndex > 1 then setResolution(-1) end
    end
end

function OptionsMenu:right()
    if self.index == 1 then
        if volume < 10 then setVolume(1) end
    elseif self.index == 2 then
        if resolutionIndex < #resolutions then setResolution(1) end
    end
end

function OptionsMenu:accept()
    if self.index == 3 then
        isFullscreen = not isFullscreen
        setResolution(0);
    elseif self.index == 4 then
        Menu.accept(self)
        stateMachine:pop()
    end 
end

function OptionsMenu:draw()
    Menu.draw(self)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.draw(volumeFont, volumePosition.x, volumePosition.y)
    love.graphics.draw(resolutionFont, resolutionPosition.x, resolutionPosition.y)
    love.graphics.draw(fullscreenFont, fullscreenPosition.x, fullscreenPosition.y)
    love.graphics.setColor(1, 1, 1, 1)
end