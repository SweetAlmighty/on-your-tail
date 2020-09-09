local Menu = require("src/menus/menu")
local HighscoreMenu = { menu = nil, times = nil }

local function back() MenuStateMachine:pop() end

function HighscoreMenu:update(dt) self.menu:update(dt) end
function HighscoreMenu:input(key) self.menu:input(key) end
function HighscoreMenu:draw()
    self.menu:draw()
    love.graphics.draw(self.times, (screen_width/2) - 110, (screen_height/2) - 25)
end

function HighscoreMenu:enter()
    if self.menu == nil then
        self.menu = Menu.new()
        self.menu:add_item{ name = "Back", action = back }
    end

    self.menu:set_offset(0, 50)

    local current_time = ""
    local scores = Data.GetScores()
    for i=1, #scores, 1 do
        current_time = current_time..scores[i][1].." ----------- "..string.format("%.2f", scores[i][2]).."\n"
    end

    self.times = love.graphics.newText(menuFont, current_time)
end

return HighscoreMenu