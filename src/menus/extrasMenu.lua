local Menu = require "src/menus/menu"
local ExtrasMenu = { menu = nil, is_gameshell = love.system.getOS() == "Linux" }

local function back() MenuStateMachine:pop() end
local function options() MenuStateMachine:push(GameMenus.OptionsMenu) end
local function scores() MenuStateMachine:push(GameMenus.HighscoreMenu) end
local function controls() MenuStateMachine:push(GameMenus.ControlsMenu) end

function ExtrasMenu:draw() self.menu:draw() end
function ExtrasMenu:update(dt) self.menu:update(dt) end
function ExtrasMenu:input(key) self.menu:input(key) end
function ExtrasMenu:type() return GameMenus.ExtrasMenu end
function ExtrasMenu:enter()
    if self.menu == nil then
        self.menu = Menu.new()

        if not self.is_gameshell then self.menu:add_item{ name = "Options", action = options } end
        self.menu:add_item{ name = "Controls", action = controls }
        self.menu:add_item{ name = "Scores", action = scores }
        self.menu:add_item{ name = "Back", action = back }
    end

    self.menu:set_offset(0, -45)
end

return ExtrasMenu