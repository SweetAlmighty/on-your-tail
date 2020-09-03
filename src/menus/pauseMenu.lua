local Menu = require "src/menus/menu"
local menu = nil

local function draw() menu:draw() end
local function update(dt) menu:update(dt) end
local function input(key) menu:input(key) end
local function type() return GameMenus.PauseMenu end

local function resume() MenuStateMachine.Pop() end
local function back() MenuStateMachine.Clear() end
local function options() MenuStateMachine.Push(GameMenus.OptionsMenu) end

local function enter()
    menu = Menu.new("center")
    menu:add_item{ name = "Resume",  action = resume }
    menu:add_item{ name = "Options", action = options }
    menu:add_item{ name = "Back",    action = back }
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