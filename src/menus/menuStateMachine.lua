local MainMenu = require "src/menus/mainMenu"
local FailMenu = require "src/menus/failMenu"
local PauseMenu = require "src/menus/pauseMenu"
local ExtrasMenu = require "src/menus/extrasMenu"
local CreditsMenu = require "src/menus/creditsMenu"
local OptionsMenu = require "src/menus/optionsMenu"
local ControlsMenu = require "src/menus/controlsMenu"
local SetScoreMenu = require "src/menus/setScoreMenu"
local HighscoreMenu = require "src/menus/highscoreMenu"

local stack = { }

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

MenuStateMachine = {
    Input = function(key) stack[#stack].Input(key) end,

    Push = function(type)
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
            table.insert(stack, state)
            stack[#stack].Enter()
        end

        for i=1, #stack, 1 do
            if stack[i].Type() == GameStates.Gameplay or stack[i].Type() == GameStates.SplashMenu then
                background = stack[i]
            end
        end
    end,

    Pop = function()
        stack[#stack].Exit()
        stack[#stack] = nil
    end,

    Clear = function()
        local count = #stack
        while(count > 2) do
            StateMachine.Pop()
            count = count - 1
        end
    end,

    Draw = function()
        if #stack ~= 0 then stack[#stack].Draw() end
    end,

    Update = function(dt)
        if #stack ~= 0 then stack[#stack].Update(dt) end
    end
}