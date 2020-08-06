require "src/states/menus/menu"

ExtrasMenu = class("ExtrasMenu", Menu)

local isGameshell = love.system.getOS() == "Linux"

function ExtrasMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "EXTRAS")

    self.type = States.ExtrasMenu
    self.startHeight = screenHeight/1.75
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }
    Menu.setOptions(self, { "OPTIONS", "CONTROLS", "SCORES", "BACK" })

    if isGameshell then
        table.remove(self.options, 1)
    end
end

function ExtrasMenu:accept()
    if self.index <= #self.options then Menu.accept(self) end
    if isGameshell then
        if self.index == 1 then stateMachine:push(States.ControlsMenu)
        elseif self.index == 2 then stateMachine:push(States.HighscoreMenu)
        elseif self.index == 3 then stateMachine:pop() end
    else
        if self.index == 1 then stateMachine:push(States.OptionsMenu)
        elseif self.index == 2 then stateMachine:push(States.ControlsMenu)
        elseif self.index == 3 then stateMachine:push(States.HighscoreMenu)
        elseif self.index == 4 then stateMachine:pop() end
    end
end

function ExtrasMenu:draw() Menu.draw(self) end