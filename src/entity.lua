
local class = require("src/lib/middleclass")

Entity = class('Entity')

function Entity:initialize(x, y, quad, imagePath, speed, category)

    self.x = x
    self.y = y
    self.quad = quad
    self.speed = speed
    local _x, _y, w, h = self.quad:getViewport()
    self.interacting = false
    self.interactable = false
    self.image = love.graphics.newImage("/data/" .. imagePath)
    self.width = (self.image == nil) and 1 or w
    self.height = (self.image == nil) and 1 or h

    World:add(self, x, y, self.width, self.height)

    scene:addEntity(self)
end

function Entity:draw()
    love.graphics.draw(self.image, self.quad, self.x, self.y, nil, nil, nil, self.width / 2, 
        self.height)
    --Entity.showDebugInfo(self)
end

function Entity:setQuad(quad)
    self.quad = quad
end

function Entity:reset(x, y)
    self.interactable = false
    self.interacting = false
    World:update(self, x, y)
end

function Entity:move(x, y)
    local _x, _y, cols, len = World:move(self, x, y, filter)

    --for i=1,len do
    --    cols[i].other.interactable = true
    --    self.interactable = true
    --
    --    table.insert(cats, cols[i].other)
    --end

    Entity.clampToPlayBounds(self, _x, _y)
end

function Entity:clampToPlayBounds(x, y)
    Entity.clampEntityToXBounds(self, x)
    Entity.clampEntityToYBounds(self, y)
end

function Entity:clampEntityToXBounds(x)
    local _x = x
    local width = self.width/2
    local area = scene.playableArea

    if _x < area.x + width then
        _x = area.x + width
    elseif _x > area.maxX - width then
        _x = area.maxX - width
    end

    self.x = _x
end

function Entity:clampEntityToYBounds(y)
    local _y = y
    local height = self.height/2
    local area = scene.playableArea

    if _y < area.y + height then
        _y = area.y + height
    elseif _y > area.maxY then
        _y = area.maxY
    end

    self.y = _y
end

function Entity:showDebugInfo()
    Entity.showCollider(self)
    Entity.showPosition(self)
end

function Entity:showCollider()
    local x, y, w, h = World:getRect(self)
    love.graphics.rectangle("line", x - (self.width / 2), y - (self.height), w, h)
end

function Entity:showPosition()
    love.graphics.points(self.x, self.y)
end