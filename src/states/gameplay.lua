require 'src/entities/entityController'

local menu = nil
local paused = false
return {
    new = function()
		return {
            Enter = function()
                paused = false
                menu = Menu.new()
                menu:addItem{ name = 'Resume', action = function() paused = false end }
                menu:addItem{ name = 'Exit', action = function() StateMachine.Clear() end }

                EntityController.AddEntity(EntityTypes.Player)
            end,

            Update = function(dt)
                if paused then menu:update(dt)
                else EntityController.Update(dt) end
            end,

            Draw = function()
                if paused then menu:draw(0, 0)
                else EntityController.Draw() end
            end,

            Input = function(key)
                if paused then menu:keypressed(key)
                elseif key == InputMap.menu then paused = true end
            end,

            Exit = function() EntityController.Clear() end
        }
    end
}