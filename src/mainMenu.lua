
require "src/scene"
require "love.graphics"

MainMenu = { }

local index = 0
local totalW, totalH = 121, 65
local optionW, optionH = 96, 32
local pointerW, pointerH = 24, 23
local halfW, halfH = (optionW/2), (optionH/2)

local image   = love.graphics.newImage("/data/menu.png")
local play    = love.graphics.newQuad(0, 0,  optionW, optionH, totalW, totalH)
local quit    = love.graphics.newQuad(0, 33, optionW, optionH, totalW, totalH)
local pointer = love.graphics.newQuad(97, 0, pointerW, pointerH, totalW, totalH)

local halfWidth, halfHeight, optionX, pointerX, playHeight, pointerHeight

local calcPositions = function()
    halfWidth, halfHeight = scene.width/2, scene.height/2

    optionX = halfWidth - halfW
    playHeight = halfHeight - (optionH + halfH)
    pointerX = optionX - (pointerW + (pointerW / 2))
    pointerHeight = (index == 0 and playHeight or halfHeight) + (pointerH / 4)
end

function MainMenu:Draw()
    calcPositions()
    love.graphics.clear(1, 1, 1, 1)
    love.graphics.draw(image, play, optionX, playHeight, nil, nil, nil, nil, nil)
    love.graphics.draw(image, quit, optionX, halfHeight, nil, nil, nil, nil, nil)
    love.graphics.draw(image, pointer, pointerX, pointerHeight, nil, nil, nil, nil, nil)
end

function MainMenu:GetIndex() return index end
function MainMenu:Up() index = index - 1 if index < 0 then index = 0 end end
function MainMenu:Down() index = index + 1 if index > 1 then index = 1 end end
