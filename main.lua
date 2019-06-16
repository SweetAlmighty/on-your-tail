
sceneSpeed = 2
windowWidth = 320
windowHeight = 240

World = love.physics.newWorld(0, 0, true)

-- LOVE2D Functions --
function love.load()
    initializeWindow()
    initializeScene()
    initializePlayer()
    initializeKeymapping()
    
    World:setCallbacks(OnCollisionEnter, OnCollisionExit, nil, nil)
end

function love.update(dt)
    processInput(dt)
    processSceneMovement(dt);
    World:update(dt, 8, 3)
end

function love.draw()
    love.graphics.draw(sceneOne.image, sceneOne.x, sceneOne.y)
    love.graphics.draw(sceneTwo.image, sceneTwo.x, sceneTwo.y)

    for i, o in ipairs(objects) do
        love.graphics.circle("fill", o.x, o.y, o.radius)
    end

    love.graphics.draw(player.image, player.x, player.y, nil, nil, nil, player.width / 2, 
        player.height / 2)
end
-----------------------


-- Initialize Functions --
function initializeWindow()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setTitle("On Your Tail")
end

function initializeScene()
    streetBorder = {}
    streetBorder.XMin = 60
    streetBorder.YMin = 0
    streetBorder.XMax = 260
    streetBorder.YMax = 240

    sceneOne = {}
    sceneOne.x = 0
    sceneOne.y = 0
    sceneOne.image = love.graphics.newImage("data/street_one.png")
    
    sceneTwo = {}
    sceneTwo.x = 0
    sceneTwo.y = -240
    sceneTwo.image = love.graphics.newImage("data/street_two.png")

    objects = {}    
    for i = 0, 2, 1 do
        object = {}
        object.radius = 10
        object.x = math.random(streetBorder.XMin + object.radius, streetBorder.XMax - object.radius)
        object.y = math.random(0, -streetBorder.YMax)
        object.body = love.physics.newBody(World, object.x, object.y, "dynamic")
        object.shape = love.physics.newCircleShape(object.radius)
        object.fixture = love.physics.newFixture(object.body, object.shape, 1)
        object.isBeingInteractedWith = false
        table.insert(objects, object)
    end
end

function initializePlayer()
    player = {}
    player.speed = 120
    player.x = windowWidth / 2
    player.y = windowHeight / 2
    player.isInteracting = false
    player.image = love.graphics.newImage("data/player.png")
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()
    player.body = love.physics.newBody(World, player.x, player.y, "dynamic")
    player.shape = love.physics.newRectangleShape(player.width, player.height)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
end

function initializeKeymapping()
    inputKeyMap = 
    {
        up = "up",
        left = "left",
        down = "down",
        right = "right",
        exit = "escape",
        interact = "p"
    }

    inputActionMap =
    {
        [inputKeyMap.up]       = function(x) clampPlayerY(player.y - x) end,
        [inputKeyMap.left]     = function(x) clampPlayerX(player.x - x) end,
        [inputKeyMap.down]     = function(x) clampPlayerY(player.y + x) end,
        [inputKeyMap.right]    = function(x) clampPlayerX(player.x + x) end,
        [inputKeyMap.exit]     = function(x) love.event.quit() end,
        [inputKeyMap.interact] = function(x) activateInteraction() end
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
    local y = sceneOne.y + sceneSpeed
    sceneOne.y = (y > (windowHeight - sceneSpeed)) and (-windowHeight) or (y)

    y = sceneTwo.y + sceneSpeed
    sceneTwo.y = (y > (windowHeight - sceneSpeed)) and (-windowHeight) or (y)

    
    for i, o in ipairs(objects) do
        y = o.y + sceneSpeed

        if y > (windowHeight - sceneSpeed + o.radius) then
            y = math.random(0, -streetBorder.YMax)        
            o.x = math.random(streetBorder.XMin + object.radius, 
                streetBorder.XMax - object.radius)
        end

        o.y = y
        o.body:setPosition(o.x, o.y)
    end
end

function OnCollisionEnter()
    print("Hi")
end

function OnCollisionExit()
    print("Bye")
end
-----------------------


-- Player Functions --
function clampPlayerX(pos)
    local newPos = pos
    local width = player.width / 2

    if pos < streetBorder.XMin + width then
        newPos = streetBorder.XMin + width
    elseif pos > streetBorder.XMax - width then
        newPos = streetBorder.XMax - width
    end

    player.x = newPos
    player.body:setX(player.x)
end

function clampPlayerY(pos)
    local newPos = pos
    local height = player.height / 2

    if pos < streetBorder.YMin + height then
        newPos = streetBorder.YMin + height
    elseif pos > streetBorder.YMax - height then
        newPos = streetBorder.YMax - height
    end

    player.y = newPos
    player.body:setY(player.y)
end

function activateInteraction()
    if player.isInteracting == false then
        player.isInteracting = true
    end
end
-----------------------