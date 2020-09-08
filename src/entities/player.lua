require("src/tools/input")
local Entity = require("src/entities/entity")

local function internal_end_interaction(self)
    self:set_state(EntityStates.Idle)
end

local function internal_start_interaction(self)
    if #self.collisions > 0 then
        local valid = 0

        for _, v in ipairs(self.collisions) do
            if v.current_state ~= EntityStates.Fail then
                valid = valid + 1
                v:start_interaction()
            end
        end

        if valid ~= 0 then self:set_state(EntityStates.Action) end
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
        if #self.collisions == 0 then self:end_interaction() end
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
        if love.keyboard.isDown(InputMap.b) then self:start_interaction() end

        if self.current_state ~= EntityStates.Action then
            if love.keyboard.isDown(InputMap.up) then dy = -self.speed end
            if love.keyboard.isDown(InputMap.down) then dy = self.speed end
            if love.keyboard.isDown(InputMap.right) then dx = self.speed self:set_direction(1) end
            if love.keyboard.isDown(InputMap.left) then dx = -self.speed self:set_direction(-1) end

            if dx ~= 0 or dy ~= 0 then
                self:move(dx, dy)
                self:set_state(EntityStates.Moving)
            else
                self:set_state(EntityStates.Idle)
            end
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
        player.collision_exit = internal_collision_exit
        player.end_interaction = internal_end_interaction
        player.collision_enter = internal_collision_enter
        player.start_interaction = internal_start_interaction

        return player
    end
}