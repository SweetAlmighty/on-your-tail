local menu = nil
local is_gameshell = love.system.getOS() == "Linux"

return {
    new = function()
		return {
            Exit = function() end,
            Draw = function() menu.Draw() end,
            Update = function(dt) menu.Update(dt) end,
            Input = function(key) menu.Input(key) end,
            Type = function() return GameStates.ExtrasMenu end,
            Enter = function()
                menu = Menu.new("EXTRAS", "center")
                if not is_gameshell then
                    menu.AddItem{ name = "Options", action = function() StateMachine.Push(GameStates.OptionsMenu) end }
                end
                menu.AddItem{ name = "Controls", action = function() StateMachine.Push(GameStates.ControlsMenu) end }
                menu.AddItem{ name = "Scores", action = function() StateMachine.Push(GameStates.HighscoreMenu) end }
                menu.AddItem{ name = "Back", action = function() StateMachine.Pop() end }
            end,
        }
    end
}