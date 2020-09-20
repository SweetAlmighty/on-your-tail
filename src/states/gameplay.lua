require("src/tools/backgroundHandler")
require("src/entities/entityController")

points = 0
moving = false

local enemy_mod = 0
local total_cats = 8
local kitten_mod = 0
local current_cats = 0
local total_enemies = 2
local current_enemies = 0
local enemy_factor = love.math.random(1, 5)
local kitten_factor = love.math.random(5, 15)

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

local function check_for_kitten_spawn(dt)
    kitten_mod = kitten_mod + dt
    local integral, _ = math.modf(kitten_mod)
    if integral == kitten_factor then
        kitten_mod = 0
        if current_cats ~= total_cats then
            current_cats = current_cats + 1
            kitten_factor = love.math.random(5, 15)
            EntityController.AddEntity(EntityTypes.Kitten)
        end
    end
end

local function check_for_enemy_spawn(dt)
    enemy_mod = enemy_mod + dt
    local integral, _ = math.modf(enemy_mod)
    if integral == enemy_factor then
        enemy_mod = 0
        if current_enemies ~= total_enemies then
            current_enemies = current_enemies + 1
            enemy_factor = love.math.random(1, 5)
            EntityController.AddEntity(EntityTypes.Enemy)
        end
    end
end

function Gameplay:update(dt)
    if not self.pause then
        check_for_kitten_spawn(dt)
        check_for_enemy_spawn(dt)
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
    love.graphics.draw(love.graphics.newText(menuFont, points), screen_width - 75, 5)
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

    points = 0
    enemy_mod = 0
    total_cats = 8
    kitten_mod = 0
    current_cats = 0
    total_enemies = 2
    current_enemies = 0
    enemy_factor = love.math.random(1, 5)
    kitten_factor = love.math.random(5, 15)

    EntityController.AddEntity(EntityTypes.Player)

    for _=1, total_cats, 1 do
        current_cats = current_cats + 1
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