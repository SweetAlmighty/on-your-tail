
require "src/menu"
local class = require("src/lib/middleclass")

MainMenu = class("MainMenu", Menu)

function MainMenu:initialize()
    Menu.initialize(self)
    self.type = States.MainMenu
    self.startHeight = screenHeight/2
    self.options = { love.graphics.newText(gameFont, "Play"),
        love.graphics.newText(gameFont, "Quit") }
    self.clearColor = { r = 1, g = 1, b = 1, a = 1}
    self.title = love.graphics.newImage("/data/title.png")
    self.pointer = love.graphics.newImage("/data/pointer.png")
end

function MainMenu:draw() Menu.draw(self) end
function MainMenu:cleanup() end
