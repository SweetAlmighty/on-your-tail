
require "src/states/menus/menu"

FailMenu = class("FailMenu", Menu)

local name = ""
local letters = {}
local currentTime = { "", " ----------- ", "", "\n" }

local getLetterIndex = function(value)
    for i=1, #letters, 1 do if letters[i] == value then return i end end
end

local updateName = function(menu)
    menu.name[menu.currX] = letters[menu.currY]
    currentTime[1] = table.concat(menu.name)
    currentTime[3] = string.format("%.2f", currTime)
    name = table.concat(currentTime)
    menu.options[1] = love.graphics.newText(menuFont, name)
end

function FailMenu:initialize()
    Menu.initialize(self)
    Menu.setTitle(self, "Enter Score")

    self.type = States.FailState
    self.currX, self.currY = 1, 1
    self.name = { "A", "A", "A" }
    self.startHeight = screenHeight/2.5
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }

    love.graphics.setFont(menuFont)
    name = table.concat(self.name) .. " ----------- " .. string.format("%.2f", currTime) .. "\n"

    self.options = {
        love.graphics.newText(menuFont, name),
        love.graphics.newText(menuFont, "Play again"),
        love.graphics.newText(menuFont, "Main menu")
    }

    for i=65, 90, 1 do table.insert(letters, string.char(i)) end
end

function FailMenu:draw()
    Menu.draw(self)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("_", (screenWidth / 2) - (127 - (12 * self.currX)), (screenHeight / 2.5) + 8)
end

function FailMenu:up()
    if self.index == 1 then
        self.currY = (self.currY - 1 < 1) and 26 or self.currY - 1
        updateName(self)
    else self.index = (self.index - 1 < 1) and 1 or self.index - 1 end
    if #self.options ~= 1 then self.moveSFX:play() end
end

function FailMenu:down()
    if self.index == 1 then
        self.currY = (self.currY + 1 > 26) and 1 or self.currY + 1
        updateName(self)
    else self.index = (self.index + 1 > #self.options) and #self.options or self.index + 1 end
    if #self.options ~= 1 then self.moveSFX:play() end
end

function FailMenu:left()
    if self.index == 1 then
        self.currX = (self.currX - 1 < 1) and 1 or self.currX - 1
        self.currY = getLetterIndex(self.name[self.currX])
    end
end

function FailMenu:right()
    if self.index == 1 then
        self.currX = (self.currX + 1 > 3) and 3 or self.currX + 1
        self.currY = getLetterIndex(self.name[self.currX])
    end
end

function FailMenu:accept()
    if self.index <= 2 then Menu.accept(self) end
    if self.index == 1 then
        self.index = self.index + 1
        setTime({table.concat(self.name), currTime})
    elseif self.index == 2 then stateMachine:pop()
    else stateMachine:clear() end
end

function FailMenu:cleanup() end
