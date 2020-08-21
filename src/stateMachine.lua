local mainMenu = require 'src/mainMenu'
local gameplay = require 'src/gameplay'

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
        if type == GameStates.MainMenu then state = mainMenu:new()
        elseif type == GameStates.Gameplay then state = gameplay:new() end
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