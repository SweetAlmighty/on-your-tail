local Menu = require "src/menus/menu"
local FailMenu = { menu = nil }

local function main_menu() MenuStateMachine:clear() end
local function add_score() MenuStateMachine:push(GameMenus.SetScoreMenu) end
local function play_again()
    MenuStateMachine:clear()
    MenuStateMachine:push(GameMenus.Gameplay)
end

function FailMenu:update(dt) self.menu:update(dt) end
function FailMenu:input(key) self.menu:input(key) end
function FailMenu:type() return GameMenus.FailMenu end
function FailMenu:draw() self.menu:draw() end
function FailMenu:enter()
    if self.menu == nil then
        self.menu = Menu.new()
        self.menu:add_item({ name = "Play Again", action = play_again })
        self.menu:add_item({ name = "Add Score", action = add_score })
        self.menu:add_item({ name = "Main Menu", action = main_menu })
    end
end

return FailMenu