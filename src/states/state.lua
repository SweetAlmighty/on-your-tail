require("src/backend/require")

State = class("State")

function State:exit() end
function State:enter() end
function State:cleanup() end
function State:initialize() self.type = nil end