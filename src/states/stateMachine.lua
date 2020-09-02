local Gameplay = require "src/states/gameplay"
local SplashScreen = require "src/states/splashScreen"

local stack = { }

GameStates = {
    Gameplay = 1,
    SplashScreen = 2
}

StateMachine = {
    Input = function(key)
        stack[#stack].Input(key)
    end,

    Push = function(type)
        local state = nil
        if type == GameStates.Gameplay then
            state = Gameplay.new()
        elseif type == GameStates.SplashScreen then
            state = SplashScreen.new()
        end

        if state then
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
        while(count > 2) do
            StateMachine.Pop()
            count = count - 1
        end
    end,

    Draw = function()
        stack[#stack].Draw()
    end,

    Update = function(dt)
        stack[#stack].Update(dt)
    end
}