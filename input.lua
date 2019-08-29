
inputKeyMap = 
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

function setCallbacks(onA, onB, onX, onY, onUp, onLeft, onDown, onRight, onLK1, onLK2, onLK3, onLK4, 
    onLK5, onMenu, onStart, onSelect)
    inputActionMap =
    {
        [inputKeyMap.a]      = function(x) onA(x) end,
        [inputKeyMap.b]      = function(x) onB(x) end,
        [inputKeyMap.x]      = function(x) onX(x) end,
        [inputKeyMap.y]      = function(x) onY(x) end,
        [inputKeyMap.up]     = function(x) onUp(x) end,
        [inputKeyMap.left]   = function(x) onLeft(x) end,
        [inputKeyMap.down]   = function(x) onDown(x) end,
        [inputKeyMap.right]  = function(x) onRight(x) end,
        [inputKeyMap.lk1]    = function(x) onLK1(x) end,
        [inputKeyMap.lk2]    = function(x) onLK2(x) end,
        [inputKeyMap.lk3]    = function(x) onLK3(x) end,
        [inputKeyMap.lk4]    = function(x) onLK4(x) end,
        [inputKeyMap.lk5]    = function(x) onLK5(x) end,
        [inputKeyMap.menu]   = function(x) onMenu(x) end,
        [inputKeyMap.start]  = function(x) onStart(x) end,
        [inputKeyMap.select] = function(x) onSelect(x) end
    }
end

function processInput(dt)
    if state == 1 then
        for k, v in pairs(inputKeyMap) do
            if love.keyboard.isDown(v) then
                inputActionMap[v](dt)
            end
        end
    end
end

function love.keypressed(k)
    if state == 0 then
        MainMenu:Input(k)
    end
end