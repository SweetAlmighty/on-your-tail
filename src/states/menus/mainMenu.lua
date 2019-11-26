
require "src/states/menus/menu"
local class = require("src/lib/middleclass")

MainMenu = class("MainMenu", Menu)

function MainMenu:initialize()
    Menu.initialize(self)
    self.type = States.MainMenu
    self.startHeight = screenHeight/3
    Menu.setTitle(self, "On Your Tail")
    self.clearColor = { r = 1, g = 1, b = 1, a = 1}
    self.options = { love.graphics.newText(menuFont, "Play"),
                     love.graphics.newText(menuFont, "Scores"),
                     love.graphics.newText(menuFont, "Controls"),
                     love.graphics.newText(menuFont, "Quit") }
end

function MainMenu:accept()
    if self.index == 1 then
        stateMachine:push(States.Gameplay)
    elseif self.index == 2 then
        stateMachine:push(States.HighscoreMenu)
    elseif self.index == 3 then
        stateMachine:push(States.ControlsMenu)
    else
        love.event.quit()
    end
end

function MainMenu:cleanup() end
function MainMenu:draw() Menu.draw(self) end
