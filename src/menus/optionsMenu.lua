local index = 1
local menu = nil
local play_sound = false
local fullscreen = false
local volume_text, resolution_text, fullscreen_text

local function set_text()
    local settings = Data.GetSettings()
    volume_text = settings.volume
    fullscreen = settings.fullscreen
    resolution_text = settings.resolution
    fullscreen_text = settings.fullscreen and "[X]" or "[ ]"
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

local function option_height(i) return ((i-1) * 20) end

local function left()
    if index == 1 then set_volume_setting(-1)
    elseif index == 2 then set_resolution_setting(-1) end
    if index ~= 3 and play_sound then play_sound = false end
end

local function right()
    if index == 1 then set_volume_setting(1)
    elseif index == 2 then set_resolution_setting(1) end
    if index ~= 3 and play_sound then play_sound = false end
end

return {
    new = function()
		return {
            Exit = function() end,
            Update = function(dt) menu:update(dt) end,
            Type = function() return GameStates.OptionsMenu end,
            Draw = function()
                menu:draw()
                love.graphics.print(volume_text, 225, option_height(1))
                love.graphics.print(resolution_text, 225, option_height(2))
                love.graphics.print(fullscreen_text, 225, option_height(3))
            end,
            Input = function(key)
                if key == InputMap.up then index = math.min(4, math.max(1, index-1))
                elseif key == InputMap.down then index = math.min(4, math.max(1, index+1)) end
                if index < 3 then
                    if key == InputMap.left then left()
                    elseif key == InputMap.right then right() end
                end
                menu:input(key)
            end,
            Enter = function()
                set_text()
                menu = Menu.new("OPTIONS", "center")
                menu:add_item{ name = "Volume:", action = function() end }
                menu:add_item{ name = "Resolution:", action = function() end }
                menu:add_item{ name = "Fullscreen:", action = function() set_fullscreen() end }
                menu:add_item{ name = "Back", action = function() Data.Save() StateMachine.Pop() end }
            end,
        }
    end
}