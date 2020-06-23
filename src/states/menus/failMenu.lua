
require "src/states/menus/menu"

FailMenu = class("FailMenu", Menu)

function FailMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "Uh oh...")

    self.type = States.FailMenu
    self.currX, self.currY = 1, 1
    self.startHeight = screenHeight/2.5
    self.clearColor = { r = 1, g = 1, b = 1, a = 0.8 }
    self.options = {
        love.graphics.newText(menuFont, "Play again"),
        love.graphics.newText(menuFont, "Add score"),
        love.graphics.newText(menuFont, "Main menu")
    }
end

function FailMenu:draw()
    Menu.draw(self)
end

function FailMenu:up()
    local x = self.index - 1
    if x < 1 then x = 1 else
        x = self.index - 1
        self.moveSFX:play()
    end
    self.index = x
end

function FailMenu:down()
    local x = self.index + 1
    if x > #self.options then x = #self.options else
        x = self.index + 1
        self.moveSFX:play()
    end
    self.index = x
end

function FailMenu:accept()
    self.acceptSFX:play()

    if self.index <= #self.options then Menu.accept(self) end

    if self.index == 1 then
        stateMachine:pop()
    elseif self.index == 2 then
        stateMachine:push(States.SetScoreMenu)
    else
        stateMachine:clear()
    end
end