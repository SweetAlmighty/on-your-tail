
require "love.graphics"

SceneSpeed = 2
SceneWidth = 320
SceneHeight = 240

Scene =
{
    image = nil,
    sceneOne = {},
    sceneTwo = {},
    playableArea = {}
}

function Scene:Create(image, one, two)
    local this = {}
    this.image = image
    this.sceneOne = 
    {
        x = 0,
        y = 0,
        quad = one
    }
    this.sceneTwo = 
    {
        x = 0,
        y = -SceneHeight,
        quad = two
    }
    this.playableArea = 
    {
        x = 60,
        y = 0,
        maxX = 260,
        maxY = SceneHeight
    }
    setmetatable(this, Scene)
    return this
end

function Scene:Draw(scene)
    love.graphics.draw(scene.image, scene.sceneOne.quad, scene.sceneOne.x, scene.sceneOne.y)
    love.graphics.draw(scene.image, scene.sceneTwo.quad, scene.sceneTwo.x, scene.sceneTwo.y)
end

function Scene:Update(scene)
    local y = scene.sceneOne.y + SceneSpeed
    scene.sceneOne.y = (y > (SceneHeight - SceneSpeed)) and (-SceneHeight) or (y)

    y = scene.sceneTwo.y + SceneSpeed
    scene.sceneTwo.y = (y > (SceneHeight - SceneSpeed)) and (-SceneHeight) or (y)
end