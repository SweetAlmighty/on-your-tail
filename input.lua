
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

function setCallbacks(onB, onY, onUp, onLeft, onDown, onRight)
    inputActionMap =
    {
        [inputKeyMap.menu]  = function(x) love.event.quit() end,
        [inputKeyMap.b]     = function(x) onB(x) end,
        [inputKeyMap.y]     = function(x) onY(x) end,
        [inputKeyMap.up]    = function(x) onUp(x) end,
        [inputKeyMap.left]  = function(x) onLeft(x) end,
        [inputKeyMap.down]  = function(x) onDown(x) end,
        [inputKeyMap.right] = function(x) onRight(x) end
    }
end

function processInput(dt)
    for k, v in pairs(inputKeyMap) do
        if love.keyboard.isDown(v) then
            inputActionMap[v](dt)
        end
    end
end