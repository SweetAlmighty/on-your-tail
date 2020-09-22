local SplashScreen = {
    title = nil,
    pause = false,
    background = nil,
    accept_sfx = Resources.LoadSFX("accept")
}

local start_width = 0
local start_button = love.system.getOS() == "Linux" and "A" or "Z"

function SplashScreen:exit() end

function SplashScreen:update(dt) self.title.Update(dt) end

function SplashScreen:draw()
    love.graphics.draw(self.background, 0, 0)

    if MenuStateMachine:count() == 0 then
        love.graphics.draw(self.start_text, start_width, 220)
    end

    self.title.Draw(34, 0)
end

function SplashScreen:enter()
    self.pause = false
    self.background = Resources.LoadImage("titleScreen")
    self.title = AnimationFactory.CreateAnimationSet("title")[1][1]
    self.start_text = love.graphics.newText(menuFont, "Press "..start_button.." to begin")
    start_width = (screen_width/2) - (self.start_text:getWidth()/2)
end

function SplashScreen:input(key)
    if not self.pause then
        if key == InputMap.a then
            self.pause = true
            self.accept_sfx:play()
            MenuStateMachine:push(GameMenus.MainMenu)
        end
    else
        if self.pause and MenuStateMachine:count() == 0 then
            self.pause = false
        end
    end
end

return SplashScreen