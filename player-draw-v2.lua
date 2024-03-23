require"custextensions"
local anim = require"animation"
local log = require"log"
local tserial = require"Tserial"
local handleSerialisation = function () return '' end

pd2 = {}

PLAYER_UNLEASHING = 18
PLAYER_WAITING = 19
PLAYER_DEFAULT_QUAD_WIDTH = 32
PLAYER_DEFAULT_QUAD_HEIGHT = 64

function pd2.NewPlayer(defaultState, startLocation)
    local player = {}
    player.state = defaultState
    player.location = startLocation
    player.defaultState = defaultState

    player.animations = {}

    local image = love.graphics.newImage("player_animations_32x64.bmp")

    player.animations[PLAYER_UNLEASHING] = anim.NewAnimation(PLAYER_UNLEASHING)
    local yPos = 0
    local unleashingClip = anim.NewClip(0, yPos, 2, PLAYER_DEFAULT_QUAD_WIDTH,  PLAYER_DEFAULT_QUAD_HEIGHT, image)
    if (unleashingClip) then
        player.animations[PLAYER_UNLEASHING].cliplist[1] = unleashingClip
        player.animations[PLAYER_UNLEASHING].cliplist[2] = unleashingClip
        player.animations[PLAYER_UNLEASHING].cliplist[3] = unleashingClip
    end

    player.animations[PLAYER_WAITING] = anim.NewAnimation(PLAYER_WAITING)
    yPos = PLAYER_DEFAULT_QUAD_HEIGHT
    local waitingClip = anim.NewClip(0, yPos, 2, PLAYER_DEFAULT_QUAD_WIDTH,  PLAYER_DEFAULT_QUAD_HEIGHT, image)
    if (waitingClip) then
        player.animations[PLAYER_WAITING].cliplist[1] = unleashingClip
    end

    return player
end

function pd2.updateNextFrame(player)
    return true
end

function pd2.updateNextClip(player)
    -- nothing to do here, do I really need this?
    return true
end

return pd2