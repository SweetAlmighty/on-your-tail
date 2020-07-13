
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
        animats[4],
        info[1].Colliders
    })

    self.stress = 0
    self.delta = { x = 0, y = 0 }
end

function Player:update(dt)
    if not self.interacting and self.state ~= e_States.FAIL then
        self.stress = self.stress + (dt * 7)
    end

    speed = (self.interacting) and 0 or 2
    self.speed = (self.interacting) and 0 or 120
    moveCamera = ((self.x == playableArea.width) and allowCameraMove)

    processAnims(dt, self)

    Entity.update(self, dt)
end 

function Player:move(x, y)
    if self.state == e_States.FAIL then return end

    if self.interacting then
        allowCameraMove = false
        return
    end
    
    allowCameraMove = (x ~= 0)
    if x ~= 0 then self.direction = (x < 0) and Directions.W or Directions.E end

    local moving = x ~= 0 or y ~= 0
    setState(self, moving and e_States.MOVING or e_States.IDLE)

    self.delta.x = self.speed * x
    self.delta.y = self.speed * y
    
    if moving then Entity.move(self, self.x + self.delta.x, self.y + self.delta.y) end
end

function Player:reset()
    self.stress = 0
    setState(self, e_States.IDLE)
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

function Player:setFailState()
    allowCameraMove = false
    setState(self, e_States.FAIL)
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