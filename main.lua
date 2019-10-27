
require "src/input"
require "src/states/stateMachine"

speed = 2
bestTime = 0
screenWidth = 320
screenHeight = 240
stateMachine = StateMachine:new()
gameFont = love.graphics.newFont("/data/KarmaFuture.ttf", 20)
playableArea = { x = 0, y = 110, width = screenWidth/2, height = screenHeight }

function love.load()
    love.math.setRandomSeed(os.time())
    stateMachine:push(States.MainMenu)
    love.window.setTitle("On Your Tail")
    love.window.setMode(screenWidth, screenHeight)
end

function love.update(dt)
    local state = stateMachine:current()
    if state.type == States.Gameplay then
        state:update(dt)
        Input:process(dt)
    end
end

function love.draw()
    local state = stateMachine:current()
    state:draw()
end
