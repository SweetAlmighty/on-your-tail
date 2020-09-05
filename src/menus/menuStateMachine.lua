local MainMenu = require "src/menus/mainMenu"
local FailMenu = require "src/menus/failMenu"
local PauseMenu = require "src/menus/pauseMenu"
local ExtrasMenu = require "src/menus/extrasMenu"
local CreditsMenu = require "src/menus/creditsMenu"
local OptionsMenu = require "src/menus/optionsMenu"
local ControlsMenu = require "src/menus/controlsMenu"
local SetScoreMenu = require "src/menus/setScoreMenu"
local HighscoreMenu = require "src/menus/highscoreMenu"

GameMenus = {
    MainMenu = 1,
    PauseMenu = 2,
    HighscoreMenu = 3,
    ControlsMenu = 4,
    FailMenu = 5,
    SetScoreMenu = 6,
    ExtrasMenu = 7,
    CreditsMenu = 8,
    OptionsMenu = 9,
}

local MenuStateMachine = { stack = { } }

function MenuStateMachine:count() return #self.stack end

function MenuStateMachine:pop() self.stack[#self.stack] = nil end

function MenuStateMachine:clear()
    while(#self.stack > 0) do
        MenuStateMachine:pop()
    end
end

function MenuStateMachine:input(key)
    if #self.stack ~= 0 then
        self.stack[#self.stack].Input(key)
    end
end

function MenuStateMachine:update(dt)
    if #self.stack ~= 0 then
        self.stack[#self.stack].Update(dt)
    end
end

function MenuStateMachine:draw()
    if #self.stack ~= 0 then
        self.stack[#self.stack].Draw()
    end
end

function MenuStateMachine:push(type)
    local state = nil
    if type == GameMenus.MainMenu then state = MainMenu.new()
    elseif type == GameMenus.FailMenu then state = FailMenu.new()
    elseif type == GameMenus.PauseMenu then state = PauseMenu.new()
    elseif type == GameMenus.ExtrasMenu then state = ExtrasMenu.new()
    elseif type == GameMenus.CreditsMenu then state = CreditsMenu.new()
    elseif type == GameMenus.OptionsMenu then state = OptionsMenu.new()
    elseif type == GameMenus.ControlsMenu then state = ControlsMenu.new()
    elseif type == GameMenus.SetScoreMenu then state = SetScoreMenu.new()
    elseif type == GameMenus.HighscoreMenu then state = HighscoreMenu.new()
    end

    if state then
        table.insert(self.stack, state)
        self.stack[#self.stack].Enter()
    end
end

return MenuStateMachine