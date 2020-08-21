local menu = nil
return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                menu:addItem{ name = 'Play Again', action = function() StateMachine.Pop() end }
                menu:addItem{ name = 'Add Score', action = function() StateMachine.Push(GameStates.SetScoreMenu) end }
                menu:addItem{ name = 'Main Menu', action = function() StateMachine.Clear() end }
            end,
            Update = function(dt) menu:update(dt) end,
            Draw = function() menu:draw(0, 0) end,
            Input = function(key) menu:keypressed(key) end,
            Exit = function() end
        }
    end
}