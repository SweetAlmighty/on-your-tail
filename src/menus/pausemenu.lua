local Menu = require("src/menus/menu")
local PauseMenu = { menu = nil }

local function resume() MenuStateMachine:pop() end
local function options() MenuStateMachine:push(GameMenus.OptionsMenu) end
local function exit()
    MenuStateMachine:pop()
    StateMachine:pop()
end

function PauseMenu:draw() self.menu:draw() end
function PauseMenu:update(dt) self.menu:update(dt) end
function PauseMenu:input(key) self.menu:input(key) end
function PauseMenu:enter()
    self.menu = Menu.new()
    self.menu:set_background(0, 0, 320, 240)
    self.menu:set_start(MenuQuadrants.MiddleMiddle)
    self.menu:add_item({ name = "Resume",  action = resume })
    self.menu:add_item({ name = "Options", action = options })
    self.menu:add_item({ name = "Exit",    action = exit })
end

return PauseMenu