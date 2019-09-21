
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
World = love.physics.newWorld(0, 0, true)
player = Player:new()

-- LOVE2D --
function love.load()
    love.window.setTitle("On Your Tail")
    love.window.setMode(Scene:Width(), Scene:Height())

    Scene:Create()
    initializeCats()

    World:setCallbacks(onCollisionEnter, onCollisionExit, nil, nil)
end

function love.update(dt)
    if GameStateMachine:GetState() == 1 then
        checkForReset(dt)
        Input:Process(dt)
        player:update(dt)
    
        if player:isInteracting() == false then
            updateCats()
            Scene:Update()
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
    Scene:Draw() 
    drawCats()  
    player:draw()

    -- Move to "UI/HUD" class/function 
    drawStressBar()  
    love.graphics.print(string.format("Time: %.3f", elapsedTime), Scene:Width() - 100, 10)
end 

function checkForReset(dt)
    elapsedTime = elapsedTime + dt
    if player.stress() >= 120 then
        reset()
    end
end

function reset()
    player:reset(Scene:Width()/2, Scene:Height()/2)
    
    for i, cat in ipairs(cats) do 
        repositionCat(cat)
    end

    elapsedTime = 0
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
    cats = {}
    for i = 1, totalCats, 1 do
        cat = Cat:new()
        cat:setIndex(i)
        cat.body:setPosition(repositionCat(cat))
        table.insert(cats, cat)
    end
end

function updateCats()
    if player:isInteracting() == false then
        for i, cat in ipairs(cats) do
            cat:update()
        end
    end
end

function drawCats()
    for i, cat in ipairs(cats) do 
        cat:draw() 
    end
end

function repositionCat(cat)
    return math.random(Scene:Width() + cat.width, Scene:Width() * 2), 
    math.random(Scene:PlayableArea().y, Scene:PlayableArea().maxY)
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