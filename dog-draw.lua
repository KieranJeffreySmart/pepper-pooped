d = {}

DOG_LEASHED = 12
DOG_RUNNING = 13
DOG_POSITIONING = 14
DOG_POOPING = 15
DOG_WALKING = 16
DOG_SITTING = 17
DOG_DEFAULT_BOX_X = 16
DOG_DEFAULT_BOX_Y = -16

function d.NewDog(max_duration, fps, defaultState, startLocation, pooplocation, sitlocation)
    local dog = {}
    dog.state = defaultState
    dog.location = startLocation
    dog.defaultState = defaultState
    dog.pooplocation = pooplocation
    dog.sitlocation = sitlocation

    dog.animations = {}
    dog.animations[DOG_LEASHED] = {}
    dog.animations[DOG_LEASHED].max_duration = 5
    dog.animations[DOG_LEASHED].max_frame_duration = dog.animations[DOG_LEASHED].max_duration / fps
    dog.animations[DOG_LEASHED].frame = 1
    dog.animations[DOG_LEASHED].total_frame_count = 1
    dog.animations[DOG_LEASHED].frame_duration = dog.animations[DOG_LEASHED].max_frame_duration
    dog.animations[DOG_LEASHED].frame_count = 4
    dog.animations[DOG_LEASHED].playtime = 0

    dog.animations[DOG_RUNNING] = {}
    dog.animations[DOG_RUNNING].max_duration = 10
    dog.animations[DOG_RUNNING].max_frame_duration = dog.animations[DOG_RUNNING].max_duration / fps
    dog.animations[DOG_RUNNING].frame = 1
    dog.animations[DOG_RUNNING].total_frame_count = 1
    dog.animations[DOG_RUNNING].frame_duration = dog.animations[DOG_RUNNING].max_frame_duration
    dog.animations[DOG_RUNNING].frame_count = 4
    dog.animations[DOG_RUNNING].playtime = 0

    dog.animations[DOG_POSITIONING] = {}
    dog.animations[DOG_POSITIONING].max_duration = 3
    dog.animations[DOG_POSITIONING].max_frame_duration = dog.animations[DOG_POSITIONING].max_duration / fps
    dog.animations[DOG_POSITIONING].frame = 1
    dog.animations[DOG_POSITIONING].total_frame_count = 1
    dog.animations[DOG_POSITIONING].frame_duration = dog.animations[DOG_POSITIONING].max_frame_duration
    dog.animations[DOG_POSITIONING].frame_count = 4
    dog.animations[DOG_POSITIONING].playtime = 0

    dog.animations[DOG_POOPING] = {}
    dog.animations[DOG_POOPING].max_duration = 2
    dog.animations[DOG_POOPING].max_frame_duration = dog.animations[DOG_POOPING].max_duration / fps
    dog.animations[DOG_POOPING].frame = 1
    dog.animations[DOG_POOPING].total_frame_count = 1
    dog.animations[DOG_POOPING].frame_duration = dog.animations[DOG_POOPING].max_frame_duration
    dog.animations[DOG_POOPING].frame_count = 4
    dog.animations[DOG_POOPING].playtime = 0

    dog.animations[DOG_WALKING] = {}
    dog.animations[DOG_WALKING].max_duration = 3
    dog.animations[DOG_WALKING].max_frame_duration = dog.animations[DOG_WALKING].max_duration / fps
    dog.animations[DOG_WALKING].frame = 1
    dog.animations[DOG_WALKING].total_frame_count = 1
    dog.animations[DOG_WALKING].frame_duration = dog.animations[DOG_WALKING].max_frame_duration
    dog.animations[DOG_WALKING].frame_count = 4
    dog.animations[DOG_WALKING].playtime = 0

    dog.animations[DOG_SITTING] = {}
    dog.animations[DOG_SITTING].max_duration = max_duration
    dog.animations[DOG_SITTING].max_frame_duration = dog.animations[DOG_SITTING].max_duration / fps
    dog.animations[DOG_SITTING].frame = 1
    dog.animations[DOG_SITTING].total_frame_count = 1
    dog.animations[DOG_SITTING].frame_duration = dog.animations[DOG_SITTING].max_frame_duration
    dog.animations[DOG_SITTING].frame_count = 4
    dog.animations[DOG_SITTING].playtime = 0

    local l_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.animations[DOG_LEASHED].image = l_image
    dog.animations[DOG_LEASHED].quadHeight = l_image:getHeight()
    dog.animations[DOG_LEASHED].quadWidth = l_image:getWidth()
    dog.animations[DOG_LEASHED].quad = love.graphics.newQuad(0, 0, dog.animations[DOG_LEASHED].quadWidth, dog.animations[DOG_LEASHED].quadHeight, l_image:getDimensions())

    local r_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.animations[DOG_RUNNING].image = r_image
    dog.animations[DOG_RUNNING].quadHeight = r_image:getHeight()
    dog.animations[DOG_RUNNING].quadWidth = r_image:getWidth()
    dog.animations[DOG_RUNNING].quad = love.graphics.newQuad(0, 0, dog.animations[DOG_RUNNING].quadWidth, dog.animations[DOG_RUNNING].quadHeight, r_image:getDimensions())

    local p_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.animations[DOG_POSITIONING].image = p_image
    dog.animations[DOG_POSITIONING].quadHeight = p_image:getHeight()
    dog.animations[DOG_POSITIONING].quadWidth = p_image:getWidth()
    dog.animations[DOG_POSITIONING].quad = love.graphics.newQuad(0, 0, dog.animations[DOG_POSITIONING].quadWidth, dog.animations[DOG_POSITIONING].quadHeight, p_image:getDimensions())

    local pp_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.animations[DOG_POOPING].image = pp_image
    dog.animations[DOG_POOPING].quadHeight = pp_image:getHeight()
    dog.animations[DOG_POOPING].quadWidth = pp_image:getWidth()
    dog.animations[DOG_POOPING].quad = love.graphics.newQuad(0, 0, dog.animations[DOG_POOPING].quadWidth, dog.animations[DOG_POOPING].quadHeight, pp_image:getDimensions())

    local w_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.animations[DOG_WALKING].image = w_image
    dog.animations[DOG_WALKING].quadHeight = w_image:getHeight()
    dog.animations[DOG_WALKING].quadWidth = w_image:getWidth()
    dog.animations[DOG_WALKING].quad = love.graphics.newQuad(0, 0, dog.animations[DOG_WALKING].quadWidth, dog.animations[DOG_WALKING].quadHeight, l_image:getDimensions())

    local wt_image = love.graphics.newImage("dog_32x32.bmp")
    dog.animations[DOG_SITTING].image = wt_image
    dog.animations[DOG_SITTING].quadHeight = wt_image:getHeight()
    dog.animations[DOG_SITTING].quadWidth = wt_image:getWidth()
    dog.animations[DOG_SITTING].quad = love.graphics.newQuad(0, 0, dog.animations[DOG_SITTING].quadWidth, dog.animations[DOG_SITTING].quadHeight, l_image:getDimensions())
    return dog
end

function d.UpdateOnAnimationFrame(dog, map)
    if dog.state == DOG_RUNNING then
        local randomLocation = mapping.GetRandomAvailableLocation(map.gridmap, map.gridsize)
        dog.location.x = randomLocation.x
        dog.location.y = randomLocation.y
    elseif dog.state == DOG_WALKING then
        if (dog.location.x > dog.sitlocation.x) then
            dog.location.x = dog.location.x -1
        elseif (dog.location.x < dog.sitlocation.x) then
            dog.location.x = dog.location.x +1
        end
        if (dog.location.y > dog.sitlocation.y) then
                dog.location.y = dog.location.y -1
        elseif (dog.location.y < dog.sitlocation.y) then
            dog.location.y = dog.location.y +1
        end
    end
end

function d.UpdateOnAnimationComplete(dog)
    if dog.state == DOG_RUNNING then
        dog.location = dog.pooplocation
        dog.state = DOG_POSITIONING
    elseif dog.state == DOG_POSITIONING then
            dog.state = DOG_POOPING
    elseif dog.state == DOG_POOPING then
            dog.state = DOG_WALKING
    elseif dog.state == DOG_WALKING then
        dog.state = DOG_SITTING
    else
        dog.state = dog.defaultState
    end
end

return d