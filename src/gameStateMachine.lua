
GameStateMachine = { }

States = {
    MainMenu = 0,
    Gameplay = 1,
    Failstate = 2,
}

local currentState = States.MainMenu

function GameStateMachine:ChangeState(state)   
    for k, v in pairs(States) do
        if v == state then
            currentState = state
            return
        end
    end
end

function GameStateMachine:GetState()
    return currentState;
end