
require "src/cat"
require "src/gui"
require "src/scene"
require "src/input"
require "src/entity"
require "src/player"
require "src/mainMenu"
require "src/gameStateMachine"

totalCats = 6
elapsedTime = 0

-- Needs to happen before anything else.
World = love.physics.newWorld(0, 0, true)

-- LOVE2D --
function love.load()
    scene = Scene:new()
    player = Player:new()

    initializeCats()

    love.window.setTitle("On Your Tail")
    love.window.setMode(scene:getWidth(), scene:getHeight())

    World:setCallbacks(onCollisionEnter, onCollisionExit, nil, nil)
end

function love.update(dt)
    if GameStateMachine:GetState() == 1 then
        checkForReset(dt)
        Input:Process(dt)
    
        if player:isInteracting() == false then
            scene:update(dt)
            World:update(dt, 8, 3)
        end
    end
end

function love.draw()
    if GameStateMachine:GetState() == 0 then
        MainMenu:Draw()
    elseif GameStateMachine:GetState() == 1 then
        drawScene()
    end
end

function drawScene()
    -- Move all background and entity drawing to Scene, perhaps.
    scene:draw()

    -- Move to "UI/HUD" class/function 
    drawStressBar()  
    love.graphics.print(string.format("Time: %.3f", elapsedTime), scene:getWidth() - 100, 10)
end 

function checkForReset(dt)
    elapsedTime = elapsedTime + dt
    if player.stress() >= 120 then
        elapsedTime = 0
        scene:reset()
    end
end
-------------

-------- Player -------
function drawStressBar()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 10, 10, 120, 20)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 10, player:stress(), 20)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 10, 10, 120, 20)
end
----------------

------- Cats -------
function initializeCats() 
    for i = 1, totalCats, 1 do
        cat = Cat:new()
        cat:setIndex(i)
        cat:reposition()
    end
end
--------------------

-- World Callbacks --
function onCollisionEnter(first, second, contact)
    if first:getCategory() == 1 and second:getCategory() == 2 then
        player:setInteractable(true)
    elseif second:getCategory() == 1 and first:getCategory() == 2 then
        player:setInteractable(true)
    end 
end

function onCollisionExit(first, second, contact)
    if first:getCategory() == 1 or second:getCategory() == 1 then
        player:setInteractable(false)
        player:setInteracting(false)
    end
end
----------------------