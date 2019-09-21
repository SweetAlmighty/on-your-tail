
require "src/gameStateMachine"

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

function Input:Process(dt)
    delta = dt

    if love.keyboard.isDown(inputMap.a) then
        OnA()
    end

    if love.keyboard.isDown(inputMap.x) then
        OnX()
    end

    if love.keyboard.isDown(inputMap.y) then
        OnY()
    end

    if love.keyboard.isDown(inputMap.up) then
        OnUp()
    end

    if love.keyboard.isDown(inputMap.left) then
        OnLeft()
    end

    if love.keyboard.isDown(inputMap.down) then
        OnDown()
    end

    if love.keyboard.isDown(inputMap.right) then
        OnRight()
    end

    if love.keyboard.isDown(inputMap.menu) then
        OnMenu()
    end

    if love.keyboard.isDown(inputMap.start) then
        OnStart()
    end

    if love.keyboard.isDown(inputMap.select) then
        OnSelect()
    end

    if love.keyboard.isDown(inputMap.lk1) then
        OnLK1()
    end

    if love.keyboard.isDown(inputMap.lk2) then
        OnLK2()
    end

    if love.keyboard.isDown(inputMap.lk3) then
        OnLK3()
    end

    if love.keyboard.isDown(inputMap.lk4) then
        OnLK4()
    end

    if love.keyboard.isDown(inputMap.lk5) then
        OnLK5()
    end
end

-- Face Buttons --
function OnA()
end 

function OnB()
    if (GameStateMachine:GetState() == 1) then
        player:interact(delta)
    end
end

function OnX()
    print("X")
end

function OnY()
    if (GameStateMachine:GetState() == 1) then
        player:finishInteraction()
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
    reset()
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
            MainMenu:Up()
        elseif k == inputMap.down then
            MainMenu:Down()
        elseif k == inputMap.a then
            if MainMenu:GetIndex() == 0 then
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