
require "src/interactButton"
require "src/entities/entity"

Cat = class("Cat", Entity)

local time = 0
local shouldUpdate = false
local s_SITTING, s_WALKING = 1, 2

local processMovement = function(cat)
    local _x = (cat.x + (cat.speed * cat.direction.x))
    local _y = (cat.y + (cat.speed * cat.direction.y))

    if cat.state == s_SITTING then
        -- Maintain sitting position
        _x = moveCamera and (cat.x - speed) or (cat.x)
        _y = cat.y
    else
        -- Move relative to the player, if the camera is moving
        if moveCamera then
            local deltaX = (cat.direction.x * player.delta.x)
            if cat.direction.x ~= -1 then deltaX = -player.delta.x end
            _x = _x + deltaX
        end
    end

    Entity.move(cat, _x, _y)
    if cat.x < (-cat.width) then
        if cat.type == Types.Kitten then
            StateMachine:current():removeKitten(cat)
        else
            cat:reset()
        end
    end
end

local beginOffscreenTransition = function (cat)
    cat.limit = -1
    cat.state = s_WALKING
    cat.currAnim = cat.walkLeft
    cat.direction = Directions[7]
end

local beingPettingTransition = function (cat)
    cat.state = s_SITTING

    local _, y, w, h = cat.sittingQuad:getViewport()
    local x = (cat.direction.x == 1) and cat.sittingX.right or cat.sittingX.left
    cat.quad = love.graphics.newQuad(x, y, w, h, cat.imageWidth, cat.imageHeight)
end

local processAnims = function(dt, cat)
    if cat.interacting == false then
        time = time + dt

        if time > 1 and cat.limit > 0 then
            time = 0
            cat.state = lume.randomchoice({s_SITTING, s_WALKING})
            if cat.state == s_WALKING then cat.direction = lume.randomchoice(Directions) end
            shouldUpdate = true
        end

        if shouldUpdate then
            if cat.state == s_WALKING then
                -- Walk
                cat.currAnim = (cat.direction.x == 1) and cat.walkRight or cat.walkLeft
            else
                -- Sit
                local _, y, w, h = cat.sittingQuad:getViewport()
                local x = (cat.direction.x == 1) and cat.sittingX.right or cat.sittingX.left
                cat.quad = love.graphics.newQuad(x, y, w, h, cat.imageWidth, cat.imageHeight)
            end
            shouldUpdate = false
        end

        if cat.state == s_WALKING then
            cat.currAnim:play(dt)
            cat.quad = cat.currAnim.currentFrame
        end
    end
end

function randomPosition(cat)
    return love.math.random(screenWidth - cat.spriteWidth, screenWidth * 2),
        love.math.random(playableArea.y - cat.spriteHeight, playableArea.height)
end

function Cat:initialize()
    self.limit = catLimit
    self.currAnim = { }
    self.state = s_SITTING
    self.button = InteractButton:new()

    self.imageWidth = 150
    self.imageHeight = 160
    self.spriteWidth = 20
    self.spriteHeight = 20

    self.index = love.math.random(1, self.imageHeight/self.spriteHeight)

    local _x, _y = randomPosition(self)
    local currY = ((self.index - 1) * self.spriteHeight)
    Entity.initialize(self, _x, _y, love.graphics.newQuad(0, currY, self.spriteWidth,
        self.spriteHeight, self.imageWidth, self.imageHeight), "cats.png", 1, Types.Cat)

    self.sittingX = { left = 122, right = 136 }
    self.sittingQuad = love.graphics.newQuad(0, self.spriteHeight * (self.index - 1), 14, 19,
        self.imageWidth, self.imageHeight)

    self.walkLeft = anim.newAnimat(15)
    self.walkLeft:addSheet(self.image)
    self.walkLeft:addFrame(0,  currY, 20, 20)
    self.walkLeft:addFrame(40, currY, 20, 20)
    self.walkLeft:addFrame(0,  currY, 20, 20)
    self.walkLeft:addFrame(80, currY, 21, 20)

    self.walkRight = anim.newAnimat(15)
    self.walkRight:addSheet(self.image)
    self.walkRight:addFrame(20,  currY, 20, 20)
    self.walkRight:addFrame(60,  currY, 20, 20)
    self.walkRight:addFrame(20,  currY, 20, 20)
    self.walkRight:addFrame(101, currY, 21, 20)
end

function Cat:draw()
    Entity.draw(self)
    if self.interactable and self.limit > 0 then
        self.button:draw(self.x + 20, self.y)
    end
end

function Cat:reset()
    self.limit = catLimit
    Entity.reset(self, randomPosition(self))
end

function Cat:update(dt)
    if self.interacting then
        self.button:update(dt)
        self.limit = self.limit - (dt * 10)
        if self.limit < 0 and self.interacting then
            self.limit = 0
            self:finishInteraction()
            self.interactable = false
        end
    else processMovement(self) end

    processAnims(dt, self)
end

function Cat:startInteraction()
    self.interacting = true
    beingPettingTransition(self)
end

function Cat:finishInteraction()
    self.button:reset()
    self.interacting = false
    self.interactable = false
    beginOffscreenTransition(self)
end