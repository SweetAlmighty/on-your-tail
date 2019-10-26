
require "src/menu"
require "love.graphics"
local class = require("src/lib/middleclass")

MainMenu = class("MainMenu", Menu)

local halfWidth, halfHeight = 0, 0

function MainMenu:initialize()
    Menu.initialize(self)
    halfWidth, halfHeight = scene.width/2, scene.height/2

    self.options = {
        love.graphics.newText(gameFont, "Play"),
        love.graphics.newText(gameFont, "Quit")
    }

    self.title = love.graphics.newImage("/data/title.png")
    self.pointer = love.graphics.newImage("/data/pointer.png")
end

function MainMenu:Draw()
    love.graphics.clear(1, 1, 1, 1)
    love.graphics.draw(self.title, 33, 40, nil, nil, nil, nil, nil)

    love.graphics.setColor(0, 0, 0, 1)
    local optionX = halfWidth - (self.options[1]:getWidth()/2)
    for i=1, #self.options, 1 do
        love.graphics.draw(self.options[i], optionX, halfHeight + ((i-1) * 40))
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.pointer, halfWidth - self.pointer:getWidth() * 2,
        (halfHeight + 5 + (self.index * 40)), nil, nil, nil, nil, nil)
end
