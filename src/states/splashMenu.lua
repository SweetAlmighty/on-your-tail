local menu = nil
local title = nil
local background = nil

return {
    new = function()
		return {
            Exit = function() end,
            Input = function(key) menu:Input(key) end,
            Update = function(dt)
                menu:Update(dt)
                title.Update(dt)
            end,
            Draw = function()
                love.graphics.draw(background, 0, 0)
                title.Draw(34, 0)
                menu:Draw(0, 0)
            end,
            Enter = function()
                menu = Menu.new('center')
                menu:AddItem{ name = 'Press Start', action = function() StateMachine.Push(GameStates.MainMenu) end }

                background = Resources.LoadImage('titleScreen')
                title = AnimationFactory.CreateAnimationSet('title')[1][1]
            end,
        }
    end
}