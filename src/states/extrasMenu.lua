--[[
require "src/states/menus/menu"

ExtrasMenu = class("ExtrasMenu", Menu)

local isGameshell = love.system.getOS() == "Linux"

function ExtrasMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "EXTRAS")

    self.type = States.ExtrasMenu
    self.startHeight = screenHeight/1.75
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }
    Menu.setOptions(self, { "OPTIONS", "CONTROLS", "SCORES", "BACK" })

    if isGameshell then
        table.remove(self.options, 1)
    end
end

function ExtrasMenu:accept()
    if self.index <= #self.options then Menu.accept(self) end
    if isGameshell then
        if self.index == 1 then stateMachine:push(States.ControlsMenu)
        elseif self.index == 2 then stateMachine:push(States.HighscoreMenu)
        elseif self.index == 3 then stateMachine:pop() end
    else
        if self.index == 1 then stateMachine:push(States.OptionsMenu)
        elseif self.index == 2 then stateMachine:push(States.ControlsMenu)
        elseif self.index == 3 then stateMachine:push(States.HighscoreMenu)
        elseif self.index == 4 then stateMachine:pop() end
    end
end

function ExtrasMenu:draw() Menu.draw(self) end
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