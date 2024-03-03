

p = {}

PLAYER_UNLEASHING = 18
PLAYER_WAITING = 19
PLAYER_DEFAULT_BOX_X = 16
PLAYER_DEFAULT_BOX_Y = 32

function p.NewPlayer(max_duration, fps, scene_x, scene_y)
    local player = {}
    
    player.state = 0
    player.location = {}
    player.location.x = 0
    player.location.y = 1
    player.scalepx = INTRO_CUTSCENE_SCALE
    player.locationpx = {}
    player.locationpx.x = 0
    player.locationpx.y = 0

    player.unleashing_anim = {}
    player.unleashing_anim.max_duration = 2
    player.unleashing_anim.max_frame_duration = player.unleashing_anim.max_duration / fps
    player.unleashing_anim.frame = 1
    player.unleashing_anim.total_frame_count = 1
    player.unleashing_anim.frame_duration = player.unleashing_anim.max_frame_duration
    player.unleashing_anim.frame_count = 4
    player.unleashing_anim.playtime = 0

    player.waiting_anim = {}
    player.waiting_anim.max_duration = max_duration
    player.waiting_anim.max_frame_duration = player.waiting_anim.max_duration / fps
    player.waiting_anim.frame = 1
    player.waiting_anim.total_frame_count = 1
    player.waiting_anim.frame_duration = player.waiting_anim.max_frame_duration
    player.waiting_anim.frame_count = 4
    player.waiting_anim.playtime = 0

    
    player.unleashing_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    player.unleashing_anim.quad = love.graphics.newQuad(scene_x, scene_y, PLAYER_DEFAULT_BOX_X, PLAYER_DEFAULT_BOX_Y, player.unleashing_anim.image:getDimensions())

    player.waiting_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    player.waiting_anim.quad = love.graphics.newQuad(scene_x, scene_y, PLAYER_DEFAULT_BOX_X, PLAYER_DEFAULT_BOX_Y, player.waiting_anim.image:getDimensions())

    return player
end


function p.AnimatePlayer(dt, player)
    if player.state == PLAYER_UNLEASHING then
        player.unleashing_anim.frame_duration = player.unleashing_anim.frame_duration - dt
        if player.unleashing_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(player.unleashing_anim)
            if(player.unleashing_anim.playtime >= player.unleashing_anim.max_duration) then
                player.state = PLAYER_WAITING
            end
        end
    elseif player.state == PLAYER_WAITING then
        player.waiting_anim.frame_duration = player.waiting_anim.frame_duration - dt
        if player.waiting_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(player.waiting_anim)
        end
    else
        player.state = PLAYER_UNLEASHING
    end
end

function p.DrawPlayer(player)
    if player.state == PLAYER_UNLEASHING then
        anim.DrawAnimation(player.unleashing_anim, player.locationpx, player.scalepx)
    elseif player.state == PLAYER_WAITING then
        anim.DrawAnimation(player.waiting_anim, player.locationpx, player.scalepx)
    end
end
return p