

p = {}

PLAYER_UNLEASHING = 18
PLAYER_WAITING = 19
PLAYER_DEFAULT_BOX_X = 16
PLAYER_DEFAULT_BOX_Y = -16

function p.NewPlayer(max_duration, fps)
    local player = {}
    
    player.state = 0
    player.location = {}
    player.location.x = 1
    player.location.y = 1
    player.scalepx = 1
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

    local ua_image = love.graphics.newImage("owner_32x64.bmp") 
    player.unleashing_anim.image = ua_image
    player.unleashing_anim.quadHeight = ua_image:getHeight()
    player.unleashing_anim.quadWidth = ua_image:getWidth()
    player.unleashing_anim.quad = love.graphics.newQuad(0, 0, player.unleashing_anim.quadWidth, player.unleashing_anim.quadHeight, ua_image:getDimensions())

    local w_image = love.graphics.newImage("owner_32x64.bmp")
    player.waiting_anim.image = w_image
    player.waiting_anim.quadHeight = w_image:getHeight()
    player.waiting_anim.quadWidth = w_image:getWidth()
    player.waiting_anim.quad = love.graphics.newQuad(0, 0, player.waiting_anim.quadWidth, player.waiting_anim.quadHeight, w_image:getDimensions())

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
        anim.DrawAnimation(player.unleashing_anim, player.locationpx.x, player.locationpx.y, player.scalepx)
    elseif player.state == PLAYER_WAITING then
        anim.DrawAnimation(player.waiting_anim, player.locationpx.x, player.locationpx.y, player.scalepx)
    end
end
return p