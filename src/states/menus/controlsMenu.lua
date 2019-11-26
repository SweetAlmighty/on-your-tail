
require "src/states/menus/menu"
local class = require("src/lib/middleclass")

ControlsMenu = class("ControlsMenu", Menu)

local isGameshell = love.system.getOS() == "Linux"
local startPos = { x = isGameshell and 80 or 86, y = isGameshell and 64 or 96 }
local pause = { x = isGameshell and 15 or 15, y = isGameshell and 112 or 85 }
local move = { x = isGameshell and 25 or 245, y = isGameshell and 150 or 112 }
local pet = { x = isGameshell and 225 or 45, y = isGameshell and 150 or 165 }
local accept = { x = isGameshell and 225 or 10, y = isGameshell and 180 or 125 }

local pc = love.graphics.newQuad(145, 0, 157, 89, 304, 144)
local gameshell = love.graphics.newQuad(0, 0, 144, 144, 304, 144)

function ControlsMenu:initialize()
    Menu.initialize(self)
    self.type = States.ControlsMenu
    self.startHeight = screenHeight - 30
    Menu.setTitle(self, "Controls")
    self.clearColor = { r = 1, g = 1, b = 1, a = 0.5 }
    self.options = { love.graphics.newText(menuFont, "Back") }
    self.image = love.graphics.newImage("/data/controls.png")
    self.imageQuad = isGameshell and gameshell or pc
end

function ControlsMenu:accept()
    if self.index == 1 then stateMachine:pop()
    elseif self.index == 2 then stateMachine:clear() end
end

function ControlsMenu:cleanup() end
function ControlsMenu:draw()
    Menu.draw(self)
    love.graphics.draw(self.image, self.imageQuad, startPos.x, startPos.y)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.draw(love.graphics.newText(menuFont, "Pause"), pause.x, pause.y)
    love.graphics.draw(love.graphics.newText(menuFont, "Move"), move.x, move.y)
    love.graphics.draw(love.graphics.newText(menuFont, "Pet"), pet.x, pet.y)
    love.graphics.draw(love.graphics.newText(menuFont, "Accept"), accept.x, accept.y)
    love.graphics.setColor(1, 1, 1, 1)
end
