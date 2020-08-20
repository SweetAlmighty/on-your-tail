
require "src/states/menus/menu"

local pauseMenu = menu

pauseMenu.initialize = function()
    pauseMenu.setTitle("Pause")

    pauseMenu.type = e_GameStates.PauseMenu
    pauseMenu.startHeight = screenHeight/2
    pauseMenu.clearColor = { r = 1, g = 1, b = 1, a = 0.5 }
    pauseMenu.options = {
        love.graphics.newText(menuFont, "Resume"),
        love.graphics.newText(menuFont, "Main Menu")
    }
end

pauseMenu.accept =  function()
    if pauseMenu.index <= 2 then pauseMenu.acceptSFX:play() end
    if pauseMenu.index == 1 then stateMachine.pop()
    elseif pauseMenu.index == 2 then stateMachine.clear() end
end

function pauseMenu() return pauseMenu end
