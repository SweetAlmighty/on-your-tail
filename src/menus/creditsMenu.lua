local Menu = require "src/menus/menu"

local menu = nil
local credits = nil
local credit_text =
    "Programmer: Brian Sweet\n" ..
    "Artist:          Shelby Merrill\n" ..
    "Made With:     LÖVE\n" ..
    "Utilizing:     tick, lovesize,\n" ..
    "                      lume, json.lua"

local function update(dt) menu:update(dt) end
local function input(key) menu:input(key) end
local function type() return GameMenus.CreditsMenu end
local function draw()
    menu:draw(nil, screen_height - 30)
    love.graphics.draw(credits, 34, 85)
end

local function back() MenuStateMachine.Pop() end
local function enter()
    menu = Menu.new("center")
    menu:add_item{ name = "Back", action = back }
    credits = love.graphics.newText(menuFont, credit_text)
end

return {
    new = function()
		return {
            Type = type,
            Draw = draw,
            Input = input,
            Enter = enter,
            Update = update
        }
    end
}