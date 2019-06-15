
sceneSpeed = 2
windowWidth = 320
windowHeight = 240

-- LOVE2D Functions
function love.load()
    initializeWindow()
    initializeScene()
    initializeKeymapping()
end

function love.update(dt)
    processInput(dt)
    processSceneMovement(dt);
end

function love.draw()
    love.graphics.draw(sceneOne.image, sceneOne.x, sceneOne.y)
    love.graphics.draw(sceneTwo.image, sceneTwo.x, sceneTwo.y)
    love.graphics.draw(player.image, player.x, player.y, nil, nil, nil, player.width / 2, 
        player.height / 2)
end
--


function initializeWindow()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setTitle("On Your Tail")
end

function initializeScene()
    player = {}
    player.x = windowWidth / 2
    player.y = windowHeight / 2
    player.speed = 120
    player.image = love.graphics.newImage("data/player.png")
    player.width = player.image:getWidth()
    player.height = player.image:getHeight()

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
end

function initializeKeymapping()
    inputKeyMap = 
    {
        up = "up",
        left = "left",
        down = "down",
        right = "right",
        exit = "escape"
    }

    inputActionMap =
    {
        [inputKeyMap.up]    = function(x) clampPlayerY(player.y - x) end,
        [inputKeyMap.left]  = function(x) clampPlayerX(player.x - x) end,
        [inputKeyMap.down]  = function(x) clampPlayerY(player.y + x) end,
        [inputKeyMap.right] = function(x) clampPlayerX(player.x + x) end,
        [inputKeyMap.exit]  = function(x) love.event.quit() end
    }
end


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
end


function clampPlayerX(pos) 
    local newPos = pos
    local width = player.width / 2

    if pos < streetBorder.XMin + width then
        newPos = streetBorder.XMin + width
    elseif pos > streetBorder.XMax - width then
        newPos = streetBorder.XMax - width
    end

    player.x = newPos
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
end