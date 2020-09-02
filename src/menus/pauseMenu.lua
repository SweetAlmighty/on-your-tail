local menu = nil
return {
    new = function()
		return {
            Exit = function() end,
            Draw = function() menu:draw() end,
            Update = function(dt) menu:update(dt) end,
            Input = function(key) menu:input(key) end,
            Type = function() return GameStates.PauseMenu end,
            Enter = function()
                menu = Menu.new("PAUSE", "center")
                menu:add_item{ name = "Resume", action = function() StateMachine.Pop() end }
                menu:add_item{ name = "Options", action = function() StateMachine.Push(GameStates.OptionsMenu) end }
                menu:add_item{ name = "Back", action = function() StateMachine.Clear() end }
            end,
        }
    end
}