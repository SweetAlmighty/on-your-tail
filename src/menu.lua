
require "src/state"
local class = require("src/lib/middleclass")

Menu = class('Menu', State)

local halfWidth = 0

States = {
    MainMenu = 0,
    Gameplay = 1,
    PauseMenu = 2,
    FailState = 3,
}

function Menu:initialize()
    self.index = 0
    self.title = nil
    self.options = {}
    self.clearColor = {}
    self.startWidth = 0
    self.startHeight = 0
    halfWidth = screenWidth/2
end

function Menu:draw()
    love.graphics.clear(self.clearColor.r, self.clearColor.g, self.clearColor.b, self.clearColor.a)
    love.graphics.draw(self.title, 33, 40, nil, nil, nil, nil, nil)

    love.graphics.setColor(0, 0, 0, 1)
    for i=1, #self.options, 1 do
        self.startWidth = halfWidth - (self.options[i]:getWidth()/2)
        love.graphics.draw(self.options[i], self.startWidth, self.startHeight + ((i-1) * 40))
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.pointer, halfWidth - self.pointer:getWidth() * 2,
        (self.startHeight + 5 + (self.index * 40)), nil, nil, nil, nil, nil)
end

function Menu:GetIndex() return self.index end
function Menu:Up() self.index = self.index - 1 if self.index < 0 then self.index = 0 end end
function Menu:Down() self.index = self.index + 1 if self.index > 1 then self.index = 1 end end