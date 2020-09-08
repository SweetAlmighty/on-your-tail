local Gameplay = require("src/states/gameplay")
local SplashScreen = require("src/states/splashScreen")

local StateMachine = { stack = { } }

GameStates = { SplashScreen = 1, Gameplay = 2 }

function StateMachine:draw() self.stack[#self.stack]:draw() end
function StateMachine:input(key) self.stack[#self.stack]:input(key) end
function StateMachine:update(dt) self.stack[#self.stack]:update(dt) end

function StateMachine:pop()
    self.stack[#self.stack]:exit()
    self.stack[#self.stack] = nil
end

function StateMachine:clear()
    while(#self.stack > 0) do StateMachine:pop() end
    StateMachine:push(GameStates.SplashScreen)
end

function StateMachine:push(type)
    local state = nil
    if type == GameStates.Gameplay then
        state = Gameplay
    elseif type == GameStates.SplashScreen then
        state = SplashScreen
    end

    if state then
        table.insert(self.stack, state)
        self.stack[#self.stack]:enter()
    end
end

return StateMachine