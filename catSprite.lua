
require "love.graphics"

return
{
    Sprites = {
        love.graphics.newQuad(0, 0, 20, 20, 60, 40),
        love.graphics.newQuad(0, 20, 20, 20, 60, 40),
        love.graphics.newQuad(20, 0, 20, 20, 60, 40),
        love.graphics.newQuad(20, 20, 20, 20, 60, 40),
        love.graphics.newQuad(40, 0, 20, 20, 60, 40)
    },

    Image = love.graphics.newImage("data/cats.png"),
}