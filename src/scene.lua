
require "love.graphics"

local speed = 2
local width = 320
local height = 240

Scene = {}
Scene.__index = Scene

function Scene:Create()
    Scene.image = love.graphics.newImage("/data/background_two.png")
    Scene.one = 
    {
        x = 0,
        y = 0,
        quad = love.graphics.newQuad(0, 0, width, height, width, height)
    }
    Scene.two = 
    {
        x = width,
        y = 0,
        quad = love.graphics.newQuad(0, 0, width, height, width, height)
    }
    Scene.playableArea = 
    {
        x = 0,
        y = 75,
        maxX = width,
        maxY = height
    }
end

function Scene:Draw()
    love.graphics.draw(Scene.image, Scene.one.quad, Scene.one.x, Scene.one.y)
    love.graphics.draw(Scene.image, Scene.two.quad, Scene.two.x, Scene.two.y)
end

function Scene:Update()
    local x = Scene.one.x - speed
    Scene.one.x = (x < (-width)) and (width) or (x)

    x = Scene.two.x - speed
    Scene.two.x = (x < (-width)) and (width) or (x)
end

function Scene:SetSpeed(s)
    speed = s
end

function Scene:Width()
    return width
end

function Scene:Height()
    return height
end

function Scene:Speed()
    return speed
end

function Scene:PlayableArea()
    return Scene.playableArea;
end