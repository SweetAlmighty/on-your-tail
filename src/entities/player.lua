require("src/tools/input")
local Player = require("src/entities/entity"):extend()

function Player:new()
    Player.super.new(self, EntityTypes.Player)

    self.speed = 2
    self.fail_time = 1.5
    self.start_fail_time = 0
    self.interacting = false
    self.start_fail_state = false
    self.position = { x = playable_area.x, y = 180 }
end

function Player:collision_enter(other)
    if Player.super.collision_enter(self, other) then
        if other.type == EntityTypes.Enemy then
            moving = false
            self.start_fail_state = true
            self:set_state(EntityStates.Fail)
        end
    end
end

function Player:collision_exit(other)
    if Player.super.collision_exit(self, other) then
        if #self.collisions == 0 and self.state == EntityStates.Action then
            self:end_interaction()
        end
    end
end

function Player:end_interaction(dt)
    current_points = 0
    self.interacting = false
    self:set_state(EntityStates.Idle)
    for _, v in ipairs(self.collisions) do
        if v.current_state ~= EntityStates.Fail then
            v:end_interaction()
        end
    end
end

function Player:interact(dt)
    local valid = 0
    if #self.collisions > 0 then
        for _, v in ipairs(self.collisions) do
            if v.current_state ~= EntityStates.Fail then
                valid = valid + 1
                v:interact()
            end
        end

        points = points + valid
    end

    local should_interact = (valid ~= 0)

    if should_interact and not self.interacting then
        self.interacting = true
        self:set_state(EntityStates.Action)
    elseif not should_interact and self.interacting then
        self.interacting = false
        self:set_state(EntityStates.Idle)
    end
end

function Player:update(dt)
    local dx, dy = 0, 0

    if self.current_state == EntityStates.Fail then
        if self.start_fail_state then
            self.start_fail_time = self.start_fail_time + dt
            if self.start_fail_time > self.fail_time then
                background_music:pause()
                self.start_fail_state = false
                MenuStateMachine:push(GameMenus.FailMenu)
            end
        end
    else
        if love.keyboard.isDown(InputMap.b) then
            self:interact(dt)
        elseif self.interacting then
            self:end_interaction()
        end

        if self.current_state ~= EntityStates.Action then
            if love.keyboard.isDown(InputMap.up) then dy = -self.speed
            elseif love.keyboard.isDown(InputMap.down) then dy = self.speed end

            if love.keyboard.isDown(InputMap.right) then
                dx = self.speed
                self:set_direction(1)
            elseif love.keyboard.isDown(InputMap.left) then
                dx = -self.speed
                self:set_direction(-1)
            end

            local shouldMove = dx ~= 0 or dy ~= 0
            if shouldMove then self:move(dx, dy) end
            self:set_state(shouldMove and EntityStates.Moving or EntityStates.Idle)
        end

        local pos = self.position
        moving = (pos.x == screen_width/2 and dx ~= 0)
    end

    Player.super.update(self, dt)
end

return Player