require 'src/states/menu'
require 'src/tools/utility'
require 'src/tools/saveData'
require 'src/tools/resources'
require 'src/states/stateMachine'
require 'src/tools/animationFactory'

json = require 'src/lib/json'
local tick = require 'src/lib/tick'
lovesize = require 'src/lib/lovesize'

screenWidth = 320
screenHeight = 240
local color = 50/255

local menuFont = Resources.LoadFont('8bitOperatorPlusSC-Bold', 15)

function love.load(arg)
    Data.Initialize()
    tick.framerate = 60
    love.graphics.setFont(menuFont)
    lovesize.set(screenWidth, screenHeight)
    StateMachine.Push(GameStates.SplashMenu)
    love.math.setRandomSeed(os.time())
end

function love.draw()
    love.graphics.clear(color, color, color)
    lovesize.begin()
        StateMachine.Draw()
    lovesize.finish()
end

function love.quit()
    Data.Save()
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