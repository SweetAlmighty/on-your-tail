local Menu = require "src/menus/menu"
local OptionsMenu = { menu = nil }

local index = 1
local play_sound = false
local fullscreen = false
local move_sfx = Resources.LoadSFX("move")
local volume_text, resolution_text, fullscreen_text

local function set_text()
    local settings = Data.GetSettings()
    fullscreen = settings.fullscreen
    volume_text = love.graphics.newText(menuFont, settings.volume)
    resolution_text = love.graphics.newText(menuFont, settings.resolution)
    fullscreen_text = love.graphics.newText(menuFont, settings.fullscreen and "[X]" or "[ ]")
end

local function set_resolution_setting(value)
    play_sound = Data.SetResolution(value, fullscreen)
    set_text()
end

local function set_fullscreen()
    fullscreen = not fullscreen
    set_resolution_setting(0)
end

local function set_volume_setting(value)
    play_sound = Data.SetVolume(value)
    set_text()
end

local function left()
    if index == 1 then set_volume_setting(-1)
    elseif index == 2 then set_resolution_setting(-1) end
    if index ~= 3 and play_sound then
        play_sound = false
        move_sfx:play()
    end
end

local function right()
    if index == 1 then set_volume_setting(1)
    elseif index == 2 then set_resolution_setting(1) end
    if index ~= 3 and play_sound then
        play_sound = false
        move_sfx:play()
    end
end

local function back()
    Data.Save()
    MenuStateMachine:pop()
end

function OptionsMenu:update(dt) self.menu:update(dt) end
function OptionsMenu:type() return GameMenus.OptionsMenu end

function OptionsMenu:draw()
    self.menu:draw()
    love.graphics.draw(volume_text,     225, 117)
    love.graphics.draw(resolution_text, 225, 137)
    love.graphics.draw(fullscreen_text, 225, 157)
end

function OptionsMenu:input(key)
    if key == InputMap.up then index = lume.clamp(index-1, 1, 4)
    elseif key == InputMap.down then index = lume.clamp(index+1, 1, 4) end
    if index < 3 then
        if key == InputMap.left then left()
        elseif key == InputMap.right then right() end
    end
    self.menu:input(key)
end

function OptionsMenu:enter()
    index = 1
    set_text()

    if self.menu == nil then
        self.menu = Menu.new()
        self.menu:set_offset(0, -45)
        self.menu:add_item{ name = "Volume:", action = nil }
        self.menu:add_item{ name = "Resolution:", action = nil }
        self.menu:add_item{ name = "Fullscreen:", action = set_fullscreen }
        self.menu:add_item{ name = "Back", action = back }
    end
end

return OptionsMenu