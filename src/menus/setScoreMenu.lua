local Menu = require "src/menus/menu"

local index = 1
local name = ""
local menu = nil
local curr_x = 1
local curr_y = 1
local letters = {}
local current_time = { "", " ----------- ", "", "\n" }

local function get_letter_index(value)
    for i=1, #letters, 1 do if letters[i] == value then return i end end
end

local function update_name()
    name[curr_x] = letters[curr_y]
    current_time[1] = table.concat(name)
    current_time[3] = string.format("%.2f", currTime)
    name = table.concat(current_time)
end

local function up()
    if index == 1 then
        curr_y = (curr_y - 1 < 1) and 26 or curr_y - 1
        update_name()
    end
end

local function down()
    if index == 1 then
        curr_y = (curr_y + 1 > 26) and 1 or curr_y + 1
        update_name()
    end
end

local function left()
    if index == 1 then
        local x = curr_x - 1
        if x < 1 then x = 1 else
            x = curr_x - 1
        end
        curr_x = x
        curr_y = get_letter_index(name[curr_x])
    end
end

local function right()
    if index == 1 then
        local x = curr_x + 1
        if x > 3 then x = 3 else
            x = curr_x + 1
        end
        curr_x = x
        curr_y = get_letter_index(name[curr_x])
    end
end

local function update(dt) menu:update(dt) end
local function type() return GameMenus.SetScoreMenu end
local function draw()
    menu:draw()
    love.graphics.print("_", (screen_width / 2) - (127 - (12 * curr_x)), (screen_height / 2.5) + 8)
end
local function input(key)
    if index == 1 then
        if key == InputMap.left then left()
        elseif key == InputMap.up then up()
        elseif key == InputMap.right then right()
        elseif key == InputMap.down then down()
        elseif key == InputMap.a then index = 2
        end
    else menu:input(key) end
end

local function play_again() if index == 2 then MenuStateMachine:pop() end end
local function main_menu() if index == 2 then MenuStateMachine:clear() end end

local function enter()
    name = table.concat(name).." ----------- "..string.format("%.2f", currTime).."\n"
    for i=65, 90, 1 do table.insert(letters, string.char(i)) end

    menu = Menu.new()
    menu:add_item{ name = "Play Again", action = play_again }
    menu:add_item{ name = "Main Menu", action = main_menu }
end

return {
    new = function()
		return {
            Type = type,
            Draw = draw,
            Enter = enter,
            Input = input,
            Update = update
        }
    end
}