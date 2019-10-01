
local animat = require("src/lib/animat")
local class = require("src/lib/middleclass")

InteractButton = class("InteractButton")

function InteractButton:initialize()
    self.animation = animat.newAnimat(15) -- framerate
    self.animation:addSheet(love.graphics.newImage('/data/button_press.png'))
    self.animation:addFrame(20, 0, 20, 20)
    self.animation:addFrame(0, 0, 20, 20)

    self.image = love.graphics.newImage("/data/button_press.png")
    self.width = (self.image == nil) and 1 or self.image:getWidth()
    self.height = (self.image == nil) and 1 or self.image:getHeight()
end

function InteractButton:draw(x, y)
    love.graphics.draw(self.image, self.animation.currentFrame, x, y, nil, nil, nil, self.width / 2, 
        self.height)
end

function InteractButton:update(dt)
    self.animation:play(dt)
end

function InteractButton:reset()
    self.animation:reset()
end