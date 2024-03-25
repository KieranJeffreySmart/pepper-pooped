require"custextensions"
local anim = require"animation"

local g2 = {}

GOODBYE_QUAD_WIDTH = 32
GOODBYE_QUAD_HEIGHT = 32

function g2.NewMessage()
    local goodbye = {}
    goodbye.scalepx = 3
    goodbye.locationpx = { x = 0, y = 0}
    goodbye.xupdate = 0
    goodbye.message_anim = anim.NewAnimation(0)
    local image = love.graphics.newImage("dog_animations_32x32.bmp")
    yPos = GOODBYE_QUAD_HEIGHT * 4
    local messageClip = anim.NewClip(0, yPos, 2, GOODBYE_QUAD_WIDTH, GOODBYE_QUAD_HEIGHT, image)
    if (messageClip) then
        messageClip.repeatForSeconds = 5
        table.insert(goodbye.message_anim.cliplist, messageClip)
    end

    return goodbye
end

return g2