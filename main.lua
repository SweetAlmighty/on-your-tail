
require "src/cat"
require "src/scene"
require "src/input"
require "src/entity"
require "src/player"
require "src/mainMenu"
require "src/gameStateMachine"

local lume = require("src/lib/lume")
local bump = require("src/lib/bump")

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
    love.math.setRandomSeed(os.time())
    love.window.setMode(scene.width, scene.height)
end

local time = 0

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
    if player.stress >= 120 then
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