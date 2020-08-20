require "src/states/menu/menu"

local mainMenu = menu

mainMenu.initialize = function()
    mainMenu.setTitle("On Your Tail")

    mainMenu.type = e_GameStates.MainMenu
    mainMenu.startHeight = screenHeight/3
    mainMenu.clearColor = { r = 1, g = 1, b = 1, a = 1}
    mainMenu.options = {
        love.graphics.newText(menuFont, "Play"),
        love.graphics.newText(menuFont, "Scores"),
        love.graphics.newText(menuFont, "Controls"),
        love.graphics.newText(menuFont, "Quit")
    }
end

mainMenu.accept =  function()
    mainMenu.acceptSFX:play()
    if mainMenu.index == 1 then stateMachine.push(e_GameStates.Gameplay)
    elseif mainMenu.index == 2 then stateMachine.push(e_GameStates.HighscoreMenu)
    elseif mainMenu.index == 3 then stateMachine.push(e_GameStates.ControlsMenu)
    else love.event.quit() end
end

function mainMenu() return mainMenu end
