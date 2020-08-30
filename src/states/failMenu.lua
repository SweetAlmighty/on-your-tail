return {
    new = function()
        local menu = Menu.new('center')
		return {
            Exit = function() end,
            Draw = function() menu:Draw(0, 0) end,
            Update = function(dt) menu:Update(dt) end,
            Input = function(key) menu:Input(key) end,
            Enter = function()
                menu:AddItem({
                    name = 'Play Again',
                    action = function()
                        StateMachine.Clear()
                        StateMachine.Push(GameStates.Gameplay)
                    end
                })
                menu:AddItem({ name = 'Add Score', action = function() StateMachine.Push(GameStates.SetScoreMenu) end })
                menu:AddItem({ name = 'Main Menu', action = function() StateMachine.Clear() end })
            end,
        }
    end
}