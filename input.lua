
Input = {}
Input.__index = Input

local delta = 0
local inputMap = 
{
    x = "u",
    y = "i",
    a = "j",
    b = "k",
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

    if love.keyboard.isDown(inputMap.b) then
        OnB()
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
    if (state == 0) then
        print("A")
    elseif (state == 1) then
        print("AAAA")
    end
end 

function OnB()
    if (state == 0) then
        print("B")
    elseif (state == 1) then
        Player:Interact(delta)
    end
end

function OnX()
    print("X")
end

function OnY()
    if (state == 0) then
        print("Y")
    elseif (state == 1) then
        Player:FinishInteraction()
    end
end
-- Face Buttons --

-- Movement --
function OnUp()
    Player:MoveY(-delta)
end

function OnLeft()
    Player:MoveX(-delta)
end

function OnDown()
    Player:MoveY(delta)
end

function OnRight()
    Player:MoveX(delta)
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
    state = 0 
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
    if state == 0 then
        MainMenu:Input(k)
    end
end