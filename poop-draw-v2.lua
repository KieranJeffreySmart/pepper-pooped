require"custextensions"
local anim = require"animation"
local log = require"log"
local tserial = require"Tserial"
local handleSerialisation = function () return '' end

p = {}
function p.NewPoop(defaultState, location, scaleToMap)
    local poop = {}
    poop.location = { x = location.x, y = location.y }
    poop.scaleToMap = scaleToMap
    poop.state = defaultState

    poop.animations = {}

    local image = love.graphics.newImage("poop_animations_16x16.bmp")

    poop.image = image
    poop.animations[POOP_DROPPED] = anim.NewAnimation(POOP_DROPPED)
    local yPos = 0
    local leashedClip = anim.NewClip(0, yPos, 1, QUAD_WIDTH, QUAD_HEIGHT, image)
    if (leashedClip) then
        table.insert(poop.animations[POOP_DROPPED].cliplist, leashedClip)
    end

    poop.hitbox = { tl = { x = 0, y = 0 }, br = { x = QUAD_WIDTH, y = QUAD_HEIGHT }}

    return poop
end

return p