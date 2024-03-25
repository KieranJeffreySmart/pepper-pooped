require"custextensions"
local log = require"log"
local tserial = require"Tserial"

local anim = {}
anim.fps = 2
anim.frame_duration = 1/anim.fps
anim.current_frame_playtime = 0
local handleSerialisation = function () return '' end

function anim.cutQuads(startX, startY, frames, width, height, image)
    local quads = {}
    for i = 1, frames do
        quads[i] = love.graphics.newQuad(startX + width * (i-1), startY, width, height, image:getDimensions())
    end
    return quads
end

function anim.NewClip(xPos, yPos, frames, width, height, image)
    local clip = {}
    clip.quads = anim.cutQuads(xPos, yPos, frames, width, height, image)
    clip.frames = {}
    clip.frames.ittr = false
    clip.frames.next = function ()
        --log.debug("frames.next")
        if (not clip.frames.ittr) then clip.frames.ittr = table.CreateIterator(clip.quads) end

        clip.frame = clip.frames.ittr()
        --if not clip.frame then log.debug("no frame") end
        return clip.frame
    end

    clip.frames.first = function ()
        clip.frames.ittr = table.CreateIterator(clip.quads)
        return clip.frames.next()
    end
    
    clip.frames.reset = function ()
        clip.frames.ittr = table.CreateIterator(clip.quads)
    end

    clip.repeatForSeconds = 0
    clip.playtime = 0
    clip.quadWidth = width
    clip.quadHeight = height
    clip.image = image

    return clip
end

function anim.NewAnimation(id)
    local animation = {}
    animation.id = id
    animation.cliplist = {}
    animation.clips = {}
    animation.clips.ittr = false
    animation.clips.next = function ()
        if (not animation.clips.ittr) then
            animation.clips.ittr = table.CreateIterator(animation.cliplist)
        end

        if (animation.clip) then animation.clip.frames.first() end
        animation.clip = animation.clips.ittr()
        if (animation.clip) then animation.clip.frames.first() end
        return animation.clip
    end
    animation.clips.first = function ()
        animation.clips.ittr = table.CreateIterator(animation.cliplist)
        return animation.clips.next()
    end

    return animation
end

function anim.AdvanceFrameTimer(dt)
    anim.current_frame_playtime = anim.current_frame_playtime + dt
    if anim.current_frame_playtime >= anim.frame_duration then
        local playtime = anim.current_frame_playtime
        anim.current_frame_playtime = 0
        return playtime
    end

    return 0
end

local function AdvanceFrame(clip)
    --log.debug("repeat for :", clip.repeatForSeconds, " t: ", clip.playtime)
    local shouldRepeat = clip.repeatForSeconds > 0 and clip.playtime < clip.repeatForSeconds
    
    if (not clip.frames.next() ) then
        --log.debug("failed next frame")
        if (shouldRepeat) then
            clip.frames.first()
        else        
            return false
        end
    end

    return true
end

function anim.AdvanceAnimation(playtime, animation)
    --"advance animation: ", animation.id)
    if (not animation.clip) then
        animation.clip = animation.clips.first()
        animation.clip.playtime = 0
        --log.debug("first clip")
    else
        animation.clip.playtime = animation.clip.playtime + playtime

        if (AdvanceFrame(animation.clip)) then
            --log.debug("next frame")
        else
            if(animation.clips.next()) then
                animation.clip.playtime = 0
                --log.debug("next clip")
            else
                animation.clips.first()
                --log.debug("animation ended")
                return false
            end
        end
    end
    return true
end

return anim