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
    love.graphics.setColor(1, 1, 0)
    for i,b in ipairs(buildings) do
        love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
    end

    love.graphics.setColor(0, 0, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius)
end
--


function initializeWindow()
    love.window.setMode(320, 240)
    love.window.setTitle("On Your Tail")
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
end

function initializeScene()
    player = {}
    player.x = 160
    player.y = 120
    player.speed = 180
    player.radius = 10

    street = {}
    street.XMin = 50
    street.YMin = 0
    street.XMax = 270
    street.YMax = 240
    
    buildings = {}
    sceneSpeed = 180

    spawnBuildings()
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

function spawnBuildings()
    for i = 0, 5, 1 do
        building = {}
        building.x = (i <= 2) and 0 or 270
        building.y = ((i <= 2) and i or i - 3) * -120
        building.width = 50
        building.height = 100
        table.insert(buildings, building)
    end
end

function processInput(dt)
    for k, v in pairs(inputKeyMap) do
        if love.keyboard.isDown(v) then
            inputActionMap[v](player.speed * dt)
        end
    end
end

function clampPlayerX(pos) 
    local newPos = pos

    if pos < street.XMin + player.radius then
        newPos = street.XMin + player.radius
    elseif pos > street.XMax - player.radius then
        newPos = street.XMax - player.radius
    end

    player.x = newPos
end

function clampPlayerY(pos)
    local newPos = pos

    if pos < street.YMin + player.radius then
        newPos = street.YMin + player.radius
    elseif pos > street.YMax - player.radius then
        newPos = street.YMax - player.radius
    end

    player.y = newPos
end

function processSceneMovement(dt)
    for i,b in ipairs(buildings) do
        b.y = b.y + sceneSpeed * dt

        if b.y > love.graphics.getHeight() then
            b.x = (i > 3) and 0 or 270
            b.y = -120
        end
    end
end
