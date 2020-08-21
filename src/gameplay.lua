require 'src/tools/utility'
require 'src/tools/collisions'

local menu = nil
local paused = true
return {
    new = function()
		return {
            Enter = function()
                menu = Menu.new()
                menu:addItem{ name = 'Resume', action = function() paused = false end }
                menu:addItem{ name = 'Exit', action = function() StateMachine.Clear() end }
            end,

            Update = function(dt)
                if paused then menu:update(dt)
                else end
            end,

            Draw = function()
                if paused then menu:draw(0, 0)
                else
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.circle('fill', 150, 150, 150)
                end
            end,

            Input = function(key)
                if paused then menu:keypressed(key)
                else end
            end,

            Exit = function() end
        }
    end
}