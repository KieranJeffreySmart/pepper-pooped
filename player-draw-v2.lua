

pd2 = {}

PLAYER_UNLEASHING = 18
PLAYER_WAITING = 19
PLAYER_DEFAULT_BOX_X = 16
PLAYER_DEFAULT_BOX_Y = -16

function pd2.NewPlayer(max_duration, fps, defaultState, defaultLocation)
    local player = {}
    
    player.state = defaultState
    player.location = {}
    player.location.x = defaultLocation.x
    player.location.y = defaultLocation.y
    player.defaultState = defaultState

    player.animations = {}
    player.animations[PLAYER_UNLEASHING] = {}
    player.animations[PLAYER_UNLEASHING].max_duration = 2
    player.animations[PLAYER_UNLEASHING].max_frame_duration = player.animations[PLAYER_UNLEASHING].max_duration / fps
    player.animations[PLAYER_UNLEASHING].frame = 1
    player.animations[PLAYER_UNLEASHING].total_frame_count = 1
    player.animations[PLAYER_UNLEASHING].frame_duration = player.animations[PLAYER_UNLEASHING].max_frame_duration
    player.animations[PLAYER_UNLEASHING].frame_count = 4
    player.animations[PLAYER_UNLEASHING].playtime = 0

    local ua_image = love.graphics.newImage("owner_32x64.bmp")
    player.animations[PLAYER_UNLEASHING].image = ua_image
    player.animations[PLAYER_UNLEASHING].quadHeight = ua_image:getHeight()
    player.animations[PLAYER_UNLEASHING].quadWidth = ua_image:getWidth()
    player.animations[PLAYER_UNLEASHING].quad = love.graphics.newQuad(0, 0, player.animations[PLAYER_UNLEASHING].quadWidth, player.animations[PLAYER_UNLEASHING].quadHeight, ua_image:getDimensions())

    player.animations[PLAYER_WAITING] = {}
    player.animations[PLAYER_WAITING].max_duration = max_duration
    player.animations[PLAYER_WAITING].max_frame_duration = player.animations[PLAYER_WAITING].max_duration / fps
    player.animations[PLAYER_WAITING].frame = 1
    player.animations[PLAYER_WAITING].total_frame_count = 1
    player.animations[PLAYER_WAITING].frame_duration = player.animations[PLAYER_WAITING].max_frame_duration
    player.animations[PLAYER_WAITING].frame_count = 4
    player.animations[PLAYER_WAITING].playtime = 0

    local w_image = love.graphics.newImage("owner_32x64.bmp")
    player.animations[PLAYER_WAITING].image = w_image
    player.animations[PLAYER_WAITING].quadHeight = w_image:getHeight()
    player.animations[PLAYER_WAITING].quadWidth = w_image:getWidth()
    player.animations[PLAYER_WAITING].quad = love.graphics.newQuad(0, 0, player.animations[PLAYER_WAITING].quadWidth, player.animations[PLAYER_WAITING].quadHeight, w_image:getDimensions())

    return player
end


function pd2.AnimatePlayer(dt, player)
    if player.state == PLAYER_UNLEASHING then
        player.animations[PLAYER_UNLEASHING].frame_duration = player.animations[PLAYER_UNLEASHING].frame_duration - dt
        if player.animations[PLAYER_UNLEASHING].frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.AdvanceFrame(player.animations[PLAYER_UNLEASHING])
            if(player.animations[PLAYER_UNLEASHING].playtime >= player.animations[PLAYER_UNLEASHING].max_duration) then
                player.state = PLAYER_WAITING
            end
        end
    elseif player.state == PLAYER_WAITING then
        player.animations[PLAYER_WAITING].frame_duration = player.animations[PLAYER_WAITING].frame_duration - dt
        if player.animations[PLAYER_WAITING].frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.AdvanceFrame(player.animations[PLAYER_WAITING])
        end
    else
        player.state = PLAYER_UNLEASHING
    end
end

function pd2.UpdateOnAnimationFrame(player)
    return false
end

function pd2.UpdateOnAnimationComplete(player)
    if player.state == PLAYER_UNLEASHING then
        player.state = PLAYER_WAITING
    else
        player.state = player.defaultState
    end
end

return pd2