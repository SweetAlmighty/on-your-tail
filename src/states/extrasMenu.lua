local menu = nil
local isGameshell = love.system.getOS() == 'Linux'

return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                if not isGameshell then
                    menu:addItem{ name = 'Options', action = function() StateMachine.Push(GameStates.OptionsMenu) end }
                end
                menu:addItem{ name = 'Controls', action = function() StateMachine.Push(GameStates.ControlsMenu) end }
                menu:addItem{ name = 'Scores', action = function() StateMachine.Push(GameStates.HighscoreMenu) end }
                menu:addItem{ name = 'Back', action = function() StateMachine.Pop() end }
            end,
            Update = function(dt) menu:update(dt) end,
            Draw = function() menu:draw(0, 0) end,
            Input = function(key) menu:keypressed(key) end,
            Exit = function() end
        }
    end
}