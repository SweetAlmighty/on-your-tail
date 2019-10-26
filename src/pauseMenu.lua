
require "src/menu"
local class = require("src/lib/middleclass")

PauseMenu = class("PauseMenu", Menu)

function PauseMenu:initialize()
    Menu.initialize(self)
    self.type = States.PauseMenu
    self.startHeight = screenHeight/2
    self.options = { love.graphics.newText(gameFont, "Resume"),
        love.graphics.newText(gameFont, "Main Menu") }
    self.clearColor = { r = 1, g = 1, b = 1, a = 0.5 }
    self.title = love.graphics.newImage("/data/title.png")
    self.pointer = love.graphics.newImage("/data/pointer.png")
end

function PauseMenu:draw() PauseMenu.draw(self) end
function PauseMenu:cleanup() end
