require "src/states/menus/menu"

OptionsMenu = class("OptionsMenu", Menu)

local settings = { }
local playSound = false
local volumePosition = { x = 225, y = 80 }
local resolutionPosition = { x = 225, y = 120 }
local fullscreenPosition = { x = 225, y = 160 }

local volumeFont, resolutionFont, fullscreenFont

local setVolumeSetting = function(value)
    local volume = settings.volume
    setVolume(value)
    volumeFont = love.graphics.newText(menuFont, settings.volume)
    settings = getSettings()
    playSound = volume ~= settings.volume
end

local setResolutionSetting = function(value)
    local resolution = settings.resolution
    setResolution(value, settings.fullscreen)
    resolutionFont = love.graphics.newText(menuFont, settings.resolution)
    fullscreenFont = love.graphics.newText(menuFont, settings.fullscreen and "[X]" or "[ ]")
    settings = getSettings()
    playSound = resolution ~= settings.resolution
end

function OptionsMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "OPTIONS")
    settings = getSettings()

    volumeFont = love.graphics.newText(menuFont, settings.volume)
    resolutionFont = love.graphics.newText(menuFont, settings.resolution)
    fullscreenFont = love.graphics.newText(menuFont, settings.fullscreen and "[X]" or "[ ]")

    self.type = States.OptionsMenu
    self.startHeight = screenHeight/1.75
    self.clearColor = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 }
    Menu.setOptions(self, { "VOLUME:", "RESOLUTION:", "FULLSCREEN:", "BACK" })
end

function OptionsMenu:left()
    if self.index == 1 then
        setVolumeSetting(-1)
    elseif self.index == 2 then
        setResolutionSetting(-1)
    end

    if self.index ~= 3 and playSound then
        Menu.left(self)
        playSound = false
    end
end

function OptionsMenu:right()
    if self.index == 1 then
        setVolumeSetting(1)
    elseif self.index == 2 then
        setResolutionSetting(1)
    end

    if self.index ~= 3 and playSound then
        Menu.right(self)
        playSound = false
    end
end

function OptionsMenu:accept()
    if self.index == 3 then
        settings.fullscreen = not settings.fullscreen
        print(settings.fullscreen)
        setResolutionSetting(0);
    elseif self.index == 4 then
        Menu.accept(self)
        setSettings(settings)
        stateMachine:pop()
    end
end

function OptionsMenu:draw()
    Menu.draw(self)
    love.graphics.draw(volumeFont, volumePosition.x, self:optionHeight(1))
    love.graphics.draw(resolutionFont, resolutionPosition.x, self:optionHeight(2))
    love.graphics.draw(fullscreenFont, fullscreenPosition.x, self:optionHeight(3))
end