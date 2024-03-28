MAIN_VERSION = "2"
local mainV2 = require("main-v2")

function love.conf(t)
    t.console = true
end

function love.load()
    mainV2.OnLoad()
end

function love.keyreleased(key)
    mainV2.OnKeyreleased(key)
end

function love.mousepressed(x, y, button, istouch)
    mainV2.mousepressed(x, y, button, istouch)
end

function love.update(dt)
    mainV2.UpdateFrames(dt)
end

function love.draw()
    mainV2.DrawFrames()
end

