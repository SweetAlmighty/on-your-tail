
require "src/entity"
require "src/interactButton"

local lume = require("src/lib/lume")
local animat = require("src/lib/animat")
local class = require("src/lib/middleclass")

Cat = class("Cat", Entity)

local time = 0
local spriteWidth = 20
local spriteHeight = 20

local s_SITTING, s_WALKING = 1, 2

local randomPosition, processMovement, processAnims

function Cat:initialize()
    self.limit = 2.5
    self.button = InteractButton:new()

    self.currAnim = { }
    self.state = s_SITTING

    self.animSit = animat.newAnimat(15)
    self.animWalk = animat.newAnimat(15)

    local _x, _y = randomPosition()
    Entity.initialize(self, _x, _y, love.graphics.newQuad(0, 0, spriteWidth, spriteHeight, 150, 120), 
        "cat-sprites.png", 1, Types.Cat)

    self.animSit:addSheet(self.image)
    self.animWalk:addSheet(self.image)

    self:setIndex(lume.randomchoice({1, 2, 3, 4, 5, 6}))
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
        self.interacting = true
    end
    
    if self.interacting == true then
        self.button:update(dt)
        self.limit = self.limit - (dt * 10)

        if self.limit < 0 then
            self.limit = 0
            Cat.finishInteraction(self)
        end
    end
end

function Cat:setIndex(index)
    self.index = index

    local currY = ((index - 1) * 20)

    self.animWalk:addFrame(0,  currY, 20, 20)
    self.animWalk:addFrame(40, currY, 20, 20)
    self.animWalk:addFrame(0,  currY, 20, 20)
    self.animWalk:addFrame(80, currY, 21, 20)

    self.animSit:addFrame(20,  currY, 20, 20)
    self.animSit:addFrame(60,  currY, 20, 20)
    self.animSit:addFrame(20,  currY, 20, 20)
    self.animSit:addFrame(101, currY, 21, 20)
end

function Cat:finishInteraction()
    if self.interacting == true then
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

randomPosition = function()
    return math.random(scene.width - spriteWidth, scene.width * 2), 
        math.random(scene.playableArea.y - spriteHeight, scene.playableArea.height)
end

processMovement = function(cat)
    local _x = (cat.x + (cat.speed * cat.direction.x))
    local _y = (cat.y + (cat.speed * cat.direction.y))
    if moveCamera == false then
        if cat.state == s_SITTING then
            _x, _y = cat.x, cat.y
        end
    else
        if cat.state == s_SITTING then
            _x, _y = cat.x - scene.speed, cat.y
        end
    end

    Entity.move(cat, _x, _y)

    if cat.x < (-cat.width) then
        cat:reset()
    end
end

processAnims = function(dt, cat)
    time = time + dt
    if time > 1 then
        time = 0
        cat.state = lume.randomchoice({s_SITTING, s_WALKING})
        if cat.state == s_WALKING then
            cat.direction = lume.randomchoice(Directions)
        end
    end

    if cat.state == s_WALKING and cat.interacting == false then
        cat.currAnim = (cat.direction.x == 1) and cat.animSit or cat.animWalk
        cat.currAnim:play(dt)
        cat.quad = cat.currAnim.currentFrame
    else
        local _x = (cat.direction.x == 1) and 136 or 122
        cat.currAnim = (cat.direction.x == 1) and cat.animWalk or cat.animSit
        cat.currAnim:reset()
        cat.quad = love.graphics.newQuad(_x, 20 * (cat.index - 1), 14, 19, 150, 120)
    end
end
