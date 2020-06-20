
require "src/states/gameplay"
require "src/states/menus/mainMenu"
require "src/states/menus/failMenu"
require "src/states/menus/pauseMenu"
require "src/states/menus/restartMenu"
require "src/states/menus/controlsMenu"
require "src/states/menus/highscoreMenu"

StateMachine = class("StateMachine")

States = {
    MainMenu = 1,
    Gameplay = 2,
    PauseMenu = 3,
    HighscoreMenu = 4,
    ControlsMenu = 5,
    FailMenu = 6,
    RestartMenu = 7,
}

local stack = { }

function StateMachine:push(type)
    print(type)
    local state = nil
    if type == States.MainMenu then state = MainMenu:new()
    elseif type == States.Gameplay then state = Gameplay:new()
    elseif type == States.PauseMenu then state = PauseMenu:new()
    elseif type == States.HighscoreMenu then state = HighscoreMenu:new()
    elseif type == States.ControlsMenu then state = ControlsMenu:new()
    elseif type == States.RestartMenu then state = RestartMenu:new() 
    elseif type == States.FailMenu then state = FailMenu:new() end
    if state ~= nil then
        if #stack >= 1 then stack[#stack]:pause() end
        table.insert(stack, state)
        stack[#stack]:enter()
    end
end

function StateMachine:pop()
    stack[#stack]:exit()
    stack[#stack] = nil
    stack[#stack]:unpause()
end

function StateMachine:clear()
    local count = #stack
    while(count ~= 0) do
        if stack[count].type ~= States.MainMenu then self:pop() end
        count = count - 1
    end
end

function StateMachine:initialize() end
function StateMachine:draw()
    if stack[#stack].type == States.FailMenu or stack[#stack].type == States.PauseMenu then
        stack[#stack-1]:draw()
    end
    stack[#stack]:draw()
end
function StateMachine:current() return stack[#stack] end
