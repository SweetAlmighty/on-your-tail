require "src/backend/input"
require "src/backend/require"
require "src/backend/saveData"
require "src/backend/resources"
require "src/states/stateMachine"
require "src/backend/animateFactory"

lovesize = require("src/lib/lovesize")

speed = 2
currTime = 0
screenWidth = 320
screenHeight = 240
local color = 50/255
local input = Input:new()
resources = Resources:new()
stateMachine = StateMachine:new()
animateFactory = AnimateFactory:new()
menuFont = resources:LoadFont("8bitOperatorPlusSC-Bold", 15)
titleFont = resources:LoadFont("8bitOperatorPlusSC-Bold", 50)
playableArea = { x = 0, y = 150, width = screenWidth/2, height = screenHeight }

function love.load()
    lovesize.set(screenWidth, screenHeight)
    stateMachine:push(States.MainMenu)
    love.math.setRandomSeed(os.time())
    initializeData()
end

function love.resize(width, height)
    lovesize.resize(width, height)
end

function love.update(dt)
    local state = stateMachine:current()
    state:update(dt)
    if state.type == States.Gameplay then
        input:process(dt)
     end
end

function love.quit()
    saveData()
end

function love.draw()
    love.graphics.clear(color, color, color)
    lovesize.begin()
        stateMachine:draw()
    lovesize.finish()
end
