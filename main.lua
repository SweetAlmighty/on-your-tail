
function love.load()
    love.window.setTitle("On Your Tail")

    inputKeyMap = 
    {
        up = "w",
        left = "a",
        down = "s",
        right = "d",
        exit = "escape"
    }

    inputActionMap =
    {
        [inputKeyMap.up] = function(x) player.y = player.y - x end,
        [inputKeyMap.left] = function(x) player.x = player.x - x end,
        [inputKeyMap.down] = function(x) player.y = player.y + x end,
        [inputKeyMap.right] = function(x) player.x = player.x + x end,
        [inputKeyMap.exit] = function(x) love.event.quit() end
    }

    player = {}
    player.x = 0
    player.y = 0
    player.speed = 180

    buildings = {}
    sceneSpeed = 180

    for i = 0, 4, 1 do
        spawnBuilding()
    end
end

function love.update(dt)
    processInput(dt)
    processSceneMovement(dt);
end

function love.draw()
    for i,b in ipairs(buildings) do
        love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
    end

    love.graphics.circle("line", player.x, player.y, 10)
end

function spawnBuilding()
    building = {}
    building.x = math.random(0, love.graphics.getWidth())
    building.y = math.random(0, love.graphics.getHeight())
    building.width = math.random(50, 200)
    building.height = math.random(50, 200)

    table.insert(buildings, building)
end

function processInput(dt)
    for k, v in pairs(inputKeyMap) do
        if love.keyboard.isDown(v) then
            inputActionMap[v](player.speed * dt)

            -- Debug scenario to test out "ternary" operation
            print("In Bounds: " .. ((player.x > 0 and player.y > 0) and "Yes" or "No"))
        end
    end
end

function processSceneMovement(dt)
    for i,b in ipairs(buildings) do
        b.y = b.y + sceneSpeed * dt
        
        if b.y > love.graphics.getHeight() then
            b.x = math.random(0, love.graphics.getWidth())
            b.y = math.random(-love.graphics.getHeight(), 0)
        end
    end
end
