local Menu = require "src/menus/menu"

local menu = nil
return {
    new = function()
		return {
            Exit = function() end,
            Draw = function() menu:draw() end,
            Update = function(dt) menu:update(dt) end,
            Input = function(key) menu:input(key) end,
            Type = function() return GameMenus.MainMenu end,
            Enter = function()
                menu = Menu.new("MAIN", "center")
                menu:add_item{ name = "Start Game", action = function() StateMachine.Push(GameStates.Gameplay) end }
                menu:add_item{ name = "Extras", action = function() StateMachine.Push(GameStates.ExtrasMenu) end }
                menu:add_item{ name = "Credits", action = function() StateMachine.Push(GameStates.CreditsMenu) end }
                menu:add_item{ name = "Quit", action = function() love.event.quit() end }
            end,
        }
    end
}