local index = 1
local menu = nil
local playSound = false
local fullscreen = false
local volumeText, resolutionText, fullscreenText

local setText = function()
    local settings = Data.GetSettings()
    volumeText = settings.volume
    fullscreen = settings.fullscreen
    resolutionText = settings.resolution
    fullscreenText = settings.fullscreen and '[X]' or '[ ]'
end

local setFullscreen = function()
    fullscreen = not fullscreen
    setResolutionSetting(0)
end

local setVolumeSetting = function(value)
    playSound = Data.SetVolume(value)
    setText()
end

local setResolutionSetting = function(value)
    playSound = Data.SetResolution(value, fullscreen)
    setText()
end

local optionHeight = function(i) return ((i-1) * 20) end

local left = function()
    if index == 1 then setVolumeSetting(-1)
    elseif index == 2 then setResolutionSetting(-1) end
    if index ~= 3 and playSound then playSound = false end
end

local right = function()
    if index == 1 then setVolumeSetting(1)
    elseif index == 2 then setResolutionSetting(1) end
    if index ~= 3 and playSound then playSound = false end
end

return {
    new = function()
		return {
            Enter = function()
                setText()
                menu = Menu.new()
                menu:addItem{ name = 'Volume:', action = function() end }
                menu:addItem{ name = 'Resolution:', action = function() end }
                menu:addItem{ name = 'Fullscreen:', action = function() setFullscreen() end }
                menu:addItem{ name = 'Back', action = function() StateMachine.Pop() end }
            end,
            Update = function(dt) menu:update(dt) end,
            Draw = function()
                menu:draw(0, 0)
                love.graphics.print(volumeText, 225, optionHeight(1))
                love.graphics.print(resolutionText, 225, optionHeight(2))
                love.graphics.print(fullscreenText, 225, optionHeight(3))
            end,
            Input = function(key)
                if key == InputMap.up then index = math.min(4, math.max(1, index-1))
                elseif key == InputMap.down then index = math.min(4, math.max(1, index+1)) end
                if index <= 3 then
                    if key == InputMap.left then left()
                    elseif key == InputMap.right then right() end
                end
                menu:keypressed(key)
            end,
            Exit = function() end
        }
    end
}