require "src/menus/menu"
require "src/tools/utility"
require "src/tools/saveData"
require "src/tools/resources"
require "src/states/stateMachine"
require "src/menus/menuStateMachine"
require "src/tools/animationFactory"

screen_width = 320
screen_height = 240
local color = 50/255

lume = require "src/lib/lume"
local tick = require "src/lib/tick"
lovesize = require "src/lib/lovesize"

menuFont = Resources.LoadFont("8bitOperatorPlusSC-Bold", 15)
titleFont = Resources.LoadFont("8bitOperatorPlusSC-Bold", 50)

function love.draw()
    love.graphics.clear(color, color, color)
    lovesize.begin()
        StateMachine.Draw()
        MenuStateMachine.Draw()
    lovesize.finish()
end

function love.load(arg)
    Data.Initialize()
    tick.framerate = 60
    lovesize.set(screen_width, screen_height)
    StateMachine.Push(GameStates.SplashScreen)
    math.randomseed(os.time() + tonumber(tostring({}):sub(8)))
end

function love.update(dt)
    StateMachine.Update(dt)
    MenuStateMachine.Update(dt)
end

function love.keypressed(key)
    MenuStateMachine.Input(key)
    StateMachine.Input(key)
end

function love.quit() Data.Save() end
function love.resize(width, height) lovesize.resize(width, height) end