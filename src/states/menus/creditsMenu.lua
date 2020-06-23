require "src/states/menus/menu"

CreditsMenu = class("CreditsMenu", Menu)

local programmerPosition = { x = 10, y = 80 }
local artistPosition     = { x = 10, y = 120 }
local frameworkPosition  = { x = 10, y = 160 }

local creditsFont

function CreditsMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "Credits")

    creditsFont = love.graphics.newText(menuFont, "\tProgrammer:\tBrian Sweet\n\tArtist:\t\t\t\tShelby Merrill\n\tMade With:\t\t LÖVE\n\tUtilizing:  middleclass, lume\n\t\t\t\t\t\t  lovesize, json.lua")

    self.type = States.CreditsMenu
    self.startHeight = screenHeight - 30
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }
    self.options = { love.graphics.newText(menuFont, "Back") }
end

function CreditsMenu:accept()
    if self.index <= 2 then Menu.accept(self) end
    if self.index == 1 then stateMachine:pop()
    elseif self.index == 2 then stateMachine:clear() end
end

function CreditsMenu:draw()
    Menu.draw(self)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.draw(creditsFont, 0, screenHeight/3.5)
    love.graphics.setColor(1, 1, 1, 1)
end