local Menu = require("src/menus/menu")
local FailMenu = { menu = nil }

local function add_score() MenuStateMachine:push(GameMenus.SetScoreMenu) end

local function main_menu()
    StateMachine:pop()
    MenuStateMachine:clear()
end

local function play_again()
    MenuStateMachine:clear()
    StateMachine:pop()
    StateMachine:push(GameStates.Gameplay)
end

function FailMenu:update(dt) self.menu:update(dt) end
function FailMenu:input(key) self.menu:input(key) end
function FailMenu:draw() self.menu:draw() end
function FailMenu:enter()
    self.menu = Menu.new()
    self.menu:set_offset(0, -60)
    self.menu:set_background(0, 0, 319, 239)
    self.menu:add_item({ name = "Play Again", action = play_again })
    self.menu:add_item({ name = "Add Score", action = add_score })
    self.menu:add_item({ name = "Main Menu", action = main_menu })
end

return FailMenu