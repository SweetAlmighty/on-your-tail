require "src/states/menus/menu"

ExtrasMenu = class("ExtrasMenu", Menu)

local isGameshell = love.system.getOS() == "Linux"

function ExtrasMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "EXTRAS")

    self.type = States.ExtrasMenu
    self.startHeight = screenHeight/3
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }
    self.options = {
        love.graphics.newText(menuFont, "OPTIONS"),
        love.graphics.newText(menuFont, "CONTROLS"),
        love.graphics.newText(menuFont, "SCORES"),
        love.graphics.newText(menuFont, "BACK")
    }

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