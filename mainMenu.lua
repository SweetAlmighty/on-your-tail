
require "love.graphics"

index = 0

MainMenu = {

}

function MainMenu:Draw()
    if index == 0 then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("Play", SceneWidth/2, (SceneHeight/2) - 50)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Quit", SceneWidth/2, (SceneHeight/2) + 50)
    elseif index == 1 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Play", SceneWidth/2, (SceneHeight/2) - 50)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("Quit", SceneWidth/2, (SceneHeight/2) + 50)
    end
end

function MainMenu:Input(k)
    if k == "up" then
        index = index - 1
        if index < 0 then
            index = 0
        end
    elseif k == "down" then
        index = index + 1
        if index > 1 then
            index = 1
        end
    elseif k == "return" and index == 0 then
        state = 1
    end
end