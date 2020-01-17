
require "src/input"
require "src/require"
require "resources"
require "src/animatFactory"
require "src/states/stateMachine"

speed = 2
currTime = 0
screenWidth = 320
screenHeight = 240
input = Input:new()
resources = Resources:new()
stateMachine = StateMachine:new()
animatFactory = AnimatFactory:new()
menuFont = resources:LoadFont("KarmaFuture", 20)
titleFont = resources:LoadFont("KarmaFuture", 50)
playableArea = { x = 0, y = 110, width = screenWidth/2, height = screenHeight }

function love.load()
    love.math.setRandomSeed(os.time())
    stateMachine:push(States.MainMenu)
    love.window.setTitle("On Your Tail")
    love.window.setMode(screenWidth, screenHeight)

    if love.filesystem.getInfo("highscores.txt") == nil then
        local index, tbl = 1, {}
        for i=1, 3, 1 do table.insert(tbl, i, ((i==index) and time or {"AAA", 0.00})) end
        love.filesystem.write("highscores.txt", lume.serialize(tbl))
    end
end

function love.update(dt)
    local state = stateMachine:current()
    if state.type == States.Gameplay then
        state:update(dt)
        input:process(dt)
     end
end

function setTime(time)
    if love.filesystem.getInfo("highscores.txt") then
        local result, message = lume.deserialize(love.filesystem.read("highscores.txt"))
        if message == nil then
            if type(result) == "table" then
                result[#result+1] = time
                table.sort(result, function(a, b) return a[2] > b[2] end)
                table.remove(result, #result)
                local _, error = love.filesystem.write("highscores.txt", lume.serialize(result))
                if error ~= nil then print("Save Error: " .. error) end
            end
        else print("Load Error: " .. message) end
    end
end

function love.draw() stateMachine:current():draw() end
