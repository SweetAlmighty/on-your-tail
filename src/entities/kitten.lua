
require "src/entities/cat"

Kitten = class("Kitten", Cat)

function randomPosition(entity)
    return { love.math.random(screenWidth - entity.spriteWidth, screenWidth * 2),
        love.math.random(playableArea.y - entity.spriteHeight, playableArea.height) }
end

function Kitten:initialize()
    Entity.initialize(self, Types.KITTEN, 1)

    Entity.setState(self, e_States.IDLE)
    Entity.setDirection(self, Directions.E)
    Entity.setImageDefaults(self, 102, 90, 17, 15)
    Entity.setPosition(self, randomPosition(self))

    local animats = animatFactory:createWithLayer("kitten", lume.randomchoice(catType))
    Entity.setAnims(self, { animats[2], animats[1], animats[2], animats[3] })

    self.limit = catLimit
    self.stressReduction = 15
    self.button = InteractButton:new()
end