
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
        x = SceneWidth,
        y = 0,
        quad = two
    }
    this.playableArea = 
    {
        x = 0,
        y = 75,
        maxX = SceneWidth,
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
    local x = scene.sceneOne.x - SceneSpeed
    scene.sceneOne.x = (x < (-SceneWidth)) and (SceneWidth) or (x)

    x = scene.sceneTwo.x - SceneSpeed
    scene.sceneTwo.x = (x < (-SceneWidth)) and (SceneWidth) or (x)
end