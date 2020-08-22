local menu = nil
local isGameshell = love.system.getOS() == 'Linux'

return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                if not isGameshell then
                    menu:AddItem{ name = 'Options', action = function() StateMachine.Push(GameStates.OptionsMenu) end }
                end
                menu:AddItem{ name = 'Controls', action = function() StateMachine.Push(GameStates.ControlsMenu) end }
                menu:AddItem{ name = 'Scores', action = function() StateMachine.Push(GameStates.HighscoreMenu) end }
                menu:AddItem{ name = 'Back', action = function() StateMachine.Pop() end }
            end,
            Update = function(dt) menu:Update(dt) end,
            Draw = function() menu:Draw(0, 0) end,
            Input = function(key) menu:Input(key) end,
            Exit = function() end
        }
    end
}