require "src/states/menus/menu"

OptionsMenu = class("OptionsMenu", Menu)

local playSound = false
local fullscreen = false
local volumeFont, resolutionFont, fullscreenFont

local setText = function()
    local settings = getSettings()
    fullscreen = settings.fullscreen
    volumeFont = love.graphics.newText(menuFont, settings.volume)
    resolutionFont = love.graphics.newText(menuFont, settings.resolution)
    fullscreenFont = love.graphics.newText(menuFont, settings.fullscreen and "[X]" or "[ ]")
end

local setVolumeSetting = function(value)
    playSound = setVolume(value)
    setText()
end

local setResolutionSetting = function(value)
    playSound = setResolution(value, fullscreen)
    setText()
end

function OptionsMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "OPTIONS")

    setText()

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
        fullscreen = not fullscreen
        setResolutionSetting(0);
    elseif self.index == 4 then
        Menu.accept(self)
        saveData()
        stateMachine:pop()
    end
end

function OptionsMenu:draw()
    Menu.draw(self)
    love.graphics.draw(volumeFont, 225, self:optionHeight(1))
    love.graphics.draw(resolutionFont, 225, self:optionHeight(2))
    love.graphics.draw(fullscreenFont, 225, self:optionHeight(3))
end