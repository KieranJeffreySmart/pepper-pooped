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

function dd2.NewDog(defaultState, startLocation)
    local dog = {}
    dog.state = defaultState
    dog.location = startLocation
    dog.defaultState = defaultState

    dog.animations = {}

    local image = love.graphics.newImage("dog_animations_32x32.bmp")

    dog.animations[DOG_LEASHED] = anim.NewAnimation(DOG_LEASHED)
    local yPos = 0
    local leashedClip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (leashedClip) then
        table.insert(dog.animations[DOG_LEASHED].cliplist, leashedClip)
    end

    dog.animations[DOG_RUNNING] = anim.NewAnimation(DOG_RUNNING)
    yPos = DOG_DEFAULT_QUAD_HEIGHT
    local runclip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (runclip) then
        runclip.repeatForSeconds = 5
        table.insert(dog.animations[DOG_RUNNING].cliplist, runclip)
    end

    dog.animations[DOG_POOPING] = anim.NewAnimation(DOG_POOPING)
    yPos = DOG_DEFAULT_QUAD_HEIGHT*2
    local positionclip = anim.NewClip(0, yPos, 4, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (positionclip) then
        table.insert(dog.animations[DOG_POOPING].cliplist, positionclip)
    end

    yPos = DOG_DEFAULT_QUAD_HEIGHT*3
    local firstpoopclip = anim.NewClip(0, yPos, 4, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (firstpoopclip) then
        table.insert(dog.animations[DOG_POOPING].cliplist, firstpoopclip)
    end

    local morepoopclip = anim.NewClip(DOG_DEFAULT_QUAD_WIDTH*3, yPos, 4, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (morepoopclip) then
        morepoopclip.repeatForSeconds = 5
        table.insert(dog.animations[DOG_POOPING].cliplist, morepoopclip)
    end

    dog.animations[DOG_WALKING] = anim.NewAnimation(DOG_WALKING)
    yPos = DOG_DEFAULT_QUAD_HEIGHT * 4
    local sitclip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (sitclip) then
        table.insert(dog.animations[DOG_WALKING].cliplist, sitclip)
    end

    dog.animations[DOG_SITTING] = anim.NewAnimation(DOG_SITTING)
    yPos = DOG_DEFAULT_QUAD_HEIGHT * 5
    local sitclip = anim.NewClip(0, yPos, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, image)
    if (sitclip) then
        table.insert(dog.animations[DOG_SITTING].cliplist, sitclip)
    end

    return dog
end

return dd2