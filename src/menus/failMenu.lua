return {
    new = function()
        local menu = Menu.new("GAME OVER", "center")
		return {
            Exit = function() end,
            Draw = function() menu:draw() end,
            Update = function(dt) menu:update(dt) end,
            Input = function(key) menu:input(key) end,
            Type = function() return GameStates.FailMenu end,
            Enter = function()
                menu:add_item({
                    name = "Play Again",
                    action = function()
                        StateMachine.Clear()
                        StateMachine.Push(GameStates.Gameplay)
                    end
                })
                menu:add_item({
                    name = "Add Score",
                    action = function()
                        StateMachine.Push(GameStates.SetScoreMenu)
                    end 
                })
                menu:add_item({
                    name = "Main Menu",
                    action = function()
                        StateMachine.Clear()
                    end
                })
            end,
        }
    end
}