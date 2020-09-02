local menu = nil
return {
    new = function()
        local credit_text = [[
            Programmer: Brian Sweet
            Artist:          Shelby Merrill
            Made With:     LÖVE
            Utilizing:     tick, lovesize,
                                   lume, json.lua
        ]]
        local credits = love.graphics.newText(menuFont, credit_text)
		return {
            Exit = function() end,
            Input = function(key) menu.Input(key) end,
            Update = function(dt) menu.Update(dt) end,
            Type = function() return GameStates.CreditsMenu end,
            Enter = function()
                menu = Menu.new("CREDITS", "center")
                menu.AddItem{ name = "Back", action = function() StateMachine.Pop() end }
            end,
            Draw = function()
                menu.Draw(nil, screenHeight - 30)
				love.graphics.draw(credits, -20, screenHeight/3.5)
            end,
        }
    end
}