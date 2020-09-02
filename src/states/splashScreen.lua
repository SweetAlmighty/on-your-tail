return {
    new = function()
        local title = nil
        local pause = false
        local background = nil

		return {
            Exit = function() end,
            Update = function(dt) title.Update(dt) end,
            Type = function() return GameStates.SplashScreen end,
            Draw = function()
                love.graphics.draw(background, 0, 0)
                title.Draw(34, 0)
            end,
            Enter = function()
                background = Resources.LoadImage("titleScreen")
                title = AnimationFactory.CreateAnimationSet("title")[1][1]
            end,
            Input = function(key)
                if key == InputMap.a then
                    if pause == false then
                        pause = true
                        MenuStateMachine.Push(GameMenus.MainMenu)
                    end
				end
            end,
        }
    end
}