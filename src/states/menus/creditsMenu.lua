require "src/states/menus/menu"

CreditsMenu = class("CreditsMenu", Menu)

local pause = { x = 15, y = 85 }
local pet = { x = 45, y = 165 }
local move = { x = 245, y = 112 }
local startPos = { x = 86, y = 96 }
local accept = { x = 10, y = 125 }

function CreditsMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "Credits")

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
    love.graphics.draw(love.graphics.newText(menuFont, "Pause"), pause.x, pause.y)
    love.graphics.draw(love.graphics.newText(menuFont, "Move"), move.x, move.y)
    love.graphics.draw(love.graphics.newText(menuFont, "Pet"), pet.x, pet.y)
    love.graphics.draw(love.graphics.newText(menuFont, "Accept"), accept.x, accept.y)
    love.graphics.setColor(1, 1, 1, 1)
end