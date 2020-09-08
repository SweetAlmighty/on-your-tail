local NPC = require("src/entities/npc")

local function internal_update(self, dt)
    self:npc_update(dt)
end

local function internal_action_update(self, dt)
    self.current_limit = self.current_limit - (dt * 10)
    if self.current_limit < 0 then
        self.current_limit = 0
        self:set_destination(-100, self.position.y)
        self:set_state(EntityStates.Fail)
    end
end

return {
    new = function(type)
        local cat = NPC.new(type)

        cat.petting_limit = 30
        cat.current_limit = cat.petting_limit

        cat.update = internal_update
        cat.action_update = internal_action_update

        return cat
    end
}