require("src/entity/entity")
require("src/backend/utility")
require("src/backend/collisions")

local catCount = 20

function love.load(arg)
    --if arg[#arg] == "-debug" then require("mobdebug").start() end
  
    love.window.setMode(320, 240)
    love.window.setTitle("On Your Tail")

    loadImages()
    math.randomseed(os.time())
    for i=1, catCount, 1 do createEntity(e_Types.CAT) end
end

function love.draw() drawEntities() end
function love.update(dt) moveEntities(dt) end