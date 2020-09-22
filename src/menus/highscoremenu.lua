local Menu = require("src/menus/menu")
local HighscoreMenu = { menu = nil, times = nil }

local width = 0

local function back() MenuStateMachine:pop() end

function HighscoreMenu:update(dt) self.menu:update(dt) end
function HighscoreMenu:input(key) self.menu:input(key) end
function HighscoreMenu:draw()
    self.menu:draw()
    love.graphics.draw(self.times, (screen_width/2) - (width/2), (screen_height/2))
end

function HighscoreMenu:enter()
    self.menu = Menu.new()
    self.menu:set_offset(0, 50)
    self.menu:add_item({ name = "Back", action = back })

    local current_time = ""
    local scores = Data.GetScores()
    for i=1, #scores, 1 do
        current_time = current_time..scores[i][1].." ----------- "..scores[i][2].."\n"
    end

    self.times = love.graphics.newText(menuFont, current_time)

    width = self.times:getWidth()
end

return HighscoreMenu