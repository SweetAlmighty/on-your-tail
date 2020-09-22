local Menu = require("src/menus/menu")
local CreditsMenu = { menu = nil, credits = nil }

local text = "Programmer:\tBrian Sweet\n" ..
            "Artist:\t\t\t Shelby Merrill\n" ..
            "Made With:\t\tLÖVE\n" ..
            "Utilizing:\t\tlovesize, boon,\n" ..
            "\t\t\t\t\t\t tick, json.lua,\n" ..
            "\t\t\t\t\t\t\t\t\tand lume\n"

local function back() MenuStateMachine:pop() end

function CreditsMenu:update(dt) self.menu:update(dt) end
function CreditsMenu:input(key) self.menu:input(key) end

function CreditsMenu:draw()
    self.menu:draw()
    love.graphics.draw(self.credits, 29, 85)
end

function CreditsMenu:enter()
    self.menu = Menu.new()
    self.menu:set_offset(0, 50)
    self.menu:set_background(28, 85, 262, 150)
    self.menu:add_item({ name = "Back", action = back })

    if self.credits == nil then
        self.credits = love.graphics.newText(menuFont, text)
    end
end

return CreditsMenu