local SplashScreen = {
    title = nil,
    pause = false,
    background = nil,
    accept_sfx = Resources.LoadSFX("accept"),
}

function SplashScreen:update(dt) self.title.Update(dt) end
function SplashScreen:type() return GameStates.SplashScreen end

function SplashScreen:draw()
    love.graphics.draw(self.background, 0, 0)
    self.title.Draw(34, 0)
end

function SplashScreen:enter()
    self.pause = false
    self.background = Resources.LoadImage("titleScreen")
    self.title = AnimationFactory.CreateAnimationSet("title")[1][1]
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