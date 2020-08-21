local menu = nil
local credits = ''
return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                menu:addItem{ name = 'Back', action = function() StateMachine.Pop() end }
                credits = [[
                    Programmer: Brian Sweet
                    Artist:          Shelby Merrill
                    Made With:     LÖVE
                    Utilizing:     tick, lovesize, json.lua
                ]]
            end,
            Update = function(dt) menu:update(dt) end,
            Draw = function()
                menu:draw(screenWidth / 2, screenHeight - 30)
                love.graphics.print(credits, 0, screenHeight/3.5)
            end,
            Input = function(key) menu:keypressed(key) end,
            Exit = function() end
        }
    end
}