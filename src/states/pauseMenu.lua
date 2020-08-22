local menu = nil
return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new('center')
                menu:AddItem{ name = 'Resume', action = function() StateMachine.Pop() end }
                menu:AddItem{ name = 'Back', action = function() StateMachine.Clear() end }
            end,
            Update = function(dt) menu:Update(dt) end,
            Draw = function() menu:Draw(0, 0) end,
            Input = function(key) menu:Input(key) end,
            Exit = function() end
        }
    end
}