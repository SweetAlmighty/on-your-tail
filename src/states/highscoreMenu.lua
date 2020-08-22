local menu = nil
local currentTime = ''
return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                menu:AddItem{ name = 'Back', action = function() StateMachine.Pop() end }

                local scores = Data.GetScores()
                for i=1, #scores, 1 do
                    currentTime = currentTime..scores[i][1]..' ----------- '..string.format('%.2f', scores[i][2])..'\n'
                end
            end,
            Draw = function()
                menu:Draw(screenWidth / 2, screenHeight - 30)
                love.graphics.print('', (screenWidth/2) - 110, (screenHeight/2) - 25)
            end,
            Update = function(dt) menu:Update(dt) end,
            Input = function(key) menu:Input(key) end,
            Exit = function() end
        }
    end
}