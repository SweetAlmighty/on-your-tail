function love.conf(t)
    t.console = false
    t.version = "11.3"
    t.window.width = 320
    t.window.height = 240
    t.window.title = "On Your Tail"
    t.window.icon = "data/sprites/images/game.png"

    t.modules.touch = false
    t.modules.video = false
    t.modules.mouse = false
    t.modules.thread = false
    t.modules.physics = false
    t.modules.joystick = false
    t.accelerometerjoystick = false
end