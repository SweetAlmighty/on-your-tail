require "src/states/menus/menu"

MainMenu = class("MainMenu", Menu)

function MainMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "ON YOUR TAIL")

    self.type = States.MainMenu
    self.startHeight = screenHeight/1.75
    self.clearColor = { r = 1, g = 1, b = 1, a = 1}
    Menu.setOptions(self, { "PLAY", "EXTRAS", "CREDITS", "QUIT" })
end

function MainMenu:accept()
    self.acceptSFX:play()
    if self.index == 1 then stateMachine:push(States.Gameplay)
    elseif self.index == 2 then stateMachine:push(States.ExtrasMenu)
    elseif self.index == 3 then stateMachine:push(States.CreditsMenu)
    else love.event.quit() end
end

function MainMenu:draw() Menu.draw(self) end
