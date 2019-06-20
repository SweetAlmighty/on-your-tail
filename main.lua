
totalCats = 5
sceneSpeed = 2
windowWidth = 320
windowHeight = 240

catCategory = 1
playerCategory = 2

canInteract = false

streetBorder = {}
streetBorder.XMin = 60
streetBorder.YMin = 0
streetBorder.XMax = 260
streetBorder.YMax = windowHeight

World = love.physics.newWorld(0, 0, true)


-- LOVE2D Functions --
function love.load()
    initializeWindow()
    initializeScene()
    initializePlayer()
    initializeCats()
    initializeKeymapping()
    
    World:setCallbacks(onCollisionEnter, onCollisionExit, nil, nil)
end

function love.update(dt)
    processInput(dt)
    processSceneMovement(dt);
    World:update(dt, 8, 3)
end

function love.draw()
    love.graphics.draw(sceneOne.image, sceneOne.x, sceneOne.y)
    love.graphics.draw(sceneTwo.image, sceneTwo.x, sceneTwo.y)

    for i, cat in ipairs(cats) do
        love.graphics.draw(catSprite, catSprites[i], cat.body:getX(), cat.body:getY(), nil, nil, 
            nil, cat.width / 2, cat.height / 2)
    end

    love.graphics.draw(player.image, player.body:getX(), player.body:getY(), nil, nil, nil, 
        player.width / 2, player.height / 2)
end
-----------------------


-- Initialize Functions --
function initializeWindow()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setTitle("On Your Tail")
end

function initializeScene()
    sceneOne = {}
    sceneOne.x = 0
    sceneOne.y = 0
    sceneOne.image = love.graphics.newImage("data/street_one.png")
    
    sceneTwo = {}
    sceneTwo.x = 0
    sceneTwo.y = -windowHeight
    sceneTwo.image = love.graphics.newImage("data/street_two.png")
end

function initializePlayer()
    player = {}
    player.speed = 120
    player.isInteracting = false
    player.image = love.graphics.newImage("data/player.png")
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()
    player.body = love.physics.newBody(World, windowWidth / 2, windowHeight / 2, "dynamic")
    player.shape = love.physics.newRectangleShape(player.width, player.height)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.fixture:setCategory(playerCategory)
end

function initializeCats() 
    catSprites = {
        love.graphics.newQuad(0, 0, 20, 20, 60, 40),
        love.graphics.newQuad(0, 20, 20, 20, 60, 40),
        love.graphics.newQuad(20, 0, 20, 20, 60, 40),
        love.graphics.newQuad(20, 20, 20, 20, 60, 40),
        love.graphics.newQuad(40, 0, 20, 20, 60, 40)
    }
    
    catSprite = love.graphics.newImage("data/cats.png")

    cats = {}    
    for i = 1, totalCats, 1 do
        cat = {}
        cat.isBeingInteractedWith = false
        cat.width  = 20
        cat.height = 20
        cat.body = love.physics.newBody(World, 0, 0, "dynamic")
        cat.shape = love.physics.newRectangleShape(cat.width, cat.height)
        cat.fixture = love.physics.newFixture(cat.body, cat.shape, 1)
        table.insert(cats, cat)
    end
    
    for i, cat in ipairs(cats) do
        cat.body:setPosition(repositionCat(cat))
    end
end

function initializeKeymapping()
    inputKeyMap = 
    {
        x = "u",
        y = "i",
        a = "j",
        b = "k",
        lk1 = "home",
        lk2 = "pageup",
        lk3 = "lshift",
        lk4 = "pagedown",
        lk5 = "end",
        up = "up",
        left = "left",
        down = "down",
        right = "right",
        menu = "escape",
        select = "space",
        start = "kpenter"
    }

    inputActionMap =
    {
        [inputKeyMap.menu]  = function(x) love.event.quit() end,
        [inputKeyMap.b]     = function(x) activateInteraction() end,
        [inputKeyMap.y]     = function(x) deactivateInteraction() end,
        [inputKeyMap.up]    = function(x) clampPlayerY(player.body:getY() - x) end,
        [inputKeyMap.left]  = function(x) clampPlayerX(player.body:getX() - x) end,
        [inputKeyMap.down]  = function(x) clampPlayerY(player.body:getY() + x) end,
        [inputKeyMap.right] = function(x) clampPlayerX(player.body:getX() + x) end
    }
end
-----------------------


-- Update Functions --
function processInput(dt)
    for k, v in pairs(inputKeyMap) do
        if love.keyboard.isDown(v) then
            inputActionMap[v](player.speed * dt)
        end
    end
end

function processSceneMovement(dt)
    if player.isInteracting == false then
        local y = sceneOne.y + sceneSpeed
        sceneOne.y = (y > (windowHeight - sceneSpeed)) and (-windowHeight) or (y)
    
        y = sceneTwo.y + sceneSpeed
        sceneTwo.y = (y > (windowHeight - sceneSpeed)) and (-windowHeight) or (y)
    
        local catX = 0
        local catY = 0

        for i, cat in ipairs(cats) do
            catX = cat.body:getX()
            catY = cat.body:getY() + sceneSpeed

            if catY > (windowHeight - sceneSpeed + cat.height) then
                catX, catY = repositionCat(cat)
            end
    
            cat.body:setPosition(catX, catY)
        end
    end
end

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
-----------------------


-- Helper Functions --
function clampPlayerX(pos)
    local newPos = pos
    local width = player.width / 2

    if pos < streetBorder.XMin + width then
        newPos = streetBorder.XMin + width
    elseif pos > streetBorder.XMax - width then
        newPos = streetBorder.XMax - width
    end

    player.body:setX(newPos)
end

function clampPlayerY(pos)
    local newPos = pos
    local height = player.height / 2

    if pos < streetBorder.YMin + height then
        newPos = streetBorder.YMin + height
    elseif pos > streetBorder.YMax - height then
        newPos = streetBorder.YMax - height
    end

    player.body:setY(newPos)
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

function repositionCat(cat)
    local catX = math.random(streetBorder.XMin + cat.width, streetBorder.XMax - cat.width)
    local catY = math.random(0, -streetBorder.YMax)
    return catX, catY
end
-----------------------
