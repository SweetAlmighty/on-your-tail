
require "src/entity"
require "src/interactButton"
local lume = require("src/lib/lume")
local animat = require("src/lib/animat")
local class = require("src/lib/middleclass")

Cat = class("Cat", Entity)

local spriteWidth = 20
local spriteHeight = 20

local s_SITTING, s_WALKING = 1, 2

function Cat:initialize()
    self.affectionLimit = 2.5
    self.button = InteractButton:new()

    local _x, _y = Cat:randomPosition()

    Entity.initialize(self, _x, _y, love.graphics.newQuad(0, 0, spriteWidth, spriteHeight, 150, 120), 
        "cat-sprites.png", 1, Types.Cat)

    self.animator = animat.newAnimat(15)
    self.animator:addSheet(self.image)


    self.animatorTwo = animat.newAnimat(15)
    self.animatorTwo:addSheet(self.image)

    self.currentState = s_SITTING
end

function Cat:draw()
    Entity.draw(self);
    if self.interactable then
        self.button:draw(self.x + 20, self.y)
    end
end

local time = 0
function Cat:update(dt)
    
    -- Anim state
    time = time + dt
    if time > 1 then
        time = 0
        self.currentState = lume.randomchoice({s_SITTING, s_WALKING})
        if self.currentState == s_WALKING then
            self.direction = lume.randomchoice(Directions)
        end
    end

    if self.currentState == s_WALKING and self.interacting == false then
        if self.direction.x  == 1 then
            self.animatorTwo:play(dt)
            self.quad = self.animatorTwo.currentFrame
        else
            self.animator:play(dt)
            self.quad = self.animator.currentFrame
        end
        
    else
        if self.direction.x == 1 then
            self.animator:reset()
            self.quad = love.graphics.newQuad(136, 20 * (self.name - 1), 14, 19, 150, 120)
        else
            self.animatorTwo:reset()
            self.quad = love.graphics.newQuad(122, 20 * (self.name - 1), 14, 19, 150, 120)
        end
    end
    --

    if player.interacting and self.interacting then
        self.button:update(dt)
    else
        local _x = (self.x + (self.speed * self.direction.x))
        local _y = (self.y + (self.speed * self.direction.y))
        if moveCamera == false then
            if self.currentState == s_SITTING then
                _x, _y = self.x, self.y
            end
        else
            if self.currentState == s_SITTING then
                _x, _y = self.x - scene.speed, self.y
            end
        end

        Entity.move(self, _x, _y)

        self.x = _x

        if self.x < (-self.width) then
            Cat.reset(self)
        end
    end
end

function Cat:randomPosition()
    return math.random(scene.width - spriteWidth, scene.width * 2), 
        math.random(scene.playableArea.y - spriteHeight, scene.playableArea.height)
end

function Cat:reset()
    self.affectionLimit = 2.5
    Entity.reset(self, Cat.randomPosition(self))
end

function Cat:setIndex(index)
    self.name = index

    local currY = ((index - 1) * 20)

    self.animator:addFrame(0,  currY, 20, 20)
    self.animator:addFrame(40, currY, 20, 20)
    self.animator:addFrame(0,  currY, 20, 20)
    self.animator:addFrame(80, currY, 21, 20)

    self.animatorTwo:addFrame(20,  currY, 20, 20)
    self.animatorTwo:addFrame(60,  currY, 20, 20)
    self.animatorTwo:addFrame(20,  currY, 20, 20)
    self.animatorTwo:addFrame(101, currY, 21, 20)
end

-- Sets whether the cat is currently interacting
function Cat:setInteracting(interacting)
    self.interacting = interacting
    self.speed = (interacting == true) and 0 or 2
end

-- Handles interaction
function Cat:interact(dt)
    if self.interactable and self.interacting == false then
        self.interacting = true
    end
    
    if self.interacting == true then
        self.button:update(dt)
        self.affectionLimit = self.affectionLimit - (dt * 10)

        if self.affectionLimit < 0 then
            self.affectionLimit = 0
            Cat.finishInteraction(self)
        end
    end
end

-- Will stop an interaction if one is currently in progress
function Cat:finishInteraction()
    if self.interacting == true then
        self.button:reset()
        self.interactable = false;
        player:finishInteraction()
        self:setInteracting(false)
    end
end