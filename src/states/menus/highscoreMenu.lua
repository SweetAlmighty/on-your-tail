
require "src/states/menus/menu"
local class = require("src/lib/middleclass")

HighscoreMenu = class("HighscoreMenu", Menu)

function HighscoreMenu:initialize()
    Menu.initialize(self)
    love.graphics.setFont(gameFont)
    self.type = States.HighscoreMenu
    self.startHeight = screenHeight - 30
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }
    self.title = love.graphics.newImage("/data/title.png")
    self.pointer = love.graphics.newImage("/data/pointer.png")
    self.options = { love.graphics.newText(gameFont, "Back") }
    self.currentTime = "Current Record: " .. string.format("%.2f", bestTime)
end

function HighscoreMenu:draw()
    Menu.draw(self)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.currentTime, (screenWidth/2) - 110, screenHeight/2)
end

function HighscoreMenu:accept()
    stateMachine:pop()
end

function HighscoreMenu:cleanup() end
