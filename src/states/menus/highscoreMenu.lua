
require "src/states/menus/menu"

HighscoreMenu = class("HighscoreMenu", Menu)

function HighscoreMenu:initialize()
    Menu.initialize(self)
    self.currentTime = ""
    love.graphics.setFont(menuFont)
    self.type = States.HighscoreMenu
    self.startHeight = screenHeight - 40
    Menu.setTitle(self, "High Scores")
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }
    self.options = { love.graphics.newText(menuFont, "Back") }

    if love.filesystem.getInfo("highscores.txt") then
        local time = lume.deserialize(love.filesystem.read("highscores.txt"))
        if type(time) == "table" then
            for i=1, #time, 1 do
                local t = time[i][1] .. " ----------- " .. string.format("%.2f", time[i][2]) .. "\n"
                self.currentTime = self.currentTime .. t
            end
        end
    end
end

function HighscoreMenu:draw()
    Menu.draw(self)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.currentTime, (screenWidth/2) - 110, (screenHeight/2) - 25)
end

function HighscoreMenu:cleanup() end
function HighscoreMenu:accept() stateMachine:pop() end
