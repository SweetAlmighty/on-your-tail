
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
    local file = love.graphics.newFont(font(name), size)
    if file == nil then
        print("Font Error: Font could not be created.")
        return nil
    end
    return file
end

function Resources:LoadAnim(name)
    if love.filesystem.getInfo(anim(name)) then
        local file = json.decode(love.filesystem.read(anim(name)))
        if file == nil then
            print("Load Error: File could not be loaded.")
            return nil
        end
        return file
    end
end

function Resources:LoadImage(name)
    local file = love.graphics.newImage(image(name))
    if file == nil then
        print("Image Error: Image could not be created.")
        return nil
    end
    return file
end