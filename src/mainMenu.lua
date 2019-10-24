
require "src/scene"
require "love.graphics"
local class = require("src/lib/middleclass")

MainMenu = class("MainMenu", Menu)

local index = 0
local totalW, totalH = 121, 65
local optionW, optionH = 96, 32
local pointerW, pointerH = 24, 23
local halfW, halfH = (optionW/2), (optionH/2)

function MainMenu:initialize()
    self.halfWidth = scene.width/2
    self.halfHeight = scene.height/2

    self.optionX = self.halfWidth - halfW
    self.playHeight = self.halfHeight - (optionH + halfH)
    self.pointerX = self.optionX - (pointerW + (pointerW / 2))
    
    self.image = love.graphics.newImage("/data/menu.png")
    self.play = love.graphics.newQuad(0, 0,  optionW, optionH, totalW, totalH)
    self.quit = love.graphics.newQuad(0, 33, optionW, optionH, totalW, totalH)
    self.pointer = love.graphics.newQuad(97, 0, pointerW, pointerH, totalW, totalH)
end

function MainMenu:Draw()
    local pointerHeight = (index == 0 and self.playHeight or self.halfHeight) + (pointerH / 4)
    love.graphics.clear(1, 1, 1, 1)
    love.graphics.draw(self.image, self.play, self.optionX, self.playHeight, nil, nil, nil, nil, nil)
    love.graphics.draw(self.image, self.quit, self.optionX, self.halfHeight, nil, nil, nil, nil, nil)
    love.graphics.draw(self.image, self.pointer, self.pointerX, pointerHeight, nil, nil, nil, nil, nil)
end

function MainMenu:GetIndex() return index end
function MainMenu:Up() index = index - 1 if index < 0 then index = 0 end end
function MainMenu:Down() index = index + 1 if index > 1 then index = 1 end end
