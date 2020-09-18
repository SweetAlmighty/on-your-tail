require("src/tools/backgroundHandler")
require("src/entities/entityController")

points = 0
moving = false

local totalCats = 8
local kittenMod = 0
local currentCats = 0
local totalEnemies = 4
local currentEnemies = 0
local animalControlMod = 0
local kittenFactor = love.math.random(5, 15)
local animalControlFactor = love.math.random(1, 5)

local Gameplay = {
    street = { },
    pause = false,
    background = { },
    street_position = 0,
    background_position = 0,
    background_music = Resources.LoadMusic("PP_Silly_Goose_FULL_Loop")
}

local function update_background(self)
    BackgroundHandler.Update()
    self.street_position = self.street_position - 2
    self.background_position = self.background_position - 1
end

local function checkForKittenSpawn(dt)
    kittenMod = kittenMod + dt
    local integral, _ = math.modf(kittenMod)
    if integral == kittenFactor then
        kittenMod = 0
        if currentCats ~= totalCats then
            currentCats = currentCats + 1
            kittenFactor = love.math.random(5, 15)
            EntityController.AddEntity(EntityTypes.Kitten)
        end
    end
end

local function checkForAnimalControlSpawn(dt)
    print(animalControlMod)
    animalControlMod = animalControlMod + dt
    local integral, _ = math.modf(animalControlMod)
    if integral == animalControlFactor then
        animalControlMod = 0
        if currentEnemies ~= totalEnemies then
            currentEnemies = currentEnemies + 1
            animalControlFactor = love.math.random(1, 5)
            EntityController.AddEntity(EntityTypes.Enemy)
        end
    end
end

function Gameplay:update(dt)
    if not self.pause then
        checkForKittenSpawn(dt)
        checkForAnimalControlSpawn(dt)
        EntityController.Update(dt)
    end

    if moving then
        update_background(self)
    end
end

function Gameplay:exit()
    self.background_music:stop()
    EntityController.Clear()
end

function Gameplay:draw_ui()
    love.graphics.print(points, screen_width - 75, 5)
end

function Gameplay:draw()
    self.background.DrawScroll(1, 0, 0, self.background_position)
    self.street.DrawScroll(1, 0, 126, self.street_position)
    BackgroundHandler.Draw()
    EntityController.Draw()
    self:draw_ui()
end

function Gameplay:enter()
    BackgroundHandler.Initialize()

    self.background_music:setLooping(true)
    self.background_music:play()

    self.street = AnimationFactory.CreateTileSet("Street")
    self.street.SetImageWrap("repeat", "clampzero")

    self.background = AnimationFactory.CreateTileSet("Background")
    self.background.SetImageWrap("repeat", "clampzero")

    EntityController.AddEntity(EntityTypes.Player)

    for _=1, totalCats, 1 do
        currentCats = currentCats + 1
        EntityController.AddEntity(EntityTypes.Cat)
    end
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