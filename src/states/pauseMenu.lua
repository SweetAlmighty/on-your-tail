local menu = nil
return {
    new = function()
		return {
            Exit = function() end,
            Draw = function() menu:Draw(0, 0) end,
            Update = function(dt) menu:Update(dt) end,
            Input = function(key) menu:Input(key) end,
            Enter = function()
                menu = Menu.new('center')
                menu:AddItem{ name = 'Resume', action = function() StateMachine.Pop() end }
                menu:AddItem{ name = 'Back', action = function() StateMachine.Clear() end }
            end,
        }
    end
}