return {
    new = function()
        local menu = Menu.new("GAME OVER", "center")
		return {
            Exit = function() end,
            Draw = function() menu.Draw() end,
            Update = function(dt) menu.Update(dt) end,
            Input = function(key) menu.Input(key) end,
            Type = function() return GameStates.FailMenu end,
            Enter = function()
                menu.AddItem({
                    name = "Play Again",
                    action = function()
                        StateMachine.Clear()
                        StateMachine.Push(GameStates.Gameplay)
                    end
                })
                menu.AddItem({ name = "Add Score", action = function() StateMachine.Push(GameStates.SetScoreMenu) end })
                menu.AddItem({ name = "Main Menu", action = function() StateMachine.Clear() end })
            end,
        }
    end
}