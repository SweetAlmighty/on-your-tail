require("src/tools/input")
local Entity = require("src/entities/entity")

local current_delta = 0
local current_points = 0

local function internal_end_interaction(self)
    points = points + current_points
    current_delta = 0
    current_points = 0
    self:set_state(EntityStates.Idle)

    for _, v in ipairs(self.collisions) do
        if v.current_state ~= EntityStates.Fail then
            v:end_interaction()
        end
    end
end

local function internal_interact(self, dt)
    if #self.collisions > 0 then
        local valid = 0

        current_delta = current_delta - (dt * 10)
        local value = 1 - math.fmod(current_delta, 1)
        print(value)

        for _, v in ipairs(self.collisions) do
            if v.current_state ~= EntityStates.Fail then
                valid = valid + 1
                v:interact()

                if value < 0.1 or value == 1 then
                    current_points = current_points + 1
                end
            end
        end

        if valid ~= 0 then
            self:set_state(EntityStates.Action)
        end
    end
end

local function internal_collision_enter(self, other)
    if self:internal_collision_enter(other) then
        if other.type == EntityTypes.Enemy then
            self.start_fail_state = true
            self:set_state(EntityStates.Fail)
        end
    end
end

local function internal_collision_exit(self, other)
    if self:internal_collision_exit(other) then
        if #self.collisions == 0 and self.state == EntityStates.Action then
            self:end_interaction()
        end
    end
end

local function internal_update(self, dt)
    local dx, dy = 0, 0

    if self.current_state == EntityStates.Fail then
        if self.start_fail_state then
            self.start_fail_time = self.start_fail_time + dt
            if self.start_fail_time > self.fail_time then
                self.start_fail_state = false
                MenuStateMachine:push(GameMenus.FailMenu)
            end
        end
    else
        if love.keyboard.isDown(InputMap.b) then self:interact(dt) end

        if love.keyboard.isDown(InputMap.b) then self:interact(dt)
        elseif self.current_state == EntityStates.Action then self:end_interaction() end

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

    self:internal_update(dt)
end

return {
    new = function()
        local player = Entity.new(EntityTypes.Player)

        player.speed = 2
        player.fail_time = 1.5
        player.start_fail_time = 0
        player.start_fail_state = false

        player.update = internal_update
        player.interact = internal_interact
        player.collision_exit = internal_collision_exit
        player.end_interaction = internal_end_interaction
        player.collision_enter = internal_collision_enter

        return player
    end
}