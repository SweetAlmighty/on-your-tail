
require "src/states/gameplay"
require "src/states/menus/mainMenu"
require "src/states/menus/failMenu"
require "src/states/menus/pauseMenu"
require "src/states/menus/highscoreMenu"
require "src/states/menus/controlsMenu"

StateMachine = class("StateMachine")

States = {
    MainMenu = 0,
    Gameplay = 1,
    PauseMenu = 2,
    HighscoreMenu = 3,
    ControlsMenu = 4,
    FailState = 5,
}

local stack = { }

function StateMachine:pop()
    stack[#stack]:cleanup()
    stack[#stack] = nil
end

function StateMachine:push(type)
    local state = nil

    if type == States.MainMenu then state = MainMenu:new()
    elseif type == States.Gameplay then state = Gameplay:new()
    elseif type == States.PauseMenu then state = PauseMenu:new()
    elseif type == States.HighscoreMenu then state = HighscoreMenu:new()
    elseif type == States.ControlsMenu then state = ControlsMenu:new()
    elseif type == States.FailState then state = FailMenu:new() end

    if state ~= nil then table.insert(stack, state) end
end

function StateMachine:clear()
    local count = #stack
    while(count ~= 0) do
        if stack[count].type ~= 0 then self:pop() end
        count = count - 1
    end
end

function StateMachine:initialize() end
function StateMachine:current() return stack[#stack] end
