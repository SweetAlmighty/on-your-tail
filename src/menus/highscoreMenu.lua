local Menu = require "src/menus/menu"
local menu = nil
local current_time = ""

local function update(dt) menu:update(dt) end
local function input(key) menu:input(key) end
local function type() return GameMenus.HighscoreMenu end
local function draw()
    menu:draw(nil, screen_height - 30)
    love.graphics.print("", (screen_width/2) - 110, (screen_height/2) - 25)
end

local function back() MenuStateMachine:pop() end

local function enter()
    menu = Menu.new("center")
    menu:add_item{ name = "Back", action = back }

    local scores = Data.GetScores()
    for i=1, #scores, 1 do
        local txt = current_time..scores[i][1].." ----------- "..string.format("%.2f", scores[i][2]).."\n"
        current_time = txt
    end
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