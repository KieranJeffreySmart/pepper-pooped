
g = {}

function g.NewMessage(max_duration, fps, scene_x, scene_y)
    local goodbye = {}
    
    goodbye.scalepx = 3
    goodbye.locationpx = {}
    goodbye.locationpx.x = 0
    goodbye.locationpx.y = 0

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

    local image = love.graphics.newImage("dog2_32x32.bmp") 
    goodbye.message_anim.image = image
    goodbye.message_anim.quadHeight = image:getHeight()
    goodbye.message_anim.quadWidth = image:getWidth()
    goodbye.message_anim.quad = love.graphics.newQuad(0, 0, goodbye.message_anim.quadWidth, goodbye.message_anim.quadHeight, image:getDimensions())

    return goodbye
end

function g.AnimateMessage(dt, goodbye)
    goodbye.message_anim.frame_duration = goodbye.message_anim.frame_duration - dt
    if goodbye.message_anim.frame_duration <= 0 then -- remember we are working from after frame 1   
        anim.AdvanceFrame(goodbye.message_anim)
        goodbye.message_anim.xupdate = 60 * (goodbye.message_anim.total_frame_count - 1)
    end
end
return g