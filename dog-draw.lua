d = {}

DOG_LEASHED = 12
DOG_RUNNING = 13
DOG_POSITIONING = 14
DOG_POOPING = 15
DOG_WALKING = 16
DOG_WAITING = 17
DOG_DEFAULT_BOX_X = 16
DOG_DEFAULT_BOX_Y = -16

function d.NewDog(max_duration, fps)
    local dog = {}
    dog.state = 0
    dog.location = {}
    dog.location.x = 1
    dog.location.y = 1
    dog.scalepx = 1
    dog.locationpx = {}
    dog.locationpx.x = 0
    dog.locationpx.y = 0

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

    local l_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.leashed_anim.image = l_image
    dog.leashed_anim.quadHeight = l_image:getHeight()
    dog.leashed_anim.quadWidth = l_image:getWidth()
    dog.leashed_anim.quad = love.graphics.newQuad(0, 0, dog.leashed_anim.quadWidth, dog.leashed_anim.quadHeight, l_image:getDimensions())

    local r_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.running_anim.image = r_image
    dog.running_anim.quadHeight = r_image:getHeight()
    dog.running_anim.quadWidth = r_image:getWidth()
    dog.running_anim.quad = love.graphics.newQuad(0, 0, dog.running_anim.quadWidth, dog.running_anim.quadHeight, r_image:getDimensions())

    local p_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.positioning_anim.image = p_image
    dog.positioning_anim.quadHeight = p_image:getHeight()
    dog.positioning_anim.quadWidth = p_image:getWidth()
    dog.positioning_anim.quad = love.graphics.newQuad(0, 0, dog.positioning_anim.quadWidth, dog.positioning_anim.quadHeight, p_image:getDimensions())

    local pp_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.pooping_anim.image = pp_image
    dog.pooping_anim.quadHeight = pp_image:getHeight()
    dog.pooping_anim.quadWidth = pp_image:getWidth()
    dog.pooping_anim.quad = love.graphics.newQuad(0, 0, dog.pooping_anim.quadWidth, dog.pooping_anim.quadHeight, pp_image:getDimensions())

    local w_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.walking_anim.image = w_image
    dog.walking_anim.quadHeight = w_image:getHeight()
    dog.walking_anim.quadWidth = w_image:getWidth()
    dog.walking_anim.quad = love.graphics.newQuad(0, 0, dog.walking_anim.quadWidth, dog.walking_anim.quadHeight, l_image:getDimensions())

    local wt_image = love.graphics.newImage("dog_32x32.bmp") 
    dog.waiting_anim.image = wt_image
    dog.waiting_anim.quadHeight = wt_image:getHeight()
    dog.waiting_anim.quadWidth = wt_image:getWidth()
    dog.waiting_anim.quad = love.graphics.newQuad(0, 0, dog.waiting_anim.quadWidth, dog.waiting_anim.quadHeight, l_image:getDimensions())
    return dog
end

function d.AnimateDog(dt, dog, map)
    if dog.state == DOG_LEASHED then
        dog.leashed_anim.frame_duration = dog.leashed_anim.frame_duration - dt
        if dog.leashed_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(dog.leashed_anim)
        end
    elseif dog.state == DOG_RUNNING then
        dog.running_anim.frame_duration = dog.running_anim.frame_duration - dt
        if dog.running_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(dog.running_anim)
            local randomLocation = GetRandomAvailableLocation(map.gridmap, map.gridsize)
            dog.location.x = randomLocation.x
            dog.location.y = randomLocation.y
            if(dog.running_anim.playtime >= dog.running_anim.max_duration) then
                dog.location.x = dog.pooplocation.x
                dog.location.y = dog.pooplocation.y
                dog.state = DOG_POSITIONING
            end
        end 
    elseif dog.state == DOG_POSITIONING then
        dog.positioning_anim.frame_duration = dog.positioning_anim.frame_duration - dt
        if dog.positioning_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(dog.positioning_anim)
        end
        if(dog.positioning_anim.playtime >= dog.positioning_anim.max_duration) then
            dog.state = DOG_POOPING
        end
    elseif dog.state == DOG_POOPING then
        dog.pooping_anim.frame_duration = dog.pooping_anim.frame_duration - dt
        if dog.pooping_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(dog.pooping_anim)
        end
        
        if(dog.pooping_anim.playtime >= dog.pooping_anim.max_duration) then
            dog.state = DOG_WALKING
        end
    elseif dog.state == DOG_WALKING then
        dog.walking_anim.frame_duration = dog.walking_anim.frame_duration - dt
        if dog.walking_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(dog.walking_anim)
        
            if (dog.location.x > 1) then
                dog.location.x = dog.location.x -1
            else
                if (dog.location.y > 1) then
                    dog.location.y = dog.location.y -1
                end
            end
            if(dog.walking_anim.playtime >= dog.walking_anim.max_duration) then
                dog.state = DOG_WAITING
            end
        end
    elseif dog.state == DOG_WAITING then
        dog.waiting_anim.frame_duration = dog.waiting_anim.frame_duration - dt
        if dog.waiting_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(dog.waiting_anim)
        end
    else
        dog.state = DOG_LEASHED
    end
end

function d.DrawDog(dog)

    if dog.state == DOG_LEASHED then
        anim.DrawAnimation(dog.leashed_anim, dog.locationpx.x, dog.locationpx.y, dog.scalepx)
        --write title
    elseif dog.state == DOG_RUNNING then
        anim.DrawAnimation(dog.running_anim, dog.locationpx.x, dog.locationpx.y, dog.scalepx)
    elseif dog.state == DOG_POSITIONING then
        anim.DrawAnimation(dog.positioning_anim, dog.locationpx.x, dog.locationpx.y, dog.scalepx)
        --write title
    elseif dog.state == DOG_POOPING then
        anim.DrawAnimation(dog.pooping_anim, dog.locationpx.x, dog.locationpx.y, dog.scalepx)
        --
    elseif dog.state == DOG_WALKING then
        love.graphics.print("here!", PLAYER_SPEACH_X, PLAYER_SPEACH_Y)
        anim.DrawAnimation(dog.walking_anim, dog.locationpx.x, dog.locationpx.y, dog.scalepx)
    elseif dog.state == DOG_WAITING then
        anim.DrawAnimation(dog.waiting_anim, dog.locationpx.x, dog.locationpx.y, dog.scalepx)
    end
end
return d