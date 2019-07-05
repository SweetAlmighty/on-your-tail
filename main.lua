
require "cat"
require "scene"
require "input"
require "entity"

delta = 0
width = 320
height = 240
percent = 0
CATegory = 1
playerCategory = 2

totalCats = 6
currentCat = nil
canInteract = false
World = love.physics.newWorld(0, 0, true)

-- LOVE2D --
function love.load()
    love.window.setTitle("On Your Tail")
    love.window.setMode(width, height)

    player = Entity:Create(width / 2, height / 2, 
        love.graphics.newImage("data/player.png"), World, 120, playerCategory)

    scene = Scene:Create(
        love.graphics.newImage("data/background.png"),
        love.graphics.newQuad(0, 0, width, height, width, height * 2),
        love.graphics.newQuad(0, 241, width, height, width, height * 2)) 

    initializeCats()

    setCallbacks(
        function(x) print("A") end,                                                 --[[onA]]
        function(x) activateInteraction(x) end,                                     --[[onB]]
        function(x) print("X") end,                                                 --[[onX]]
        function(x) deactivateInteraction() end,                                    --[[onY]]
        function(x) player.body:setY(player.body:getY() + (player.speed * -x)) end, --[[onUp]]
        function(x) player.body:setX(player.body:getX() + (player.speed * -x)) end, --[[onLeft]]
        function(x) player.body:setY(player.body:getY() + (player.speed * x)) end,  --[[onDown]]
        function(x) player.body:setX(player.body:getX() + (player.speed * x)) end,  --[[onRight]]
        function(x) print("1") end,                                                 --[[onLK1]]
        function(x) print("2") end,                                                 --[[onLK2]]
        function(x) print("3") end,                                                 --[[onLK3]]
        function(x) print("4") end,                                                 --[[onLK4]]
        function(x) print("5") end,                                                 --[[onLK5]]
        function(x) love.event.quit() end,                                          --[[onMenu]]
        function(x) print("START") end,                                             --[[onStart]]
        function(x) print("SELECT") end)                                            --[[onSelect]]

    World:setCallbacks(onCollisionEnter, onCollisionExit, nil, nil)
end

function love.update(dt)
    checkForReset(dt)
    processInput(dt)
    clampPlayerToPlayArea()

    if player.isInteracting == false then
        updateCats()
        Scene:Update(scene)
        World:update(dt, 8, 3)
    end
end

function love.draw()
    Scene:Draw(scene) 
    drawCats()  
    Entity:Draw(player)
    drawStressBar()

   love.graphics.print(string.format("Time: %.3f", delta), width - 100, 10)
end

function checkForReset(dt)
    delta = delta + dt
    percent = percent + (dt * SceneSpeed)

    if percent >= 120 then
        player.body:setX(width / 2)
        player.body:setY(height / 2)
        
        for i, cat in ipairs(cats) do 
            repositionCat(cat)
        end

        percent = 0
        delta = 0
    end
end
-------------

-------- Player -------
function clampPlayerToPlayArea(dt)
    clampEntityX(player)
    clampEntityY(player)
end

function clampEntityX(entity)
    local posX = entity.body:getX()
    local width = entity.width / 2

    if posX < scene.playableArea.x + width then
        posX = scene.playableArea.x + width
    elseif posX > scene.playableArea.maxX - width then
        posX = scene.playableArea.maxX - width
    end

    entity.body:setX(posX)
end

function clampEntityY(entity)
    local posY = entity.body:getY()
    local height = entity.height / 2

    if posY < scene.playableArea.y + height then
        posY = scene.playableArea.y + height
    elseif posY > scene.playableArea.maxY - height then
        posY = scene.playableArea.maxY - height
    end

    entity.body:setY(posY)
end

function drawStressBar()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 10, 10, 120, 20)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 10, 10, percent, 20)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 10, 10, 120, 20)
end
----------------

------- Cats -------
function initializeCats() 
    cats = {}
    for i = 1, totalCats, 1 do
        cat = Cat:Create(0, 0, World, CATegory)
        cat.body:setPosition(repositionCat(cat))
        table.insert(cats, cat)
    end
end

function updateCats()
    if player.isInteracting == false then
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
    local catX = math.random(scene.playableArea.x + cat.width, scene.playableArea.maxX - cat.width)
    local catY = math.random(0, -scene.playableArea.maxY)
    return catX, catY
end
--------------------


-- Input Callbacks --
function onCollisionEnter(first, second, contact)
    if first:getCategory() == CATegory and second:getCategory() == playerCategory then
        canInteract = true
        currentCat = first
    elseif second:getCategory() == CATegory and first:getCategory() == playerCategory then
        canInteract = true
        currentCat = second
    end 
end

function onCollisionExit(first, second, contact)
    if first:getCategory() == CATegory or second:getCategory() == CATegory then
        canInteract = false
        player.isInteracting = false
    end
end

function activateInteraction(dt)
    if canInteract == true and player.isInteracting == false then
        player.isInteracting = true
        player.speed = 0
        sceneSpeed = 0
    elseif player.isInteracting == true then
        percent = percent - (dt * 10)
    end
end

function deactivateInteraction()
    if player.isInteracting == true then
        player.isInteracting = false
        player.speed = 120
        sceneSpeed = 2
    end
end
----------------------