require "src/states/menus/menu"

CreditsMenu = class("CreditsMenu", Menu)

local creditsFont

function CreditsMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "CREDITS")

    creditsFont = love.graphics.newText(menuFont, [[
        Programmer: Brian Sweet
        Artist:          Shelby Merrill
        Made With:     LÖVE
        Utilizing:     middleclass, lume
                               lovesize, json.lua
    ]])

    self.type = States.CreditsMenu
    self.startHeight = screenHeight - 30
    self.clearColor = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 }
    Menu.setOptions(self, { "BACK" })
end

function CreditsMenu:accept()
    if self.index <= 2 then Menu.accept(self) end
    if self.index == 1 then stateMachine:pop()
    elseif self.index == 2 then stateMachine:clear() end
end

function CreditsMenu:draw()
    Menu.draw(self)
    love.graphics.draw(creditsFont, 0, screenHeight/3.5)
end