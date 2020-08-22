require 'src/entities/entityController'

return {
    new = function()
		return {
            Enter = function()
                EntityController.AddEntity(EntityTypes.Player)
                EntityController.AddEntity(EntityTypes.Cat)
            end,
            Update = function(dt) EntityController.Update(dt) end,
            Draw = function() EntityController.Draw() end,
            Exit = function() EntityController.Clear() end,
            Input = function(key)
                if key == InputMap.menu then
                    StateMachine.Push(GameStates.PauseMenu)
                end
            end
        }
    end
}