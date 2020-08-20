require "src/states/state"

menu = {
    index = 1,
    title = nil,
    state = state,
    options = { },
    startWidth = 0,
    startHeight = 0,
    titlePos = { x = 0, y = 0 ,}
    moveSFX = resources:LoadSFX("move"),
    acceptSFX = resources:LoadSFX("accept"),
    pointer = resources:LoadImage("pointer"),
    declineSFX = resources:LoadSFX("decline"),
    clearColor = { r = 1, g = 1, b = 1, a = 1 }
}

menu.draw = function()
    local halfWidth = screenWidth/2
    love.graphics.clear(menu.clearColor.r, menu.clearColor.g, menu.clearColor.b, menu.clearColor.a)

    -- Draw title
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.draw(menu.title, menu.titlePos.x, menu.titlePos.y)

    -- Draw menu options
    for i=1, #menu.options, 1 do
        menu.startWidth = math.floor(halfWidth - (menu.options[i]:getWidth()/2))
        love.graphics.draw(menu.options[i], menu.startWidth, menu.startHeight + ((i-1) * 40))
    end

    -- Draw pointer
    love.graphics.setColor(1, 1, 1, 1)
    local yPos = menu.startHeight + 5 + ((menu.index-1) * 40)
    local xPos = halfWidth - ((menu.options[menu.index]:getWidth() / 2) + menu.pointer:getWidth())
    love.graphics.draw(menu.pointer, xPos, yPos)
end
menu.setTitle = function(title)
    menu.title = love.graphics.newText(titleFont, title)
    menu.titlePos = {
        x = (screenWidth/2) - menu.title:getWidth()/2,
        y = (screenHeight/2) - ((menu.title:getHeight()*2) - 10)
    }
end
menu.up = function()
    local x = menu.index - 1
    if x < 1 then x = 1 else
        x = menu.index - 1
        menu.moveSFX:play()
    end
    menu.index = x
end
menu.down = function()
    local x = menu.index + 1
    if x > #menu.options then x = #menu.options else
        x = menu.index + 1
        menu.moveSFX:play()
    end
    menu.index = x
end
menu.accept = function() menu.acceptSFX:play() end
menu.decline = function() menu.declineSFX:play() end
menu.left = function() if menu.type == States.FailState then menu.moveSFX:play() end end
menu.right = function() if menu.type == States.FailState then menu.moveSFX:play() end end
