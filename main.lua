objects = {}

getDelta = false
hasClicked = false
deltaX, deltaY = 0, 0


function testPointInSphere(_object, _x, _y)
	local deltaX = (_object.body:getX() - _x) ^ 2
	local deltaY = (_object.body:getY() - _y) ^ 2
	return math.sqrt(deltaX + deltaY) < _object.shape:getRadius()
end

-- Because LÖVE's version of this is broken :[
function testPointInRectangle(_object, _x, _y)
	local x, y = _object.body:getPosition()
  local width, height = _object.texture:getWidth(), _object.texture:getHeight()
	return (x < _x and 
          y < _y and 
         (width + x) > _x and 
         (height + y) > _y)
end


function setDragPosition(_object, _x, _y)
  if getDelta == false then
    getDelta = true

    local x, y = _object.body:getPosition()

    deltaX = (x - _x)
    deltaY = (y - _y)
  end
end

function canMoveObject(_object, _x, _y)
  return testPointInRectangle(_object, _x, _y)
end

function moveObject(_shape, _x, _y)
  setDragPosition(_shape, _x, _y)
  _shape.body:setPosition(_x + deltaX, _y + deltaY)
end

function checkMouseObjectCollision()
  local x, y = love.mouse.getPosition()
  for index in pairs(objects) do
    object = objects[index]

    if object.canMove == true then
      if canMoveObject(object, x, y) then
        moveObject(object, x, y)
      end
    end
  end
end

function resetGlobalVariables()
    getDelta = false
    hasClicked = false
    deltaX, deltaY = 0, 0
end

function checkPlayerInput()
  if love.mouse.isDown(1) then
    if hasClicked == false then
      checkMouseObjectCollision()
    else
      hasClicked = false
    end
  else
    resetGlobalVariables()
  end
end


function createGround()
  objects.ground = {}
  objects.ground.canMove = false
  objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(650, 50) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape) --attach shape to body
end

function createCat()
  objects.cat = {}
  objects.cat.canMove = true
  objects.cat.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.cat.shape = love.physics.newRectangleShape(240, 120) --the ball's shape has a radius of 20
  objects.cat.fixture = love.physics.newFixture(objects.cat.body, objects.cat.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.cat.texture = love.graphics.newImage('cat.png')
  objects.cat.fixture:setRestitution(0.4) --let the ball bounce
end

function love.load()
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81 * 64, false)

  love.graphics.setBackgroundColor(255, 255, 255)
 
  createGround()
  createCat()
end

function love.update(dt)
	world:update(dt)
  checkPlayerInput()
end

function drawGround()
  love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
end

function drawCat()
  love.graphics.setColor(255, 255, 255) -- set the drawing color to white for the cat
  love.graphics.draw(objects.cat.texture, objects.cat.body:getX(), objects.cat.body:getY(), 0, 1, 1, 0, 0)
end

function love.draw()
 drawGround()
 drawCat()
end