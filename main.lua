
require "src/scene"
require "src/input"
require "src/entity"
require "src/mainMenu"
require "src/gameStateMachine"

function love.load()
    scene = Scene:new()
    scene:createEntities()
    love.math.setRandomSeed(os.time())
    love.window.setTitle("On Your Tail")
    love.window.setMode(scene.width, scene.height)
end

function love.update(dt)
    if GameStateMachine:GetState() == 1 then
        scene:update(dt)
        Input:Process(dt)
    end
end

function love.draw()
    if GameStateMachine:GetState() == 0 then
        MainMenu:Draw()
    elseif GameStateMachine:GetState() == 1 then
        scene:draw()
    end
end
