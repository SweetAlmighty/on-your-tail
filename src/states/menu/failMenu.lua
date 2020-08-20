require "src/states/menus/menu"

local failMenu = menu

local name = ""
local letters = { }
local currentTime = { "", " ----------- ", "", "\n" }

local getLetterIndex = function(value)
    for i=1, #letters, 1 do if letters[i] == value then return i end end
end

local updateName = function()
    failMenu.name[failMenu.currX] = letters[failMenu.currY]
    currentTime[1] = table.concat(failMenu.name)
    currentTime[3] = string.format("%.2f", currTime)
    name = table.concat(currentTime)
    failMenu.options[1] = love.graphics.newText(menuFont, name)
end

failMenu.initialize = function()
    failMenu.setTitle("Enter Score")

    failMenu.type = e_GameStates.FailState
    failMenu.currX, failMenu.currY = 1, 1
    failMenu.name = { "A", "A", "A" }
    failMenu.startHeight = screenHeight/2.5
    failMenu.clearColor = { r = 1, g = 1, b = 1, a = 1 }

    love.graphics.setFont(menuFont)
    name = table.concat(failMenu.name) .. " ----------- " .. string.format("%.2f", currTime) .. "\n"

    failMenu.options = {
        love.graphics.newText(menuFont, name),
        love.graphics.newText(menuFont, "Play again"),
        love.graphics.newText(menuFont, "Main menu")
    }

    for i=65, 90, 1 do table.insert(letters, string.char(i)) end
end

failMenu.draw = function()
    menu.draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("_", (screenWidth / 2) - (127 - (12 * failMenu.currX)), (screenHeight / 2.5) + 8)
end

failMenu.up = function()
    if failMenu.index == 1 then
        failMenu.currY = (failMenu.currY - 1 < 1) and 26 or failMenu.currY - 1
        updateName()
        failMenu.moveSFX:play()
    else
        local x = failMenu.index - 1
        if x < 2 then x = 2 else
            x = failMenu.index - 1
            failMenu.moveSFX:play()
        end
        failMenu.index = x
    end
end

failMenu.down = function()
    if failMenu.index == 1 then
        failMenu.currY = (failMenu.currY + 1 > 26) and 1 or failMenu.currY + 1
        updateName()
        failMenu.moveSFX:play()
    else
        local x = failMenu.index + 1
        if x > #failMenu.options then x = #failMenu.options else
            x = failMenu.index + 1
            failMenu.moveSFX:play()
        end
        failMenu.index = x
    end
end

failMenu.left = function()
    if failMenu.index == 1 then
        local x = failMenu.currX - 1
        if x < 1 then x = 1 else
            x = failMenu.currX - 1
            failMenu.moveSFX:play()
        end
        failMenu.currX = x
        failMenu.currY = getLetterIndex(failMenu.name[failMenu.currX])
    end
end

failMenu.right = function()
    if failMenu.index == 1 then
        local x = failMenu.currX + 1
        if x > 3 then x = 3 else
            x = failMenu.currX + 1
            failMenu.moveSFX:play()
        end
        failMenu.currX = x
        failMenu.currY = getLetterIndex(failMenu.name[failMenu.currX])
    end
end

failMenu.accept =  function()
    failMenu.acceptSFX:play()
    if failMenu.index == 1 then
        failMenu.index = failMenu.index + 1
        setTime({table.concat(failMenu.name), currTime})
    elseif failMenu.index == 2 then stateMachine:pop()
    else stateMachine:clear() end
end

function failMenu() return failMenu end
