
require "src/scene"
require "src/mainMenu"
require "src/pauseMenu"
local class = require("src/lib/middleclass")

StateMachine = class('StateMachine')

States = {
    MainMenu = 0,
    Gameplay = 1,
    PauseMenu = 2,
    FailState = 3,
}

local stack = {}

function StateMachine:pop()
    stack[#stack]:cleanup()
    stack[#stack] = nil
end

function StateMachine:push(type)
    local state = nil
    if type == States.MainMenu then
        state = MainMenu:new()
    elseif type == States.Gameplay then
        state = Scene:new()
    elseif type == States.PauseMenu then
        state = PauseMenu:new()
    end
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
