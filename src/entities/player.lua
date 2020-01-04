
Player = class('Player', Entity)

local processAnims = function(dt, player)
    if player.interacting == false then
        print(player.direction.x)
        player.currAnim = (player.direction.x == 1) and player.walkRight or player.walkLeft
        player.currAnim:play(dt)
        player.quad = player.currAnim.currentFrame
    else
        -- Petting logic
    end
end

function Player:initialize()
    self.stress = 0
    self.currentCats = 0
    self.delta = { x = 0, y = 0 }

    self.imageWidth = 400
    self.imageHeight = 73
    self.spriteWidth = 40
    self.spriteHeight = 73

    Entity.initialize(self, 50, 150, love.graphics.newQuad(0, 95, self.spriteWidth,
        self.spriteHeight, self.imageWidth, self.imageHeight), "man.png", 120, Types.Player)
        
    self.walkLeft = anim.newAnimat(10)
    self.walkLeft:addSheet(self.image)
    self.walkLeft:addFrame(0,  0, 40, 73)
    self.walkLeft:addFrame(80, 4, 40, 73)
    self.walkLeft:addFrame(0,  0, 40, 73)
    self.walkLeft:addFrame(160, 4, 40, 73)
 
    self.pettingLeft = anim.newAnimat(10)
    self.pettingLeft:addSheet(self.image)
    self.pettingLeft:addFrame(280, 0, 40, 73)
    self.pettingLeft:addFrame(360, 0, 40, 73)

    self.walkRight = anim.newAnimat(10)
    self.walkRight:addSheet(self.image)
    self.walkRight:addFrame(40, 0, 40, 73)
    self.walkRight:addFrame(120, 0, 40, 73)
    self.walkRight:addFrame(40, 0, 40, 73)
    self.walkRight:addFrame(200, 0, 40, 73)
    
    self.pettingRight = anim.newAnimat(10)
    self.pettingRight:addSheet(self.image)
    self.pettingRight:addFrame(240, 0, 40, 73)
    self.pettingRight:addFrame(320, 0, 40, 73)
end

function Player:update(dt)
    Entity.move(self, self.x, self.y)
    if self.interacting == false then
        self.stress = self.stress + (dt * 5)
    end

    speed = (self.interacting) and 0 or 2
    self.speed = (self.interacting) and 0 or 120
    moveCamera = (((self.x + self.width / 2) == playableArea.width) and allowCameraMove)
    
    processAnims(dt, self)
end

function Player:moveX(x)
    allowCameraMove = (x ~= 0)
    self.delta.x = self.speed * x
    Entity.move(self, (self.x + self.delta.x), self.y)
end

function Player:moveY(y)
    self.delta.y = self.speed * y
    Entity.move(self, self.x, (self.y + self.delta.y))
end

function Player:reset()
    self.stress = 0
    Entity.reset(self, 50, 150)
end

function Player:petCats(dt)
    if #self.collisions ~= 0 then
        self:startInteraction();
        for i=1, #self.collisions, 1 do
            self.collisions[i]:startInteraction()
        end
    end

    if self.interacting then
        self.currentCats = #self.collisions
        self.stress = self.stress - (dt * (pettingReduction * self.currentCats))
        if self.stress < 0 then self.stress = 0 end
    end
end

function Player:draw() Entity.draw(self) end
function Player:startInteraction() self.interacting = true end
function Player:finishInteraction() if #self.collisions == 0 then self.interacting = false end end