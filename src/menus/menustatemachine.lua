local MainMenu = require("src/menus/mainmenu")
local FailMenu = require("src/menus/failmenu")
local PauseMenu = require("src/menus/pausemenu")
local ExtrasMenu = require("src/menus/extrasmenu")
local CreditsMenu = require("src/menus/creditsmenu")
local OptionsMenu = require("src/menus/optionsmenu")
local ControlsMenu = require("src/menus/controlsmenu")
local SetScoreMenu = require("src/menus/setScoremenu")
local HighscoreMenu = require("src/menus/highscoremenu")

GameMenus = {
    MainMenu = 1,
    FailMenu = 2,
    PauseMenu = 3,
    ExtrasMenu = 4,
    CreditsMenu = 5,
    OptionsMenu = 6,
    ControlsMenu = 7,
    SetScoreMenu = 8,
    HighscoreMenu = 9
}

local pause = false

local MenuStateMachine = { stack = { } }

function MenuStateMachine:pause() return pause end
function MenuStateMachine:count() return #self.stack end
function MenuStateMachine:pop()
    pause = false
    self.stack[#self.stack] = nil
end

function MenuStateMachine:clear()
    pause = false
    while(#self.stack > 0) do
        MenuStateMachine:pop()
    end
end

function MenuStateMachine:input(key)
    if #self.stack ~= 0 then
        self.stack[#self.stack]:input(key)
    end
end

function MenuStateMachine:update(dt)
    if #self.stack ~= 0 then
        self.stack[#self.stack]:update(dt)
    end
end

function MenuStateMachine:draw()
    if #self.stack ~= 0 then
        self.stack[#self.stack]:draw()
    end
end

function MenuStateMachine:push(type)
    local state = nil
    if type == GameMenus.MainMenu then state = MainMenu
    elseif type == GameMenus.FailMenu then state = FailMenu
    elseif type == GameMenus.PauseMenu then state = PauseMenu
    elseif type == GameMenus.ExtrasMenu then state = ExtrasMenu
    elseif type == GameMenus.CreditsMenu then state = CreditsMenu
    elseif type == GameMenus.OptionsMenu then state = OptionsMenu
    elseif type == GameMenus.ControlsMenu then state = ControlsMenu
    elseif type == GameMenus.SetScoreMenu then state = SetScoreMenu
    elseif type == GameMenus.HighscoreMenu then state = HighscoreMenu
    end

    pause = (type == GameMenus.FailMenu or type == GameMenus.SetScoreMenu) and true or false

    if state then
        table.insert(self.stack, state)
        self.stack[#self.stack]:enter()
    end
end

return MenuStateMachine