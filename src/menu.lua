
local class = require("src/lib/middleclass")

Menu = class('Menu')

function Menu:initialize()
    self.index = 0
    self.options = {}
end

function Menu:GetIndex() return self.index end
function Menu:Up() self.index = self.index - 1 if self.index < 0 then self.index = 0 end end
function Menu:Down() self.index = self.index + 1 if self.index > 1 then self.index = 1 end end