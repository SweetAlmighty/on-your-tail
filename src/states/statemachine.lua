local Gameplay = require("src/states/gameplay")
local SplashScreen = require("src/states/splashscreen")

GameStates = { SplashScreen = 1, Gameplay = 2 }

local StateMachine = { stack = { } }

function StateMachine:count() return #self.stack end
function StateMachine:draw() self.stack[#self.stack]:draw() end
function StateMachine:input(key) self.stack[#self.stack]:input(key) end
function StateMachine:update(dt)
    if not MenuStateMachine:pause() then
        self.stack[#self.stack]:update(dt)
    end
end

function StateMachine:pop()
    self.stack[#self.stack]:exit()
    self.stack[#self.stack] = nil
end

function StateMachine:clear()
    while(#self.stack > 1) do StateMachine:pop() end
    StateMachine:push(GameStates.SplashScreen)
end

function StateMachine:push(type)
    local state = nil
    if type == GameStates.Gameplay then state = Gameplay
    elseif type == GameStates.SplashScreen then state = SplashScreen
    end

    if state then
        table.insert(self.stack, state)
        self.stack[#self.stack]:enter()
    end
end

return StateMachine