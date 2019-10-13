
require "src/cat"
require "src/scene"
require "src/input"
require "src/entity"
require "src/player"
require "src/mainMenu"
require "src/gameStateMachine"

local lume = require("src/lib/lume")
local bump = require("src/lib/bump")

cats = { }
totalCats = 6
elapsedTime = 0

-- Needs to happen before anything else.
World = bump.newWorld(20)

-- LOVE2D --
function love.load()
    scene = Scene:new()
    player = Player:new()

    initializeCats()

    love.window.setTitle("On Your Tail")
    love.window.setMode(scene:getWidth(), scene:getHeight())
end

function love.update(dt)
    if GameStateMachine:GetState() == 1 then
        scene:update(dt)
        checkForReset(dt)
        Input:Process(dt)
    end
end

function love.draw()
    if GameStateMachine:GetState() == 0 then
        MainMenu:Draw()
    elseif GameStateMachine:GetState() == 1 then
        scene:draw()
    end
end

function checkForReset(dt)
    elapsedTime = elapsedTime + dt
    if player.stress() >= 120 then
        elapsedTime = 0
        scene:reset()
    end
end
-------------

------- Cats -------
function initializeCats() 
    for i = 1, totalCats, 1 do
        cat = Cat:new()
        cat:setIndex(i)
        cat:reset()
    end
end
--------------------

-- World Callbacks --
function onCollisionEnter(first, second, contact)
    local leftType = first:getCategory()
    local rightType = second:getCategory()
    local valid = (leftType == 1 and rightType == 2) or (rightType == 1 and leftType == 2)

    if valid then
        local cat = (leftType == 2) and findEntity(second) or findEntity(first)
        cat.interactable = true
        player.interactable = true
        table.insert(cats, cat)
    end
end

function onCollisionExit(first, second, contact)
    local leftType = first:getCategory()
    local rightType = second:getCategory()
    local valid = (leftType == 1 and rightType == 2) or (rightType == 1 and leftType == 2)

    if valid then
        local cat = (leftType == 2) and findEntity(second) or findEntity(first)

        player:setInteracting(false)
        player.interactable = false;

        cat:setInteracting(false)
        cat.interactable = false

        lume.remove(cats, cat)
    end
end

function findEntity(fixture)
    for k,v in ipairs(scene.entities) do
        if fixture == v.fixture then
            return v
        end
    end
end
----------------------

function filter(item, other)
    return 'cross'
end