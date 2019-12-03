
require "src/entities/cat"

Kitten = class("Kitten", Cat)

function Kitten:initialize()
    self.currAnim = { }
    self.limit = catLimit
    self.state = s_SITTING
    self.button = InteractButton:new()

    self.imageWidth = 122
    self.imageHeight = 120
    self.spriteWidth = 16
    self.spriteHeight = 15

    self.index = love.math.random(1, self.imageHeight/self.spriteHeight)

    local _x, _y = randomPosition(self)
    local currY = ((self.index - 1) * self.spriteHeight)
    Entity.initialize(self, _x, _y, love.graphics.newQuad(0, currY, self.spriteWidth,
        self.spriteHeight, self.imageWidth, self.imageHeight), "kittens.png", 1, Types.Kitten)

    self.sittingX = { left = 98, right = 110 }
    self.sittingQuad = love.graphics.newQuad(0, self.spriteHeight * (self.index - 1), 12, 15,
        self.imageWidth, self.imageHeight)

    self.walkLeft = anim.newAnimat(15)
    self.walkLeft:addSheet(self.image)
    self.walkLeft:addFrame(0,  currY, 16, 15)
    self.walkLeft:addFrame(32, currY, 16, 15)
    self.walkLeft:addFrame(0,  currY, 16, 15)
    self.walkLeft:addFrame(64, currY, 17, 15)

    self.walkRight = anim.newAnimat(15)
    self.walkRight:addSheet(self.image)
    self.walkRight:addFrame(16, currY, 16, 15)
    self.walkRight:addFrame(48, currY, 16, 15)
    self.walkRight:addFrame(16, currY, 16, 15)
    self.walkRight:addFrame(81, currY, 17, 15)
end