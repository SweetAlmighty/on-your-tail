local currX = 1
local currY = 1
local index = 1
local name = ''
local letters = {}
local currentTime = { '', ' ----------- ', '', '\n' }

local getLetterIndex = function(value)
    for i=1, #letters, 1 do if letters[i] == value then return i end end
end

local updateName = function(menu)
    name[currX] = letters[currY]
    currentTime[1] = table.concat(name)
    currentTime[3] = string.format('%.2f', currTime)
    name = table.concat(currentTime)
end

local up = function()
    if index == 1 then
        currY = (currY - 1 < 1) and 26 or currY - 1
        updateName()
    end
end

local down = function()
    if index == 1 then
        currY = (currY + 1 > 26) and 1 or currY + 1
        updateName()
    end
end

local left = function()
    if index == 1 then
        local x = currX - 1
        if x < 1 then x = 1 else
            x = currX - 1
        end
        currX = x
        currY = getLetterIndex(name[currX])
    end
end

local right = function()
    if index == 1 then
        local x = currX + 1
        if x > 3 then x = 3 else
            x = currX + 1
        end
        currX = x
        currY = getLetterIndex(name[currX])
    end
end

local menu = nil
return {
    new = function()
		return {
            Enter = function()
                name = table.concat(name)..' ----------- '..string.format('%.2f', currTime)..'\n'
                for i=65, 90, 1 do table.insert(letters, string.char(i)) end

                menu = Menu.new()
                menu:AddItem{
                    name = 'Play Again',
                    action = function()
                        if index == 2 then
                            StateMachine.Pop()
                        end
                    end
                }
                menu:AddItem{
                    name = 'Main Menu',
                    action = function()
                        if index == 2 then
                            StateMachine.Clear()
                        end
                    end
                }
            end,
            Update = function(dt) menu:Update(dt) end,
            Draw = function()
                menu:Draw(0, 0)
                love.graphics.print('_', (screenWidth / 2) - (127 - (12 * currX)), (screenHeight / 2.5) + 8)
            end,
            Input = function(key)
                if index == 1 then
                    if key == InputMap.left then left()
                    elseif key == InputMap.up then up()
                    elseif key == InputMap.right then right()
                    elseif key == InputMap.down then down()
                    elseif key == InputMap.a then index = 2
                    end
                else
                    menu:Input(key)
                end
            end,
            Exit = function() end
        }
    end
}