local menu = nil
local title = nil
local background = nil

return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                menu:AddItem{ name = 'Press Start', action = function() StateMachine.Push(GameStates.MainMenu) end }

                background = Resources.LoadImage("titleScreen")
                title = AnimationFactory.CreateAnimationSet("title")[1][1]
            end,
            Draw = function()
                love.graphics.draw(background, 0, 0)
                title.Draw(34, 0)
                menu:Draw(0, 0)
            end,
            Update = function(dt)
                menu:Update(dt)
                title.Update(dt)
            end,
            Input = function(key) menu:Input(key) end,
            Exit = function() end
        }
    end
}