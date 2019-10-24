
require "src/gameStateMachine"
local lume = require("src/lib/lume")

Input = {}
Input.__index = Input

local delta = 0
local inputMap = 
{
    x = 'u',
    y = 'i',
    a = 'j',
    b = 'k',
    lk1 = "home",
    lk2 = "pageup",
    lk3 = "lshift",
    lk4 = "pagedown",
    lk5 = "end",
    up = "up",
    left = "left",
    down = "down",
    right = "right",
    menu = "escape",
    select = "space",
    start = "kpenter"
}

local keyDown = lume.fn(love.keyboard.isDown)

function Input:Process(dt)
    delta = dt

    if keyDown(inputMap.a) then OnA() end
    if keyDown(inputMap.x) then OnX() end
    if keyDown(inputMap.y) then OnY() end
    if keyDown(inputMap.up) then OnUp() end
    if keyDown(inputMap.left) then OnLeft() end
    if keyDown(inputMap.down) then OnDown() end
    if keyDown(inputMap.right) then OnRight() end
    if keyDown(inputMap.menu) then OnMenu() end
    if keyDown(inputMap.start) then OnStart() end
    if keyDown(inputMap.select) then OnSelect() end
    if keyDown(inputMap.lk1) then OnLK1() end
    if keyDown(inputMap.lk2) then OnLK2() end
    if keyDown(inputMap.lk3) then OnLK3() end
    if keyDown(inputMap.lk4) then OnLK4() end
    if keyDown(inputMap.lk5) then OnLK5() end
end

-- Face Buttons --
function OnA()
end 

function OnB()
    if (GameStateMachine:GetState() == 1) then
        for i=1, #scene.entities, 1 do scene.entities[i]:interact(delta) end
    end
end

function OnX()
    print("X")
end

function OnY()
    if (GameStateMachine:GetState() == 1) then
        for i = 1, #scene.entities, 1 do scene.entities[i]:finishInteraction() end
    end
end
-- Face Buttons --

-- Movement --
function OnUp()
    player:moveY(-delta)
end

function OnLeft()
    player:moveX(-delta)
end

function OnDown()
    player:moveY(delta)
end

function OnRight()
    player:moveX(delta)
end
-- Movement --

-- Light Keys --
function OnLK1()
    print("1")
end

function OnLK2()
    print("2")
end

function OnLK3()
    print("3")
end

function OnLK4()
    print("4")
end

function OnLK5()
    print("5")
end
-- Light Keys --

-- Function Buttons --
function OnMenu()
    GameStateMachine:ChangeState(States.MainMenu)
    scene:reset()
end

function OnStart()
    print("START")
end

function OnSelect()
    print("SELECT")
end
-- Function Buttons --

-- Handles single key presses
function love.keypressed(k)
    if GameStateMachine:GetState() == States.MainMenu then
        if k == inputMap.up then
            mainMenu:Up()
        elseif k == inputMap.down then
            mainMenu:Down()
        elseif k == inputMap.a then
            if mainMenu:GetIndex() == 0 then
                GameStateMachine:ChangeState(States.Gameplay)
            else
                love.event.quit()
            end
        end
    else
        if k == inputMap.b then
            OnB()
        end
    end
end

function love.keyreleased(k)
    if k == inputMap.right then
        player:moveX(0)
    end
end