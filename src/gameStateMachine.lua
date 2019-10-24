
GameStateMachine = { }

States = {
    MainMenu = 0,
    Gameplay = 1,
    Failstate = 2,
}

local currentState = States.MainMenu

function GameStateMachine:ChangeState(state) 
    currentState = state
end

function GameStateMachine:GetState()
    return currentState;
end