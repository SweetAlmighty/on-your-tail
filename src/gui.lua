require "src/mainMenu"
require "src/gameStateMachine"

local class = require "src/middleclass"

GUI = class('GUI')

function GUI:draw()
    if GameStateMachine:GetState() == 0 then
        MainMenu:Draw()
    else
        
    end
end