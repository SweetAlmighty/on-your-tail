
require "src/states/menus/menu"

PauseMenu = class("PauseMenu", Menu)

function PauseMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "Pause")

    self.type = States.PauseMenu
    self.startHeight = screenHeight/2
    self.clearColor = { r = 1, g = 1, b = 1, a = 0.8 }
    self.options = {
        love.graphics.newText(menuFont, "Resume"),
        love.graphics.newText(menuFont, "Main Menu")
    }
end

function PauseMenu:accept()
    if self.index <= 2 then Menu.accept(self) end
    if self.index == 1 then stateMachine:pop()
    elseif self.index == 2 then stateMachine:clear() end
end

function PauseMenu:draw() Menu.draw(self) end
