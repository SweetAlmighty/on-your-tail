local menu = nil
return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                menu:addItem{ name = 'Resume', action = function() StateMachine.Pop() end }
                menu:addItem{ name = 'Back', action = function() StateMachine.Clear() end }
            end,
            Update = function(dt) menu:update(dt) end,
            Draw = function() menu:draw(0, 0) end,
            Input = function(key) menu:keypressed(key) end,
            Exit = function() end
        }
    end
}