local Cat = require("src/entities/npc"):extend()

function Cat:new(type)
    Cat.super.new(self, type)

    self.petting_limit = 30
    self.current_limit = self.petting_limit
end

function Cat:update(dt)
    self:npc_update(dt)
end

function Cat:action_update(dt)
    self.current_limit = self.current_limit - (dt * 10)
    if self.current_limit < 0 then self:end_interaction() end
end

function Cat:end_interaction()
    self.current_limit = 0
    self:set_state(EntityStates.Fail)
    self:set_destination(-100, self.position.y)
end

return Cat