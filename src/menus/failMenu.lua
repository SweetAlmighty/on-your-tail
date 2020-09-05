local Menu = require "src/menus/menu"
local menu = nil

local function update(dt) menu:update(dt) end
local function input(key) menu:input(key) end
local function type() return GameMenus.FailMenu end
local function draw() menu:draw() end

local function play_again()
    MenuStateMachine:clear()
    MenuStateMachine:push(GameMenus.Gameplay)
end
local function main_menu() MenuStateMachine:clear() end
local function add_score() MenuStateMachine:push(GameMenus.SetScoreMenu) end

local function enter()
    menu = Menu.new()
    menu:add_item({ name = "Play Again", action = play_again })
    menu:add_item({ name = "Add Score", action = add_score })
    menu:add_item({ name = "Main Menu", action = main_menu })
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