local Menu = require "src/menus/menu"

local menu = nil
local is_gameshell = love.system.getOS() == "Linux"

local function draw() menu:draw() end
local function update(dt) menu:update(dt) end
local function input(key) menu:input(key) end
local function type() return GameMenus.ExtrasMenu end

local function back() MenuStateMachine.Pop() end
local function options() MenuStateMachine.Push(GameMenus.OptionsMenu) end
local function scores() MenuStateMachine.Push(GameMenus.HighscoreMenu) end
local function controls() MenuStateMachine.Push(GameMenus.ControlsMenu) end

local function enter()
    menu = Menu.new("center")
    if not is_gameshell then menu:add_item{ name = "Options", action = options } end
    menu:add_item{ name = "Controls", action = controls }
    menu:add_item{ name = "Scores", action = scores }
    menu:add_item{ name = "Back", action = back }
end

return {
    new = function()
		return {
            Draw = draw,
            Type = type,
            Input = input,
            Enter = enter,
            Update = update
        }
    end
}