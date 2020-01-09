
require "src/entities/cat"

Kitten = class("Kitten", Cat)

function Kitten:initialize()
    --self.walkLeft = anim.newAnimat(15)
    --self.walkLeft:addSheet(self.image)
    --self.walkLeft:addFrame(0,  currY, 16, 15)
    --self.walkLeft:addFrame(32, currY, 16, 15)
    --self.walkLeft:addFrame(0,  currY, 16, 15)
    --self.walkLeft:addFrame(64, currY, 17, 15)

    --self.walkRight = anim.newAnimat(15)
    --self.walkRight:addSheet(self.image)
    --self.walkRight:addFrame(16, currY, 16, 15)
    --self.walkRight:addFrame(48, currY, 16, 15)
    --self.walkRight:addFrame(16, currY, 16, 15)
    --self.walkRight:addFrame(81, currY, 17, 15)

    Entity.initialize(self, Types.KITTEN, 1)

    Entity.setState(self, e_States.IDLE)
    Entity.setDirection(self, Directions.E)
    Entity.setImageDefaults(self, 122, 120, 16, 15)
    Entity.setPosition(self, randomPosition(self))
    --Entity.setAnims(self,
    --    animatFactory:create("cat_WalkLeft", 1), -- should be idle
    --    animatFactory:create("cat_WalkLeft", 4),
    --    animatFactory:create("cat_SitLeft", 1)
    --)

    self.limit = catLimit
    self.button = InteractButton:new()
end