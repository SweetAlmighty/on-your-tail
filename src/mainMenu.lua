
require "src/menu"
require "love.graphics"
local class = require("src/lib/middleclass")

MainMenu = class("MainMenu", Menu)

local totalW, totalH = 121, 65
local pointerW, pointerH = 24, 23
local halfWidth, halfHeight = 0, 0

function MainMenu:initialize()
    Menu.initialize(self)
    halfWidth, halfHeight = scene.width/2, scene.height/2

    self.options = {
        love.graphics.newText(gameFont, "Play"),
        love.graphics.newText(gameFont, "Quit")
    }

    self.image = love.graphics.newImage("/data/menu.png")
    self.pointer = love.graphics.newQuad(97, 0, pointerW, pointerH, totalW, totalH)
end

function MainMenu:Draw()
    love.graphics.clear(1, 1, 1, 1)

    love.graphics.setColor(0, 0, 0, 1)
    local optionX = halfWidth - (self.options[1]:getWidth()/2)
    for i=1, #self.options, 1 do
        love.graphics.draw(self.options[i], optionX, halfHeight + ((i-1) * 40))
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, self.pointer, halfWidth - pointerW * 2,
        (halfHeight + (self.index * 40)), nil, nil, nil, nil, nil)
end
