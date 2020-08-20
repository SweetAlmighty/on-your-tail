require "src/states/menus/menu"

local highscoreMenu = menu

highscoreMenu.initialize = function()
    highscoreMenu.currentTime = ""
    love.graphics.setFont(menuFont)

    highscoreMenu.type = States.HighscoreMenu
    highscoreMenu.setTitle("High Scores")

    highscoreMenu.startHeight = screenHeight - 40
    highscoreMenu.clearColor = { r = 1, g = 1, b = 1, a = 1 }
    highscoreMenu.options = { love.graphics.newText(menuFont, "Back") }

    if love.filesystem.getInfo("highscores.txt") then
        local time = lume.deserialize(love.filesystem.read("highscores.txt"))
        if type(time) == "table" then
            for i=1, #time, 1 do
                local t = time[i][1] .. " ----------- " .. string.format("%.2f", time[i][2]) .. "\n"
                highscoreMenu.currentTime = highscoreMenu.currentTime .. t
            end
        end
    end
end

highscoreMenu.accept =  function()
    tateMachine.pop()
end

function highscoreMenu() return highscoreMenu end
