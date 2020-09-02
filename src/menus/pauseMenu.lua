local menu = nil
return {
    new = function()
		return {
            Exit = function() end,
            Draw = function() menu.Draw() end,
            Update = function(dt) menu.Update(dt) end,
            Input = function(key) menu.Input(key) end,
            Type = function() return GameStates.PauseMenu end,
            Enter = function()
                menu = Menu.new("PAUSE", "center")
                menu.AddItem{ name = "Resume", action = function() StateMachine.Pop() end }
                menu.AddItem{ name = "Options", action = function() StateMachine.Push(GameStates.OptionsMenu) end }
                menu.AddItem{ name = "Back", action = function() StateMachine.Clear() end }
            end,
        }
    end
}