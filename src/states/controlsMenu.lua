local menu = nil
local quad = nil
local image = Resources.LoadImage('controls')
local isGameshell = love.system.getOS() == 'Linux'
local pc = love.graphics.newQuad(145, 0, 157, 89, 304, 144)
local gameshell = love.graphics.newQuad(0, 0, 144, 144, 304, 144)
local pause = { x = isGameshell and 15 or 15, y = isGameshell and 112 or 85 }
local pet = { x = isGameshell and 225 or 45, y = isGameshell and 150 or 165 }
local move = { x = isGameshell and 25 or 245, y = isGameshell and 150 or 112 }
local startPos = { x = isGameshell and 80 or 86, y = isGameshell and 64 or 96 }
local accept = { x = isGameshell and 225 or 10, y = isGameshell and 180 or 125 }

return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new('center')
                quad = isGameshell and gameshell or pc
                menu:AddItem{ name = 'Back', action = function() StateMachine.Pop() end }
            end,
            Update = function(dt) menu:Update(dt) end,
            Draw = function()
                menu:Draw(screenWidth / 2, screenHeight - 30)
                love.graphics.draw(image, quad, startPos.x, startPos.y)
                love.graphics.print('Pause', pause.x, pause.y)
                love.graphics.print('Move', move.x, move.y)
                love.graphics.print('Pet', pet.x, pet.y)
                love.graphics.print('Accept', accept.x, accept.y)
            end,
            Input = function(key) menu:Input(key) end,
            Exit = function() end
        }
    end
}