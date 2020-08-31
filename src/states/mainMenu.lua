local menu = nil
return {
    new = function()
		return {
            Exit = function() end,
            Draw = function() menu.Draw() end,
            Update = function(dt) menu.Update(dt) end,
            Input = function(key) menu.Input(key) end,
            Enter = function()
                menu = Menu.new('MAIN', 'center')
                menu.AddItem{ name = 'Start Game', action = function() StateMachine.Push(GameStates.Gameplay) end }
                menu.AddItem{ name = 'Extras', action = function() StateMachine.Push(GameStates.ExtrasMenu) end }
                menu.AddItem{ name = 'Credits', action = function() StateMachine.Push(GameStates.CreditsMenu) end }
                menu.AddItem{ name = 'Quit', action = function() love.event.quit() end }
            end,
        }
    end
}