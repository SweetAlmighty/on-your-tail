
require "src/states/stateMachine"

Input = class('Input')

local delta = 0
local playerX = 0
local playerY = 0
local state = nil
local isGameshell = love.system.getOS() == "Linux"
local inputMap =
{
    x = 'u',
    y = 'i',
    up = "up",
    lk5 = "end",
    lk1 = "home",
    left = "left",
    down = "down",
    lk2 = "pageup",
    lk3 = "lshift",
    right = "right",
    menu = "escape",
    select = "space",
    lk4 = "pagedown",
    start = "kpenter",
    a = isGameshell and 'j' or 'z',
    b = isGameshell and 'k' or 'x',
}

local keyDown = lume.fn(love.keyboard.isDown)

function Input:process(dt)
    delta = dt
    state = stateMachine:current()
    if keyDown(inputMap.a) then onA() end
    if keyDown(inputMap.b) then onB() end
    if keyDown(inputMap.x) then onX() end
    if keyDown(inputMap.y) then onY() end
    if keyDown(inputMap.up) then onUp() end
    if keyDown(inputMap.lk1) then onLK1() end
    if keyDown(inputMap.lk2) then onLK2() end
    if keyDown(inputMap.lk3) then onLK3() end
    if keyDown(inputMap.lk4) then onLK4() end
    if keyDown(inputMap.lk5) then onLK5() end
    if keyDown(inputMap.left) then onLeft() end
    if keyDown(inputMap.down) then onDown() end
    if keyDown(inputMap.menu) then onMenu() end
    if keyDown(inputMap.start) then onStart() end
    if keyDown(inputMap.right) then onRight() end
    if keyDown(inputMap.select) then onSelect() end
    player:move(playerX, playerY)
end

-- Face Buttons --
function onX() print("X") end
function onA() if state.type ~= States.Gameplay then state:accept() end end
function onB() if state.type == States.Gameplay then player:petCats(delta) end end
function onY() if state.type == States.Gameplay then player:finishInteraction() end end
-- Face Buttons --

-- Movement --
function onUp() if state.type == States.Gameplay then playerY = -delta else state:up() end end
function onDown() if state.type == States.Gameplay then playerY = delta else state:down() end end
function onLeft() if state.type == States.Gameplay then playerX = -delta else state:left() end end
function onRight() if state.type == States.Gameplay then playerX = delta else state:right() end end
-- Movement --

-- Light Keys --
function onLK1() print("1") end
function onLK2() print("2") end
function onLK3() print("3") end
function onLK4() print("4") end
function onLK5() print("5") end
-- Light Keys --

-- Function Buttons --
function onStart() print("START") end
function onSelect() print("SELECT") end
function onMenu() if state.type == States.Gameplay then stateMachine:push(States.PauseMenu) end end
-- Function Buttons --

-- Handles single key presses
function love.keypressed(k)
    state = stateMachine:current()
    if k == inputMap.up then onUp()
    elseif k == inputMap.down then onDown()
    elseif k == inputMap.left then onLeft()
    elseif k == inputMap.right then onRight()
    elseif k == inputMap.a then onA()
    end
end

function love.keyreleased(k)
    state = stateMachine:current()
    if state.type == States.Gameplay then
        if k == inputMap.b then player:stopPettingCats() end
        if k == inputMap.up or k == inputMap.down then playerY = 0 end
        if k == inputMap.left or k == inputMap.right then playerX = 0 end
    end
end