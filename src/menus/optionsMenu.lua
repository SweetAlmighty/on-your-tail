local Menu = require "src/menus/menu"

local index = 1
local menu = nil
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

local function draw()
    menu:draw()
    love.graphics.draw(volume_text,     225, 117)
    love.graphics.draw(resolution_text, 225, 137)
    love.graphics.draw(fullscreen_text, 225, 157)
end

local function input(key)
    if key == InputMap.up then index = lume.clamp(index-1, 1, 4)
    elseif key == InputMap.down then index = lume.clamp(index+1, 1, 4) end
    if index < 3 then
        if key == InputMap.left then left()
        elseif key == InputMap.right then right() end
    end
    menu:input(key)
end

local function back()
    Data.Save()
    MenuStateMachine:pop()
end

local function enter()
    set_text()
    index = 1

    menu = Menu.new()
    menu:set_offset(0, -45)
    menu:add_item{ name = "Volume:", action = nil }
    menu:add_item{ name = "Resolution:", action = nil }
    menu:add_item{ name = "Fullscreen:", action = set_fullscreen }
    menu:add_item{ name = "Back", action = back}
end

local function update(dt) menu:update(dt) end
local function type() return GameMenus.OptionsMenu end

return {
    new = function()
		return {
            Type = type,
            Draw = draw,
            Enter = enter,
            Input = input,
            Update = update
        }
    end
}