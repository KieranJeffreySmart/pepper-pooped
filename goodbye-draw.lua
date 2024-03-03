
g = {}

function g.NewMessage(max_duration, fps)
    local goodbye = {}
    goodbye.message_anim = {}
    goodbye.message_anim.max_duration = EXIT_CUTSCENE_DURATION
    goodbye.message_anim.max_frame_duration = goodbye.message_anim.max_duration / EXIT_CUTSCENE_FPS
    goodbye.message_anim.frame = 1
    goodbye.message_anim.total_frame_count = 1
    goodbye.message_anim.frame_duration = goodbye.message_anim.max_frame_duration
    goodbye.message_anim.frame_count = 4
    goodbye.message_anim.xincrement = 60
    goodbye.message_anim.xupdate = 0
    goodbye.message_anim.playtime = 0

    goodbye.message_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    goodbye.message_anim.quad = love.graphics.newQuad(EXIT_CUTSCENE_X, EXIT_CUTSCENE_Y, 32, 32, goodbye.message_anim.image:getDimensions())

    return goodbye
end

return g