
require("src/backend/require")

InteractButton = class("InteractButton")

function InteractButton:initialize()
    local info = animatFactory:CreateWithCollisions("buttonPress")
    self.animation = info[1].Animations[1]
end

function InteractButton:draw(x, y)
    love.graphics.draw(self.animation.img, self.animation.currentFrame, x, y, nil, nil, nil, 20, 20)
end

function InteractButton:reset() self.animation:reset() end
function InteractButton:update(dt) self.animation:play(dt)end
