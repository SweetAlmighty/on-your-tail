local Menu = require("src/menus/menu")
local MainMenu = { menu = nil }

local function extras() MenuStateMachine:push(GameMenus.ExtrasMenu) end
local function credits() MenuStateMachine:push(GameMenus.CreditsMenu) end
local function quit() love.event.quit() end
local function start_game()
    StateMachine:push(GameStates.Gameplay)
    MenuStateMachine:pop()
end

function MainMenu:draw() self.menu:draw() end
function MainMenu:update(dt) self.menu:update(dt) end
function MainMenu:input(key) self.menu:input(key) end
function MainMenu:enter()
    self.menu = Menu.new()
    self.menu:set_offset(0, -45)
    self.menu:set_background(30, 85, 260, 150)
    self.menu:set_start(MenuQuadrants.BottomMiddle)
    self.menu:add_item({ name = "Start Game", action = start_game })
    self.menu:add_item({ name = "Extras", action = extras })
    self.menu:add_item({ name = "Credits", action = credits })
    self.menu:add_item({ name = "Quit", action = quit })
end


return MainMenu