
g = {}

function g.NewMessage(max_duration, fps, scene_x, scene_y)
    local goodbye = {}
    goodbye.message_anim = {}
    goodbye.message_anim.max_duration = max_duration
    goodbye.message_anim.max_frame_duration = goodbye.message_anim.max_duration / fps
    goodbye.message_anim.frame = 1
    goodbye.message_anim.total_frame_count = 1
    goodbye.message_anim.frame_duration = goodbye.message_anim.max_frame_duration
    goodbye.message_anim.frame_count = 4
    goodbye.message_anim.xincrement = 60
    goodbye.message_anim.xupdate = 0
    goodbye.message_anim.playtime = 0

    goodbye.message_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    goodbye.message_anim.quad = love.graphics.newQuad(scene_x, scene_y, 32, 32, goodbye.message_anim.image:getDimensions())

    return goodbye
end

function g.AnimateMessage(dt, goodbye)
    goodbye.message_anim.frame_duration = goodbye.message_anim.frame_duration - dt
    if goodbye.message_anim.frame_duration <= 0 then -- remember we are working from after frame 1   
        anim.PlayAnimation(goodbye.message_anim)
        goodbye.message_anim.xupdate = 60 * (goodbye.message_anim.total_frame_count - 1)
    end
end

return g