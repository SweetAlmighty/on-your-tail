require "src/tools/backgroundHandler"
require "src/entities/entityController"

local street = { }
local pause = false
local background = { }
local streetPosition = 0
local backgroundPosition = 0

local function exit() EntityController.Clear() end
local function type() return GameStates.Gameplay end

local function update(dt)
    if not pause then
        --BackgroundHandler.Update()
        EntityController.Update(dt)
    end
end

local function input(key)
    if key == InputMap.menu and not pause then
        pause = true
        MenuStateMachine.Push(GameMenus.PauseMenu)
    end
end

local function draw()
    background.DrawScroll(1, 0, 0, backgroundPosition)
    street.DrawScroll(1, 0, 126, streetPosition)
    BackgroundHandler.Draw()
    EntityController.Draw()
end
local function enter()
    BackgroundHandler.Initialize()

    street = AnimationFactory.CreateTileSet("Street")
    street.SetImageWrap("repeat", "clampzero")

    background = AnimationFactory.CreateTileSet("Background")
    background.SetImageWrap("repeat", "clampzero")

    EntityController.AddEntity(EntityTypes.Cat)
    EntityController.AddEntity(EntityTypes.Player)
    EntityController.AddEntity(EntityTypes.Kitten)
end

return {
    new = function()
		return {
            Draw = draw,
            Type = type,
            Exit = exit,
            Input = input,
            Enter = enter,
            Update = update
        }
    end
}