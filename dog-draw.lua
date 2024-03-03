d = {}

function d.NewDog(max_duration, fps)
    local dog = {}
    dog.leashed_anim = {}
    dog.leashed_anim.max_duration = 5
    dog.leashed_anim.max_frame_duration = dog.leashed_anim.max_duration / fps
    dog.leashed_anim.frame = 1
    dog.leashed_anim.total_frame_count = 1
    dog.leashed_anim.frame_duration = dog.leashed_anim.max_frame_duration
    dog.leashed_anim.frame_count = 4
    dog.leashed_anim.playtime = 0

    dog.running_anim = {}
    dog.running_anim.max_duration = 10
    dog.running_anim.max_frame_duration = dog.running_anim.max_duration / fps
    dog.running_anim.frame = 1
    dog.running_anim.total_frame_count = 1
    dog.running_anim.frame_duration = dog.running_anim.max_frame_duration
    dog.running_anim.frame_count = 4
    dog.running_anim.playtime = 0

    dog.positioning_anim = {}
    dog.positioning_anim.max_duration = 3
    dog.positioning_anim.max_frame_duration = dog.positioning_anim.max_duration / fps
    dog.positioning_anim.frame = 1
    dog.positioning_anim.total_frame_count = 1
    dog.positioning_anim.frame_duration = dog.positioning_anim.max_frame_duration
    dog.positioning_anim.frame_count = 4
    dog.positioning_anim.playtime = 0

    dog.pooping_anim = {}
    dog.pooping_anim.max_duration = 2
    dog.pooping_anim.max_frame_duration = dog.pooping_anim.max_duration / fps
    dog.pooping_anim.frame = 1
    dog.pooping_anim.total_frame_count = 1
    dog.pooping_anim.frame_duration = dog.pooping_anim.max_frame_duration
    dog.pooping_anim.frame_count = 4
    dog.pooping_anim.playtime = 0

    dog.walking_anim = {}
    dog.walking_anim.max_duration = 3
    dog.walking_anim.max_frame_duration = dog.walking_anim.max_duration / fps
    dog.walking_anim.frame = 1
    dog.walking_anim.total_frame_count = 1
    dog.walking_anim.frame_duration = dog.walking_anim.max_frame_duration
    dog.walking_anim.frame_count = 4
    dog.walking_anim.playtime = 0

    dog.waiting_anim = {}
    dog.waiting_anim.max_duration = max_duration
    dog.waiting_anim.max_frame_duration = dog.waiting_anim.max_duration / fps
    dog.waiting_anim.frame = 1
    dog.waiting_anim.total_frame_count = 1
    dog.waiting_anim.frame_duration = dog.waiting_anim.max_frame_duration
    dog.waiting_anim.frame_count = 4
    dog.waiting_anim.playtime = 0

    dog.leashed_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog.leashed_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog.leashed_anim.image:getDimensions())

    dog.running_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog.running_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog.running_anim.image:getDimensions())

    dog.positioning_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog.positioning_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog.positioning_anim.image:getDimensions())

    dog.pooping_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog.pooping_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog.pooping_anim.image:getDimensions())

    dog.walking_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog.walking_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog.walking_anim.image:getDimensions())

    dog.waiting_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog.waiting_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog.waiting_anim.image:getDimensions())

    return dog
end

return d