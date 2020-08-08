require "src/states/menus/menu"

HighscoreMenu = class("HighscoreMenu", Menu)

function HighscoreMenu:initialize()
    Menu.initialize(self)
    self.currentTime = ""

    love.graphics.setFont(menuFont)
    self.type = States.HighscoreMenu
    Menu.setTitle(self, "SCORES")

    self.startHeight = screenHeight - 40
    self.clearColor = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 }
    Menu.setOptions(self, { "BACK" })

    local scores = getScores()
    for i=1, #scores, 1 do
        local t = scores[i][1] .. " ----------- " .. string.format("%.2f", scores[i][2]) .. "\n"
        self.currentTime = self.currentTime .. t
    end
end

function HighscoreMenu:draw()
    Menu.draw(self)
    love.graphics.print(self.currentTime, (screenWidth/2) - 110, (screenHeight/2) - 25)
end

function HighscoreMenu:accept()
    Menu.accept(self)
    stateMachine:pop()
end
