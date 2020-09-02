require "src/entities/entityController"

return {
    new = function()
        local pause = false
		return {
            Draw = function() EntityController.Draw() end,
            Exit = function() EntityController.Clear() end,
            Type = function() return GameStates.Gameplay end,
            Update = function(dt)
                if not pause then
                    EntityController.Update(dt)
                end
            end,
            Input = function(key)
                if key == InputMap.menu and not pause then
                    pause = true
                    MenuStateMachine.Push(GameMenus.PauseMenu)
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