
require "src/scene"
require "love.graphics"

MainMenu = { }

local index = 0

function MainMenu:Draw()
    if index == 0 then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("Play", Scene:Width()/2, (Scene:Height()/2) - 50)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Quit", Scene:Width()/2, (Scene:Height()/2) + 50)
    elseif index == 1 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Play", Scene:Width()/2, (Scene:Height()/2) - 50)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("Quit", Scene:Width()/2, (Scene:Height()/2) + 50)
    end
end

function MainMenu:Up()
    index = index - 1
    if index < 0 then
        index = 0
    end
end

function MainMenu:Down()
    index = index + 1
    if index > 1 then
        index = 1
    end
end

function MainMenu:GetIndex()
    return index
end