
require("src/backend/require")

InteractButton = class("InteractButton")

function InteractButton:initialize()
    local info = animateFactory:CreateAnimationSet("buttonPress")
    self.animation = info[1][1]
end

function InteractButton:reset() self.animation.Reset() end
function InteractButton:update(dt) self.animation.Update(dt) end
function InteractButton:draw(x, y) self.animation.Draw(x, y) end
