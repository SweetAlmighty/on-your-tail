local fonts = { }
local fontType = '.ttf'
local fontPath = '/data/fonts/'
local font = function(name) return (fontPath .. name .. fontType) end

local anims = { }
local animType = '.json'
local animPath = '/data/images/anims/'
local anim = function(name) return (animPath .. name .. animType) end

local sheets = { }
local sheetType = '.json'
local sheetPath = '/data/images/sheet/'
local sheet = function(name) return (sheetPath .. name .. sheetType) end

local images = { }
local imageType = '.png'
local imagePath = '/data/images/'
local image = function(name) return (imagePath .. name .. imageType) end

local audio = { }
local audioType = '.wav'
local sfxPath = '/data/audio/sfx/'
local musicPath = '/data/audio/music/'
local sfx = function(name) return (sfxPath .. name .. audioType) end
local music = function(name) return (musicPath .. name .. audioType) end

function LoadImage(name)
    if findIndex(images, name) then return images[name] end
    local path = image(name)
    if love.filesystem.getInfo(path) then
        images[name] = love.graphics.newImage(path)
        return images[name]
    end
    print('Image Error: Image at ' .. path .. ' could not be found.')
    return nil
end

function LoadFont(name, size)
    if findIndex(fonts, name) then return fonts[name] end
    local path = font(name)
    if love.filesystem.getInfo(path) then
        fonts[name] = love.graphics.newFont(path, size)
        return fonts[name]
    end
    print('Font Error: Font at ' .. path .. ' could not be found.')
    return nil
end

function LoadSheet(name)
    if findIndex(sheets, name) then return sheets[name] end
    local path = sheet(name)
    if love.filesystem.getInfo(path) then
        sheets[name] = json.decode(love.filesystem.read(path))
        return sheets[name]
    end
    print('Sheet Error: Sheet at " .. path .. " could not be found.')
    return nil
end

function LoadAnim(name)
    if findIndex(anims, name) then return anims[name] end
    local path = anim(name)
    if love.filesystem.getInfo(path) then
        anims[name] = json.decode(love.filesystem.read(path))
        return anims[name]
    end
    print('Anim Error: Animation at ' .. path .. ' could not be found.')
    return nil
end

function LoadMusic(name)
    if findIndex(audio, name) then return audio[name] end
    local path = music(name)
    if love.filesystem.getInfo(path) then
        audio[name] = love.audio.newSource(path, 'stream')
        return audio[name]
    end
    print('Music Error: Music at ' .. path .. ' could not be found.')
    return nil
end

function LoadSFX(name)
    if findIndex(audio, name) then return audio[name] end
    local path = sfx(name)
    if love.filesystem.getInfo(path) then
        audio[name] = love.audio.newSource(path, 'static')
        return audio[name]
    end
    print('SFX Error: SFX at ' .. path .. ' could not be found.')
    return nil
end