require"custextensions"
local anim = require"animation"
local log = require"log"
local tserial = require"Tserial"
local handleSerialisation = function () return '' end

dd2 = {}

DOG_LEASHED = 1
DOG_RUNNING = 2
DOG_POSITIONING = 3
DOG_POOPING = 4
DOG_WALKING = 5
DOG_SITTING = 6
DOG_SITTING_TOP = 7
DOG_DEFAULT_QUAD_WIDTH = 32
DOG_DEFAULT_QUAD_HEIGHT = 32

function dd2.NewDog(defaultState, location, scaleToMap)
    local dog = {}
    dog.state = defaultState
    dog.location = { x = location.x, y = location.y }
    dog.scaleToMap = scaleToMap
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
    
    local topimage = love.graphics.newImage("dog_animations_top_32x32.bmp")
    dog.animations[DOG_SITTING_TOP] = anim.NewAnimation(DOG_SITTING_TOP)
    local topsitclip = anim.NewClip(0, 0, 2, DOG_DEFAULT_QUAD_WIDTH, DOG_DEFAULT_QUAD_HEIGHT, topimage)
    if (topsitclip) then
        table.insert(dog.animations[DOG_SITTING_TOP].cliplist, topsitclip)
    end

    return dog
end

return dd2