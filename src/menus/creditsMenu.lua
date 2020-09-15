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
    love.graphics.draw(self.credits, 30, 85)
end

function CreditsMenu:enter()
    if self.menu == nil then
        self.menu = Menu.new()
        self.menu:add_item({ name = "Back", action = back })
    end

    if self.credits == nil then
        self.credits = love.graphics.newText(menuFont, text)
    end

    self.menu:set_offset(0, 50)
end

return CreditsMenu