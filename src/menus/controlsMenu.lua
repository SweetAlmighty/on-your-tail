local Menu = require "src/menus/menu"

local menu = nil
local quad = nil
local pet_text = nil
local move_text = nil
local pause_text = nil
local accept_text = nil
local control_font = nil
local image = Resources.LoadImage("controls")
local is_gameshell = love.system.getOS() == "Linux"
local pc = love.graphics.newQuad(145, 0, 157, 89, 304, 144)
local gameshell = love.graphics.newQuad(0, 0, 144, 144, 304, 144)
local pause = { x = is_gameshell and 15 or 45, y = is_gameshell and 112 or 90 }
local pet = { x = is_gameshell and 225 or 60, y = is_gameshell and 150 or 173 }
local move = { x = is_gameshell and 25 or 245, y = is_gameshell and 150 or 118 }
local start_pos = { x = is_gameshell and 80 or 86, y = is_gameshell and 64 or 96 }
local accept = { x = is_gameshell and 225 or 40, y = is_gameshell and 180 or 130 }

local function update(dt) menu:update(dt) end
local function input(key) menu:input(key) end
local function type() return GameMenus.ControlsMenu end
local function draw()
    menu:draw(nil, screen_height - 30)
    love.graphics.draw(image, quad, start_pos.x, start_pos.y)
    love.graphics.draw(pause_text, pause.x, pause.y)
    love.graphics.draw(move_text, move.x, move.y)
    love.graphics.draw(pet_text, pet.x, pet.y)
    love.graphics.draw(accept_text, accept.x, accept.y)
end

local function back() MenuStateMachine:pop() end

local function enter()
    menu = Menu.new("center")

    control_font = Resources.LoadFont("8bitOperatorPlusSC-Bold", 12)

    pet_text = love.graphics.newText(control_font, "Pet")
    move_text = love.graphics.newText(control_font, "Move")
    pause_text = love.graphics.newText(control_font, "Pause")
    accept_text = love.graphics.newText(control_font, "Accept")
    quad = is_gameshell and gameshell or pc
    menu:add_item{ name = "Back", action = back }
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