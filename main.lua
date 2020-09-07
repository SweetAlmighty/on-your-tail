require "src/menus/menu"
require "src/tools/utility"
require "src/tools/saveData"
require "src/tools/resources"
require "src/tools/animationfactory"

StateMachine = require "src/states/statemachine"
MenuStateMachine = require "src/menus/menustatemachine"

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
        StateMachine:draw()
        MenuStateMachine:draw()
    lovesize.finish()
end

function love.load(arg)
    Data.Initialize()
    tick.framerate = 60
    lovesize.set(screen_width, screen_height)
    StateMachine:push(GameStates.SplashScreen)
    math.randomseed(os.time() + tonumber(tostring({}):sub(8)))
end

function love.update(dt)
    StateMachine:update(dt)
    MenuStateMachine:update(dt)
end

function love.keypressed(key)
    MenuStateMachine:input(key)
    StateMachine:input(key)
end

function love.quit() Data.Save() end
function love.resize(width, height) lovesize.resize(width, height) end