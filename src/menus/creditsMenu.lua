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
            Input = function(key) menu:input(key) end,
            Update = function(dt) menu:update(dt) end,
            Type = function() return GameStates.CreditsMenu end,
            Enter = function()
                menu = Menu.new("CREDITS", "center")
                menu:add_item{ name = "Back", action = function() StateMachine.Pop() end }
            end,
            Draw = function()
                menu:draw(nil, screenHeight - 30)
				love.graphics.draw(credits, -20, screenHeight/3.5)
            end,
        }
    end
}