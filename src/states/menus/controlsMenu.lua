require "src/states/menus/menu"

ControlsMenu = class("ControlsMenu", Menu)

local isGameshell = love.system.getOS() == "Linux"
local pause = { x = isGameshell and 15 or 15, y = isGameshell and 112 or 85 }
local pet = { x = isGameshell and 225 or 45, y = isGameshell and 150 or 165 }
local move = { x = isGameshell and 25 or 245, y = isGameshell and 150 or 112 }
local startPos = { x = isGameshell and 80 or 86, y = isGameshell and 64 or 96 }
local accept = { x = isGameshell and 225 or 10, y = isGameshell and 180 or 125 }

local pc = love.graphics.newQuad(145, 0, 157, 89, 304, 144)
local gameshell = love.graphics.newQuad(0, 0, 144, 144, 304, 144)

function ControlsMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "CONTROLS")

    self.type = States.ControlsMenu
    self.startHeight = screenHeight - 30
    self.quad = isGameshell and gameshell or pc
    self.image = resources:LoadImage("controls")
    self.clearColor = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 }

    Menu.setOptions(self, { "BACK" })
end

function ControlsMenu:accept()
    Menu.accept(self)
    stateMachine:pop()
end

function ControlsMenu:draw()
    Menu.draw(self)
    love.graphics.draw(self.image, self.quad, startPos.x, startPos.y)
    love.graphics.draw(love.graphics.newText(menuFont, "PAUSE"), pause.x, pause.y)
    love.graphics.draw(love.graphics.newText(menuFont, "MOVE"), move.x, move.y)
    love.graphics.draw(love.graphics.newText(menuFont, "PET"), pet.x, pet.y)
    love.graphics.draw(love.graphics.newText(menuFont, "ACCEPT"), accept.x, accept.y)
end