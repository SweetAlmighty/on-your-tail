local menu = nil
local current_time = ""
return {
    new = function()
		return {
            Exit = function() end,
            Update = function(dt) menu:update(dt) end,
            Input = function(key) menu:input(key) end,
            Type = function() return GameStates.HighscoreMenu end,
            Draw = function()
                menu:draw(nil, screen_height - 30)
                love.graphics.print("", (screen_width/2) - 110, (screen_height/2) - 25)
            end,
            Enter = function()
                menu = Menu.new("SCORES", "center")
                menu:add_item{ name = "Back", action = function() StateMachine.Pop() end }

                local scores = Data.GetScores()
                for i=1, #scores, 1 do
                    local txt = current_time..scores[i][1].." ----------- "..string.format("%.2f", scores[i][2]).."\n"
                    current_time = txt
                end
            end,
        }
    end
}