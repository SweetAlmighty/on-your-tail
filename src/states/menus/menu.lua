
require "src/states/state"

Menu = class('Menu', State)

function Menu:initialize()
    self.index = 1
    self.title = nil
    self.options = {}
    self.startWidth = 0
    self.startHeight = 0
    self.titlePos = { x = 0, y = 0}
    self.moveSFX = resources:LoadSFX("move")
    self.acceptSFX = resources:LoadSFX("accept")
    self.pointer = resources:LoadImage("pointer")
    self.declineSFX = resources:LoadSFX("decline")
    self.clearColor = { r = 1, g = 1, b = 1, a = 1 }
end

function Menu:draw()
    local halfWidth = screenWidth/2

    love.graphics.setColor(self.clearColor.r, self.clearColor.g, self.clearColor.b, self.clearColor.a)
    love.graphics.rectangle("fill", 0, 0, 320, 240)

    -- Draw title
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.draw(self.title, self.titlePos.x, self.titlePos.y)

    -- Draw menu options
    for i=1, #self.options, 1 do
        self.startWidth = math.floor(halfWidth - (self.options[i]:getWidth()/2))
        love.graphics.draw(self.options[i], self.startWidth, self.startHeight + ((i-1) * 40))
    end

    -- Draw pointer
    love.graphics.setColor(1, 1, 1, 1)
    local yPos = self.startHeight + 5 + ((self.index-1) * 40)
    local xPos = halfWidth - ((self.options[self.index]:getWidth() / 2) + self.pointer:getWidth())
    love.graphics.draw(self.pointer, xPos, yPos)
end

function Menu:setTitle(title)
    self.title = love.graphics.newText(titleFont, title)
    self.titlePos = {
        x = (screenWidth/2) - self.title:getWidth()/2,
        y = (screenHeight/2) - ((self.title:getHeight()*2) - 10)
    }
end

function Menu:up()
    local x = self.index - 1
    if x < 1 then x = 1 else
        x = self.index - 1
        self.moveSFX:play()
    end
    self.index = x
end

function Menu:down()
    local x = self.index + 1
    if x > #self.options then x = #self.options else
        x = self.index + 1
        self.moveSFX:play()
    end
    self.index = x
end

function Menu:left() 
    if self.type == States.SetScoreMenu or self.type == States.OptionsMenu then
        self.moveSFX:play()
    end
end

function Menu:right()
    if self.type == States.SetScoreMenu or self.type == States.OptionsMenu then
        self.moveSFX:play()
    end
end

function Menu:accept() self.acceptSFX:play() end
function Menu:decline() self.declineSFX:play() end
