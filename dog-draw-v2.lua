require"custextensions"
local anim = require"animation"
local log = require"log"
local tserial = require"Tserial"
local handleSerialisation = function () return '' end

dd2 = {}

DOG_LEASHED = 12
DOG_RUNNING = 13
DOG_POSITIONING = 14
DOG_POOPING = 15
DOG_WALKING = 16
DOG_SITTING = 17
DOG_DEFAULT_QUAD_WIDTH = 32
DOG_DEFAULT_QUAD_HEIGHT = 32

function dd2.NewDog(defaultState, startLocation, pooplocation, sitlocation)
    local dog = {}
    dog.state = defaultState
    dog.location = startLocation
    dog.defaultState = defaultState
    dog.pooplocation = pooplocation
    dog.sitlocation = sitlocation

    dog.animations = {}

    local image = love.graphics.newImage("dog_animations_32x32.bmp")

    dog.animations[DOG_LEASHED] = anim.NewAnimation(DOG_LEASHED)
    local yPos = 0
    local leashedClip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (leashedClip) then
        dog.animations[DOG_LEASHED].cliplist[1] = leashedClip
    end

    dog.animations[DOG_POOPING] = anim.NewAnimation(DOG_POOPING)
    yPos = DOG_DEFAULT_QUAD_HEIGHT*3
    local firstpoopclip = anim.NewClip(0, yPos, 4, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (firstpoopclip) then
        dog.animations[DOG_POOPING].cliplist[1] = firstpoopclip
    end

    local morepoopclip = anim.NewClip(DOG_DEFAULT_QUAD_WIDTH*3, yPos, 4, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (morepoopclip) then
        morepoopclip.repeatForSeconds = 5
        dog.animations[DOG_POOPING].cliplist[2] = morepoopclip
    end

    dog.animations[DOG_SITTING] = anim.NewAnimation(DOG_SITTING)
    yPos = DOG_DEFAULT_QUAD_HEIGHT*5
    local sitclip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (sitclip) then
        dog.animations[DOG_SITTING].cliplist[1] = sitclip
    end

    -- dog.animations[DOG_RUNNING] = anim.NewAnimation(DOG_RUNNING)
    -- yPos = DOG_DEFAULT_QUAD_HEIGHT
    -- local runningclip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    -- if (runningclip) then
    --     runningclip.repeatForSeconds = 3
    --     dog.animations[DOG_RUNNING].cliplist[1] = runningclip
    -- end

    -- dog.animations[DOG_POSITIONING] = anim.NewAnimation(DOG_POSITIONING)
    -- yPos = DOG_DEFAULT_QUAD_HEIGHT*2
    -- local lookforwardclip = anim.NewClip(0, yPos, 1, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    -- if (lookforwardclip) then
    --     lookforwardclip.repeatForSeconds = 2
    --     dog.animations[DOG_POSITIONING].cliplist[1] = lookforwardclip
    -- end
    -- local circleclip = anim.NewClip(DOG_DEFAULT_QUAD_WIDTH, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    -- if (circleclip) then
    --     circleclip.repeatForSeconds = 3
    --     dog.animations[DOG_POSITIONING].cliplist[2] = circleclip
    -- end
    -- local squatClip = anim.NewClip(DOG_DEFAULT_QUAD_WIDTH*3, yPos, 1, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    -- if (squatClip) then
    --     squatClip.repeatForSeconds = 1
    --     dog.animations[DOG_POSITIONING].cliplist[3] = squatClip
    -- end

    -- dog.animations[DOG_POOPING] = anim.NewAnimation(DOG_POOPING)
    -- yPos = DOG_DEFAULT_QUAD_HEIGHT*3
    -- local firstpoopclip = anim.NewClip(0, yPos, 4, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    -- if (firstpoopclip) then
    --     dog.animations[DOG_POOPING].cliplist[1] = firstpoopclip
    -- end
    -- local morepoopclip = anim.NewClip(DOG_DEFAULT_QUAD_WIDTH*3, yPos, 4, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    -- if (morepoopclip) then
    --     morepoopclip.repeatForSeconds = 5
    --     dog.animations[DOG_POOPING].cliplist[2] = morepoopclip
    -- end

    -- dog.animations[DOG_WALKING] = anim.NewAnimation(DOG_WALKING)
    -- yPos = DOG_DEFAULT_QUAD_HEIGHT*4
    -- local firstpoopclip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    -- if (firstpoopclip) then
    --     dog.animations[DOG_WALKING].cliplist[1] = firstpoopclip
    -- end

    -- dog.animations[DOG_SITTING] = anim.NewAnimation(DOG_SITTING)
    -- yPos = DOG_DEFAULT_QUAD_HEIGHT*5
    -- local firstpoopclip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    -- if (firstpoopclip) then
    --     dog.animations[DOG_SITTING].cliplist[1] = firstpoopclip
    -- end

    return dog
end

return dd2