
Resources = class("Resources")

local fontType = ".ttf"
local fontPath = "/data/fonts/"
local font = function(name) return (fontPath .. name .. fontType) end

local animType = ".json"
local animPath = "/data/sprites/anims/"
local anim = function(name) return (animPath .. name .. animType) end

local imageType = ".png"
local imagePath = "/data/sprites/images/"
local image = function(name) return (imagePath .. name .. imageType) end

function Resources:initialize() end

function Resources:LoadFont(name, size)
    local path = font(name)
    if love.filesystem.getInfo(path) then return love.graphics.newFont(path, size) end
    print("Font Error: Font at " .. path .. " could not be found.")
    return nil
end

function Resources:LoadImage(name)
    local path = image(name)
    if love.filesystem.getInfo(path) then return love.graphics.newImage(path) end
    print("Image Error: Image at " .. path .. " could not be found.")
    return nil
end

function Resources:LoadAnim(name)
    local path = anim(name)
    if love.filesystem.getInfo(path) then return json.decode(love.filesystem.read(path)) end
    print("Anim Error: Animation at " .. path .. " could not be found.")
    return nil
end