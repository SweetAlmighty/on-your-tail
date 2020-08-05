require("src/backend/require")

State = class("State")

function State:exit() end
function State:enter() end
function State:pause() end
function State:unpause() end
function State:update(dt) end
function State:initialize() self.type = nil end