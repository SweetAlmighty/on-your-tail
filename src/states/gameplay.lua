require "src/tools/backgroundHandler"
require "src/entities/entityController"

local Gameplay = {
    street = { },
    pause = false,
    background = { },
    street_position = 0,
    background_position = 0,
    background_music = Resources.LoadMusic("PP_Silly_Goose_FULL_Loop")
}

function Gameplay:update(dt)
    if not self.pause then
        --BackgroundHandler.Update()
        EntityController.Update(dt)
    end
end

function Gameplay:exit()
    self.background_music:stop()
    EntityController.Clear()
end

function Gameplay:type() return GameStates.Gameplay end

function Gameplay:draw()
    self.background.DrawScroll(1, 0, 0, self.background_position)
    self.street.DrawScroll(1, 0, 126, self.street_position)
    BackgroundHandler.Draw()
    EntityController.Draw()
end

function Gameplay:enter()
    BackgroundHandler.Initialize()

    self.background_music:setLooping(true)
    self.background_music:play()

    self.street = AnimationFactory.CreateTileSet("Street")
    self.street.SetImageWrap("repeat", "clampzero")

    self.background = AnimationFactory.CreateTileSet("Background")
    self.background.SetImageWrap("repeat", "clampzero")

    EntityController.AddEntity(EntityTypes.Cat)
    EntityController.AddEntity(EntityTypes.Player)
    EntityController.AddEntity(EntityTypes.Kitten)
end

function Gameplay:input(key)
    if not self.pause then
        if key == InputMap.menu then
            self.pause = true
            self.background_music:pause()
            MenuStateMachine:push(GameMenus.PauseMenu)
        end
    else
        if self.pause and MenuStateMachine:count() == 0 then
            self.pause = false
            self.background_music:play()
        end
    end
end

return Gameplay