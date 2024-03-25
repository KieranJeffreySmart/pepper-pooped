require"custextensions"
local anim = require"animation"
local log = require"log"
local tserial = require"Tserial"
local handleSerialisation = function () return '' end

pd2 = {}

PLAYER_UNLEASHING = 1
PLAYER_WAITING = 2
PLAYER_WAITING_TOP = 3

PLAYER_DEFAULT_QUAD_WIDTH = 32
PLAYER_DEFAULT_QUAD_HEIGHT = 64
PLAYER_DEFAULT_QUAD_HEIGHT_TOP = 32

function pd2.NewPlayer(defaultState, startLocation, defaultOrientation)
    local player = {}
    player.state = defaultState
    player.location = { x = startLocation.x, y = startLocation.y }
    player.orientation = defaultOrientation
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
    
    local topimage = love.graphics.newImage("player_animations_top_32x32.bmp")
    player.animations[PLAYER_WAITING_TOP] = anim.NewAnimation(PLAYER_WAITING_TOP)
    local waitingTopClip = anim.NewClip(0, 0, 2, PLAYER_DEFAULT_QUAD_WIDTH, PLAYER_DEFAULT_QUAD_HEIGHT_TOP, topimage)
    if (waitingTopClip) then
        table.insert(player.animations[PLAYER_WAITING_TOP].cliplist, waitingTopClip)
    end

    return player
end

return pd2