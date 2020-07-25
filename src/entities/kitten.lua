
require "src/entities/cat"

Kitten = class("Kitten", Cat)

function randomPosition()
    return { love.math.random(screenWidth, screenWidth * 2),
        love.math.random(playableArea.y, playableArea.height) }
end

function Kitten:initialize()
    Entity.initialize(self, EntityTypes.KITTEN, EntityStates.IDLE, 1)
    Entity.setPosition(self, randomPosition(self))

    local type = lume.randomchoice(catType)
    local info = animateFactory:CreateAnimationSet("kittens")
    local animats = info[type]

    Entity.setAnims(self, {
        animats[1],
        animats[2],
        animats[3],
        info[type].Colliders
    })

    self.limit = catLimit
    self.button = InteractButton:new()
end