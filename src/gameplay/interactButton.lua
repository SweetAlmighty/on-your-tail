
require("src/backend/require")

InteractButton = class("InteractButton")

local isGameshell = love.system.getOS() == "Linux"

function InteractButton:initialize()
    self.animations = animateFactory:CreateAnimationSet("buttons")
    self.currentAnimation = isGameshell and self.animations[2][1] or self.animations[1][1]
end

function InteractButton:reset() self.currentAnimation.Reset() end
function InteractButton:update(dt) self.currentAnimation.Update(dt) end
function InteractButton:draw(x, y) self.currentAnimation.Draw(x + 11, y - 11) end
