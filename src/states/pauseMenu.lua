--[[
require "src/states/menus/menu"

PauseMenu = class("PauseMenu", Menu)

function PauseMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "PAUSE")

    self.type = States.PauseMenu
    self.startHeight = screenHeight/2
    self.clearColor = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 }
    Menu.setOptions(self, { "RESUME", "MAIN MENU" })
end

function PauseMenu:accept()
    if self.index <= 2 then Menu.accept(self) end
    if self.index == 1 then stateMachine:pop()
    elseif self.index == 2 then stateMachine:clear() end
end

function PauseMenu:draw() Menu.draw(self) end
]]
local menu = nil
return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                menu:addItem{ name = 'Start Game', action = function() StateMachine.Push(GameStates.Gameplay) end }
                menu:addItem{ name = 'Extras', action = function() StateMachine.Push(GameStates.ExtrasMenu) end }
                menu:addItem{ name = 'Credits', action = function() StateMachine.Push(GameStates.CreditsMenu) end }
                menu:addItem{ name = 'Quit', action = function() love.event.quit() end }
            end,
            Update = function(dt) menu:update(dt) end,
            Draw = function() menu:draw(0, 0) end,
            Input = function(key) menu:keypressed(key) end,
            Exit = function() end
        }
    end
}