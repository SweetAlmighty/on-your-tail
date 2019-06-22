
require "cat"
require "scene"
require "input"
require "entity"

Entities = {}
totalCats = 5
canInteract = false
World = love.physics.newWorld(0, 0, true)

height = 240
width = 320

-- LOVE2D --
function love.load()
    love.window.setTitle("On Your Tail")
    love.window.setMode(width, height)

    player = Entity:Create(width / 2, height / 2, 
        love.graphics.newImage("data/player.png"), World, 120, 2)

    table.insert(Entities, player)

    scene = Scene:Create(
        love.graphics.newImage("data/background.png"),
        love.graphics.newQuad(0, 0, 320, 240, 320, 480),
        love.graphics.newQuad(0, 241, 320, 240, 320, 480)) 

    initializeCats()

    setCallbacks(
        function(x) activateInteraction() end,
        function(x) deactivateInteraction() end,
        function(x) player.body:setY(player.body:getY() + (player.speed * -x)) end,
        function(x) player.body:setX(player.body:getX() + (player.speed * -x)) end,
        function(x) player.body:setY(player.body:getY() + (player.speed * x)) end,
        function(x) player.body:setX(player.body:getX() + (player.speed * x)) end)

    World:setCallbacks(onCollisionEnter, onCollisionExit, nil, nil)
end

function love.update(dt)
    processInput(dt)
    clampEntityToPlayArea()

    if player.isInteracting == false then
        updateCats() 
        Scene:Update(scene)
        World:update(dt, 8, 3)
    end
end

function love.draw()
    Scene:Draw(scene)
    for i, cat in ipairs(cats) do Cat:Draw(cat, i) end
    Entity:Draw(player)
end
-------------



function clampEntityToPlayArea(dt)
    for i, entity in ipairs(Entities) do
        clampEntityX(entity)
        clampEntityY(entity)
    end
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



function initializeCats() 
    cats = {}
    for i = 1, totalCats, 1 do
        cat = Cat:Create(0, 0, World, 1)
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

function repositionCat(cat)
    local catX = math.random(scene.playableArea.x + cat.width, scene.playableArea.maxX - cat.width)
    local catY = math.random(0, -scene.playableArea.maxY)
    return catX, catY
end


-- Input Callbacks --
function onCollisionEnter(first, second, contact)
    if first:getCategory() == 1 or second:getCategory() == 1 then
        canInteract = true
    end
end

function onCollisionExit(first, second, contact)
    if first:getCategory() == 1 or second:getCategory() == 1 then
        canInteract = false
        player.isInteracting = false
    end
end

function activateInteraction()
    if canInteract == true and player.isInteracting == false then
        player.isInteracting = true
        player.speed = 0
        sceneSpeed = 0
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