Menu = require 'src/states/menu'
require 'src/states/stateMachine'

local tick = require 'src/lib/tick'
local lovesize = require 'src/lib/lovesize'

local color = 50/255
local screenWidth = 320
local screenHeight = 240

function love.load(arg)
    tick.framerate = 60
    lovesize.set(screenWidth, screenHeight)
    StateMachine.Push(GameStates.MainMenu)
    love.math.setRandomSeed(os.time())
end

function love.draw()
    love.graphics.clear(color, color, color)
    lovesize.begin()
        StateMachine.Draw()
    lovesize.finish()
end

function love.update(dt)
    StateMachine.Update(dt)
end

function love.keypressed(key)
    StateMachine.Input(key)
end

function love.resize(width, height)
    lovesize.resize(width, height)
end

function love.quit() end