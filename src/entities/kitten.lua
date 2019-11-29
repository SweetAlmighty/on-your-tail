
require "src/entities/cat"

Kitten = class("Kitten", Cat)

function Kitten:initialize()
    Cat.initialize(self)
end