
Player = class('Player', Entity)

moveCamera = false

local setState = function(player, state)
    if player.state ~= state then
        player.state = state
    end
end

local previousState = nil
local processAnims = function(dt, player)
    if previousState ~= player.state then
        Entity.resetAnim(player, player.state)
        previousState = player.state
    end
end

function Player:initialize()
    Entity.initialize(self, e_Types.PLAYER, e_States.IDLE, 120)
    Entity.setPosition(self, {50, 150})

    local info = animateFactory:CreateAnimationSet("character")
    local animats = info[1]

    self.failState = animats[4]

    Entity.setAnims(self, {
        animats[1],
        animats[2],
        animats[3],
        info[1].Colliders
    })

    self.stress = 0
    self.delta = { x = 0, y = 0 }
end

function Player:update(dt)
    Entity.move(self, self.x, self.y)
    if not self.interacting then self.stress = self.stress + (dt * 5) end

    speed = (self.interacting) and 0 or 2
    self.speed = (self.interacting) and 0 or 120
    moveCamera = ((self.x == playableArea.width) and allowCameraMove)

    processAnims(dt, self)

    Entity.update(self, dt)
end

function Player:moveX(x)
    if self.interacting then allowCameraMove = false return end

    allowCameraMove = (x ~= 0)
    setState(self, allowCameraMove and e_States.MOVING or e_States.IDLE)

    if x ~= 0 then self.direction = (x < 0) and Directions.W or Directions.E end

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
    local stressReduction = 0
    if #self.collisions ~= 0 then
        self:startInteraction();
        for i=1, #self.collisions, 1 do
            self.collisions[i]:startInteraction()
            local amount = self.collisions[i].stressReduction
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