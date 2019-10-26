
require "src/entity"
require "src/interactButton"

local lume = require("src/lib/lume")
local animat = require("src/lib/animat")
local class = require("src/lib/middleclass")

Cat = class("Cat", Entity)

local time = 0
local index = 1
local update = false
local s_SITTING, s_WALKING = 1, 2
local imageWidth, imageHeight = 150, 160
local spriteWidth, spriteHeight = 20, 20

local randomPosition = function()
    return math.random(scene.width - spriteWidth, scene.width * 2),
        math.random(scene.playableArea.y - spriteHeight, scene.playableArea.height)
end

local processMovement = function(cat)
    local _x = (cat.x + (cat.speed * cat.direction.x))
    local _y = (cat.y + (cat.speed * cat.direction.y))
    if moveCamera == false then
        if cat.state == s_SITTING then _x, _y = cat.x, cat.y end
    else
        if cat.state == s_SITTING then _x, _y = cat.x - scene.speed, cat.y end
    end

    Entity.move(cat, _x, _y)

    if cat.x < (-cat.width) then cat:reset() end
end

local processAnims = function(dt, cat)
    time = time + dt
    if time > 1 then
        time = 0
        if cat.interacting ~= true then
            cat.state = lume.randomchoice({s_SITTING, s_WALKING})
            if cat.state == s_WALKING then cat.direction = lume.randomchoice(Directions) end
            update = true
        end
    end

    if update then
        if cat.state == s_WALKING and cat.interacting == false then -- Walk
            cat.currAnim = (cat.direction.x == 1) and cat.walkRight or cat.walkLeft
        else -- Sit
            cat.quad = love.graphics.newQuad((cat.direction.x == 1) and 136 or 122,
                spriteHeight * (cat.index - 1), 14, 19, imageWidth, imageHeight)
        end
        update = false
    end

    if cat.state == s_WALKING then
        cat.currAnim:play(dt)
        cat.quad = cat.currAnim.currentFrame
    end
end

function Cat:initialize()
    self.limit = 2.5
    self.button = InteractButton:new()

    self.currAnim = { }
    self.state = s_SITTING

    local _x, _y = randomPosition()

    self.walkLeft, self.walkRight = animat.newAnimat(15), animat.newAnimat(15)

    Entity.initialize(self, _x, _y, love.graphics.newQuad(0, ((index - 1) * 20), spriteWidth,
        spriteHeight, imageWidth, imageHeight), "cats.png", 1, Types.Cat)

    self.walkLeft:addSheet(self.image)
    self.walkRight:addSheet(self.image)

    self:setIndex(index)

    index = index + 1
end

function Cat:draw()
    Entity.draw(self);
    if self.interactable then self.button:draw(self.x + 20, self.y) end
end

function Cat:reset()
    self.limit = 2.5
    Entity.reset(self, randomPosition())
end

function Cat:update(dt)
    processAnims(dt, self)
    if player.interacting and self.interacting then
        self.button:update(dt)
    else
        processMovement(self)
    end
end

function Cat:interact(dt)
    if self.interactable and self.interacting == false then
        update = true
        self.state = s_SITTING
        self.interacting = true
    end

    if self.interacting then
        self.button:update(dt)
        self.limit = self.limit - (dt * 10)

        if self.limit < 0 then
            self.limit = 0
            Cat.finishInteraction(self)
        end
    end
end

function Cat:setIndex(_index)
    self.index = _index
    local currY = ((_index - 1) * 20)

    self.walkLeft:addFrame(0,  currY, 20, 20)
    self.walkLeft:addFrame(40, currY, 20, 20)
    self.walkLeft:addFrame(0,  currY, 20, 20)
    self.walkLeft:addFrame(80, currY, 21, 20)

    self.walkRight:addFrame(20,  currY, 20, 20)
    self.walkRight:addFrame(60,  currY, 20, 20)
    self.walkRight:addFrame(20,  currY, 20, 20)
    self.walkRight:addFrame(101, currY, 21, 20)
end

function Cat:finishInteraction()
    if self.interacting then
        self.button:reset()
        self.interactable = false;
        player:finishInteraction()
        self:setInteracting(false)
    end
end

function Cat:setInteracting(interacting)
    self.interacting = interacting
    self.speed = (interacting == true) and 0 or 2
end
