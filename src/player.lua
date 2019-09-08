
require "src/scene"
require "src/entity"
require "love.graphics"

Player = {}
Player.__index = Player

local stress = 0
local player = {} 
local playerCategory = 2
local canInteract = false
local isInteracting = false

-- Initalize player entity
function Player:Create()
    player = Entity:Create(320 / 2, 240 / 2, 
        love.graphics.newImage("/data/player.png"), World, 120, playerCategory)
end

-- Update player data
function Player:Update(dt)
    stress = stress + (dt * Scene:Speed())
    Entity:Clamp(player) 
end

-- Draw player to the screen
function Player:Draw()
    Entity:Draw(player)
end

-- Move the player along the X axis
function Player:MoveX(x)
    player.body:setX(player.body:getX() + (player.speed * x))
end

-- Move the player along the Y axis
function Player:MoveY(y)
    player.body:setY(player.body:getY() + (player.speed * y))
end

-- Returns the player's stress level
function Player:Stress()
    return stress
end

-- Resets the player's position and stress
function Player:Reset(x, y)
    stress = 0
    player.body:setX(x)
    player.body:setY(y)
end

-- Sets whether the player can interact
function Player:SetInteractable(interactable)
    canInteract = interactable
end

-- Returns whether the player is interacting with something
function Player:IsInteracting()
    return isInteracting
end

-- Sets whether the player is currently interacting
function Player:SetInteracting(interacting)
    isInteracting = interacting
    Scene:SetSpeed((interacting == true) and 0 or 2)
    player.speed = (interacting == true) and 0 or 120
end

-- Handles interaction
function Player:Interact(dt)
    if canInteract == true and isInteracting == false then
        Player:SetInteracting(true)
    elseif isInteracting == true then
        stress = stress - (dt * 10)
        if stress < 0 then
            stress = 0
        end
    end
end

-- Will stop an interaction if one is currently in progress
function Player:FinishInteraction()
    if isInteracting == true then
        Player:SetInteracting(false)
    end
end
