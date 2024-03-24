require"custextensions"
local anim = require"animation"

local g2 = {}

function g2.NewMessage()
    local goodbye = {}
    goodbye.scalepx = 3
    goodbye.locationpx = { x = 0, y = 0}
    goodbye.xupdate = 0
    goodbye.message_anim = anim.NewAnimation(0)
    local image = love.graphics.newImage("dog2_32x32.bmp")
    local messageClip = anim.NewClip(0, 0, 1, image:getWidth(), image:getHeight(), image)
    if (messageClip) then
        messageClip.repeatForSeconds = 5
        table.insert(goodbye.message_anim.cliplist, messageClip)
    end

    return goodbye
end

return g2