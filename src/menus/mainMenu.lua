local Menu = require "src/menus/menu"
local menu = nil

local function draw() menu:draw() end
local function update(dt) menu:update(dt) end
local function input(key) menu:input(key) end
local function type() return GameMenus.MainMenu end

local function extras() MenuStateMachine:push(GameMenus.ExtrasMenu) end
local function credits() MenuStateMachine:push(GameMenus.CreditsMenu) end
local function quit() love.event.quit() end

local function start_game()
    StateMachine:push(GameStates.Gameplay)
    MenuStateMachine:pop()
end

local function enter()
    menu = Menu.new()
    menu:set_offset(0, -45)
    menu:set_background(34, 85, 248, 150)
    menu:set_start(MenuQuadrants.BottomMiddle)
    menu:add_item{ name = "Start Game", action = start_game }
    menu:add_item{ name = "Extras", action = extras }
    menu:add_item{ name = "Credits", action = credits }
    menu:add_item{ name = "Quit", action = quit }
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