
require "src/states/menus/menu"
local class = require("src/lib/middleclass")

MainMenu = class("MainMenu", Menu)

function MainMenu:initialize()
    Menu.initialize(self)
    self.type = States.MainMenu
    self.startHeight = screenHeight/2
    self.options = { love.graphics.newText(gameFont, "Play"),
        love.graphics.newText(gameFont, "Scores"),
        love.graphics.newText(gameFont, "Quit") }
    self.clearColor = { r = 1, g = 1, b = 1, a = 1}
    self.title = love.graphics.newImage("/data/title.png")
    self.pointer = love.graphics.newImage("/data/pointer.png")
end

function MainMenu:accept()
    local state = stateMachine:current()
    if state:GetIndex() == 1 then
        stateMachine:push(States.Gameplay)
    elseif state:GetIndex() == 2 then
        stateMachine:push(States.HighscoreMenu)
    else
        love.event.quit()
    end
end

function MainMenu:cleanup() end
function MainMenu:draw() Menu.draw(self) end
