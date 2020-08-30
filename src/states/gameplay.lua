require 'src/entities/entityController'

return {
    new = function()
		return {
            Draw = function() EntityController.Draw() end,
            Exit = function() EntityController.Clear() end,
            Update = function(dt) EntityController.Update(dt) end,
            Input = function(key)
                if key == InputMap.menu then
                    StateMachine.Push(GameStates.PauseMenu)
                end
            end,
            Enter = function()
                EntityController.AddEntity(EntityTypes.Cat)
                EntityController.AddEntity(EntityTypes.Player)
                EntityController.AddEntity(EntityTypes.Kitten)
            end,
        }
    end
}