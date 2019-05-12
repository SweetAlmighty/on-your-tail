
function love.load()
    love.window.setTitle("Hugger")
    love.graphics.setBackgroundColor(1, 1, 1);
    image = love.graphics.newImage("Untitled.png")
end

function love.update(dt)
    x, y = love.mouse.getPosition() 
end

function love.draw()
    love.graphics.draw(image, x - 150, y - 150)
end
