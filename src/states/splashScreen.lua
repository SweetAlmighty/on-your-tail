local title = nil
local pause = false
local background = nil

local function update(dt) title.Update(dt) end
local function type() return GameStates.SplashScreen end
local function draw()
    love.graphics.draw(background, 0, 0)
    title.Draw(34, 0)
end
local function input(key)
    if key == InputMap.a then
        if not pause then
            pause = true
            MenuStateMachine.Push(GameMenus.MainMenu)
        end
    end
end

local function enter()
    background = Resources.LoadImage("titleScreen")
    title = AnimationFactory.CreateAnimationSet("title")[1][1]
end

return {
    new = function()
		return {
            Type = type,
            Draw = draw,
            Enter = enter,
            Input = input,
            Update = update
        }
    end
}