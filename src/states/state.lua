require("src/backend/require")

State = class("State")
function State:initialize() self.type = nil end
function State:cleanup() end