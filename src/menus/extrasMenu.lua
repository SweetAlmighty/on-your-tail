local menu = nil
local is_gameshell = love.system.getOS() == "Linux"

return {
    new = function()
		return {
            Exit = function() end,
            Draw = function() menu:draw() end,
            Update = function(dt) menu:update(dt) end,
            Input = function(key) menu:input(key) end,
            Type = function() return GameStates.ExtrasMenu end,
            Enter = function()
                menu = Menu.new("EXTRAS", "center")
                if not is_gameshell then
                    menu:add_item{ name = "Options", action = function() StateMachine.Push(GameStates.OptionsMenu) end }
                end
                menu:add_item{ name = "Controls", action = function() StateMachine.Push(GameStates.ControlsMenu) end }
                menu:add_item{ name = "Scores", action = function() StateMachine.Push(GameStates.HighscoreMenu) end }
                menu:add_item{ name = "Back", action = function() StateMachine.Pop() end }
            end,
        }
    end
}