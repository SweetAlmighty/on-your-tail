
Player = class('Player', Entity)

moveCamera = false

local setState = function(player, state)
    if player.state ~= state then
        player.state = state
        Entity.setState(player, player.state)
    end
end

local previousState = nil
local processAnims = function(dt, player)
    if previousState ~= player.state then
        Entity.resetAnim(player, player.state)
        previousState = player.state
    end

    player.currentAnim:play(dt)
    player.quad = player.currentAnim.currentFrame
end

function Player:initialize()
    Entity.initialize(self, Types.PLAYER, 120)

    Entity.setState(self, e_States.IDLE)
    Entity.setPosition(self, {50, 150})
    Entity.setDirection(self, Directions.E)
    Entity.setImageDefaults(self, 120, 146, 40, 73)
    Entity.setAnims(self, animatFactory:create("player"))

    self.stress = 0
    self.delta = { x = 0, y = 0 }
end

function Player:update(dt)
    Entity.move(self, self.x, self.y)
    if not self.interacting then
        self.stress = self.stress + (dt * 5)
    end

    speed = (self.interacting) and 0 or 2
    self.speed = (self.interacting) and 0 or 120
    moveCamera = (((self.x + self.width / 2) == playableArea.width) and allowCameraMove)

    processAnims(dt, self)
end

function Player:moveX(x)
    if self.interacting then
        allowCameraMove = false
        return 
    end

    allowCameraMove = (x ~= 0)
    setState(self, allowCameraMove and e_States.MOVING or e_States.IDLE)

    if x ~= 0 then
        self.direction = (x < 0) and Directions.W or Directions.E
    end

    self.delta.x = self.speed * x
    Entity.move(self, (self.x + self.delta.x), self.y)
end

function Player:moveY(y)
    if self.interacting then return end

    setState(self, (y ~= 0) and e_States.MOVING or e_States.IDLE)
    self.delta.y = self.speed * y
    Entity.move(self, self.x, (self.y + self.delta.y))
end

function Player:reset()
    self.stress = 0
    Entity.reset(self, { 50, 150 })
end

function Player:petCats(dt)
    local amount = 0
    local stressReduction = 0
    if #self.collisions ~= 0 then
        self:startInteraction();
        for i=1, #self.collisions, 1 do
            self.collisions[i]:startInteraction()
            amount = self.collisions[i].stressReduction
            stressReduction = stressReduction + (dt * amount)
        end
    end

    if self.interacting then
        self.stress = self.stress - stressReduction
        if self.stress < 0 then self.stress = 0 end
    end
end

function Player:startInteraction()
    self.interacting = true
    setState(player, e_States.INTERACT)
end

function Player:finishInteraction()
    if #self.collisions == 0 then
        self.interacting = false
        setState(player, e_States.IDLE)
    end
end

function Player:draw() Entity.draw(self) end