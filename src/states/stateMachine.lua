local MainMenu = require 'src/states/mainMenu'
local Gameplay = require 'src/states/gameplay'
local FailMenu = require 'src/states/failMenu'
local PauseMenu = require 'src/states/pauseMenu'
local ExtrasMenu = require 'src/states/extrasMenu'
local CreditsMenu = require 'src/states/creditsMenu'
local OptionsMenu = require 'src/states/optionsMenu'
local ControlsMenu = require 'src/states/controlsMenu'
local SetScoreMenu = require 'src/states/setScoreMenu'
local HighscoreMenu = require 'src/states/highscoreMenu'

local stack = { }

GameStates = {
    MainMenu = 1,
    Gameplay = 2,
    PauseMenu = 3,
    HighscoreMenu = 4,
    ControlsMenu = 5,
    FailMenu = 6,
    SetScoreMenu = 7,
    ExtrasMenu = 8,
    CreditsMenu = 9,
    OptionsMenu = 10
}

StateMachine = {
    Push = function(type)
        local state = nil
        if type == GameStates.MainMenu then state = MainMenu.new()
        elseif type == GameStates.FailMenu then state = FailMenu.new()
        elseif type == GameStates.Gameplay then state = Gameplay.new()
        elseif type == GameStates.PauseMenu then state = PauseMenu.new()
        elseif type == GameStates.ExtrasMenu then state = ExtrasMenu.new()
        elseif type == GameStates.CreditsMenu then state = CreditsMenu.new()
        elseif type == GameStates.OptionsMenu then state = OptionsMenu.new()
        elseif type == GameStates.ControlsMenu then state = ControlsMenu.new()
        elseif type == GameStates.SetScoreMenu then state = SetScoreMenu.new()
        elseif type == GameStates.HighscoreMenu then state = HighscoreMenu.new()
        end
        if state ~= nil then
            table.insert(stack, state)
            stack[#stack].Enter()
        end
    end,

    Pop = function()
        stack[#stack].Exit()
        stack[#stack] = nil
    end,

    Clear = function()
        local count = #stack
        while(count > 1) do
            StateMachine.Pop()
            count = count - 1
        end
    end,

    Draw = function() stack[#stack].Draw() end,
    Input = function(key) stack[#stack].Input(key) end,
    Update = function(dt) stack[#stack].Update(dt) end
}