local menu = nil
local quad = nil
local image = Resources.LoadImage("controls")
local is_gameshell = love.system.getOS() == "Linux"
local pc = love.graphics.newQuad(145, 0, 157, 89, 304, 144)
local gameshell = love.graphics.newQuad(0, 0, 144, 144, 304, 144)
local pause = { x = is_gameshell and 15 or 15, y = is_gameshell and 112 or 85 }
local pet = { x = is_gameshell and 225 or 45, y = is_gameshell and 150 or 165 }
local move = { x = is_gameshell and 25 or 245, y = is_gameshell and 150 or 112 }
local start_pos = { x = is_gameshell and 80 or 86, y = is_gameshell and 64 or 96 }
local accept = { x = is_gameshell and 225 or 10, y = is_gameshell and 180 or 125 }

return {
    new = function()
		return {
            Exit = function() end,
            Update = function(dt) menu:update(dt) end,
            Input = function(key) menu:input(key) end,
            Type = function() return GameStates.ControlsMenu end,
            Enter = function()
                menu = Menu.new("CONTROLS", "center")
                quad = is_gameshell and gameshell or pc
                menu:add_item{ name = "Back", action = function() StateMachine.Pop() end }
            end,
            Draw = function()
                menu:draw(nil, screen_height - 30)
                love.graphics.draw(image, quad, start_pos.x, start_pos.y)
                love.graphics.print("Pause", pause.x, pause.y)
                love.graphics.print("Move", move.x, move.y)
                love.graphics.print("Pet", pet.x, pet.y)
                love.graphics.print("Accept", accept.x, accept.y)
            end,
        }
    end
}