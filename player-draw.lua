

p = {}

function p.NewPlayer(max_duration, fps)
    local player = {}
    
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
    player.unleashing_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, PLAYER_DEFAULT_BOX_X, PLAYER_DEFAULT_BOX_Y, player.unleashing_anim.image:getDimensions())

    player.waiting_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    player.waiting_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, PLAYER_DEFAULT_BOX_X, PLAYER_DEFAULT_BOX_Y, player.waiting_anim.image:getDimensions())

    return player
end

return p