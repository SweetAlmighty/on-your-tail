
require "src/scene"
require "src/input"
require "src/mainMenu"

States = {
    MainMenu = 0,
    Gameplay = 1,
    Failstate = 2,
}

currentState = States.MainMenu

gameFont = love.graphics.newFont("/data/KarmaFuture.ttf", 20)

function love.load()
    love.math.setRandomSeed(os.time())

    scene = Scene:new()
    mainMenu = MainMenu:new()

    scene:createEntities()
    love.window.setTitle("On Your Tail")
    love.window.setMode(scene.width, scene.height)
end

function love.update(dt)
    if currentState == 1 then
        scene:update(dt)
        Input:Process(dt)
    end
end

function love.draw()
    if currentState == States.MainMenu then
        mainMenu:Draw()
    elseif currentState == States.Gameplay then
        scene:draw()
    end
end
