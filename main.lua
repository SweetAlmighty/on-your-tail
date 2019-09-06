
require "cat"
require "scene"
require "input"
require "entity"
require "Player"
require "mainMenu"

delta = 0
width = 320
height = 240

totalCats = 6
World = love.physics.newWorld(0, 0, true)

state = 0

-- LOVE2D --
function love.load()
    love.window.setTitle("On Your Tail")
    love.window.setMode(width, height)

    Player:Create()

    scene = Scene:Create(
        love.graphics.newImage("data/background_two.png"),
        love.graphics.newQuad(0, 0, width, height, width, height),
        love.graphics.newQuad(0, 0, width, height, width, height)) 

    initializeCats()

    World:setCallbacks(onCollisionEnter, onCollisionExit, nil, nil)
end

function love.update(dt)
    if state == 1 then
        checkForReset(dt)
        Input:Process(dt)
        Player:Update(dt)
    
        if Player:IsInteracting() == false then
            updateCats()
            Scene:Update(scene)
            World:update(dt, 8, 3)
        end
    end
end

function love.draw()
    if state == 0 then
        MainMenu:Draw()
    elseif state == 1 then
        drawScene()
    end
end

function drawScene()
    -- Move all background and entity drawing to Scene, perhaps.
    Scene:Draw(scene) 
    drawCats()  
    Player:Draw()

    -- Move to "UI/HUD" class/function 
    drawStressBar()  
    love.graphics.print(string.format("Time: %.3f", delta), width - 100, 10)
end 

function checkForReset(dt)
    delta = delta + dt
    if Player:Stress() >= 120 then
        reset()
    end
end

function reset()
    Player:Reset(width/2, height/2)
    
    for i, cat in ipairs(cats) do 
        repositionCat(cat)
    end

    delta = 0
end
-------------

-------- Player -------
function drawStressBar()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 10, 10, 120, 20)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 10, Player:Stress(), 20)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 10, 10, 120, 20)
end
----------------


------- Cats -------
function initializeCats() 
    cats = {}
    for i = 1, totalCats, 1 do
        cat = Cat:Create(0, 0, World, 1, i)
        cat.body:setPosition(repositionCat(cat))
        table.insert(cats, cat)
    end
end

function updateCats()
    if Player:IsInteracting() == false then
        for i, cat in ipairs(cats) do
            Cat:Update(cat, SceneSpeed, width)
        end
    end
end

function drawCats()
    for i, cat in ipairs(cats) do 
        Cat:Draw(cat, i) 
    end
end

function repositionCat(cat)
    return math.random(width + cat.width, width * 2), 
    math.random(scene.playableArea.y, scene.playableArea.maxY)
end
--------------------


-- Input Callbacks --
function onCollisionEnter(first, second, contact)
    if first:getCategory() == 1 and second:getCategory() == 2 then
        Player:SetInteractable(true)
    elseif second:getCategory() == 1 and first:getCategory() == 2 then
        Player:SetInteractable(true)
    end 
end

function onCollisionExit(first, second, contact)
    if first:getCategory() == 1 or second:getCategory() == 1 then
        Player:SetInteractable(false)
        Player:SetInteracting(false)
    end
end
----------------------