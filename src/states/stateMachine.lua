e_GameStates = {
    MainMenu = 0,
    Gameplay = 1,
    PauseMenu = 2,
    HighscoreMenu = 3,
    ControlsMenu = 4,
    FailState = 5,
}

local stack = { }

stateMachine = {
    push = function(type)
        local state = nil
        if type == e_GameStates.MainMenu then state = mainMenu()
        elseif type == e_GameStates.Gameplay then state = Gameplay:new()
        elseif type == e_GameStates.PauseMenu then state = PauseMenu:new()
        elseif type == e_GameStates.HighscoreMenu then state = HighscoreMenu:new()
        elseif type == e_GameStates.ControlsMenu then state = ControlsMenu:new()
        elseif type == e_GameStates.FailState then state = FailMenu:new() end
        if state ~= nil then
            if #stack >= 1 then stack[#stack]:pause() end
            table.insert(stack, state)
            stack[#stack]:enter()
        end
    end
    pop = function()
        stack[#stack]:exit()
        stack[#stack] = nil
        stack[#stack]:unpause()
    end
    clear = function()
        local count = #stack
        while(count ~= 0) do
            if stack[count].type ~= 0 then pop() end
            count = count - 1
        end
    end
    current = function() 
        return stack[#stack] 
    end
}
