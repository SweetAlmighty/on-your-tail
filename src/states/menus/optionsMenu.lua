require "src/states/menus/menu"

OptionsMenu = class("OptionsMenu", Menu)

local settings = { }

local volumePosition = { x = 225, y = 80 }
local resolutionPosition = { x = 225, y = 120 }
local fullscreenPosition = { x = 225, y = 160 }

local volumeFont, resolutionFont, fullscreenFont

local setVolumeSetting = function(value)
    setVolume(value)
    volumeFont = love.graphics.newText(menuFont, settings.volume)
end

local setResolutionSetting = function(value)
    setResolution(value, settings.fullscreen)
    resolutionFont = love.graphics.newText(menuFont, settings.resolution)
    fullscreenFont = love.graphics.newText(menuFont, settings.fullscreen and "[X]" or "[ ]")
end

function OptionsMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "Extras")
    
    settings = getSettings()

    volumeFont = love.graphics.newText(menuFont, settings.volume)
    resolutionFont = love.graphics.newText(menuFont, settings.resolution)
    fullscreenFont = love.graphics.newText(menuFont, settings.fullscreen and "[X]" or "[ ]")

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
        setVolumeSetting(-1)
    elseif self.index == 2 then
        setResolutionSetting(-1)
    end
    
    if self.index ~= 3 then
        Menu.left(self)
    end
end

function OptionsMenu:right()
    if self.index == 1 then
        setVolumeSetting(1)
    elseif self.index == 2 then
        setResolutionSetting(1)
    end

    if self.index ~= 3 then
        Menu.right(self)
    end
end

function OptionsMenu:accept()
    if self.index == 3 then
        settings.fullscreen = not settings.fullscreen
        setResolutionSetting(0);
    elseif self.index == 4 then
        Menu.accept(self)
        setSettings(settings)
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