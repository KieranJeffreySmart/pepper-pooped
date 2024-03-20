require"extensions"

local anim = {}
anim.fps = 2
anim.frame_duration = 1/anim.fps
anim.current_frame_playtime = 0

function anim.cutQuads(startX, startY, frames, width, height, image)
    local quads = {}
    for i = 0, frames-1 do
        quads[i] = love.graphics.newQuad(startX, startY + width * i, width, height, image:getDimensions())
    end
    return quads
end

function anim.NewClip(xPos, yPos, frames, width, height, image)
    local clip = {}
    clip.quads = anim.cutQuads(xPos, yPos, frames, width, height, image)
    clip.frames = {}
    clip.frames.next = function ()
        clip.frame = table.CreateIterator(clip.quads)
        return clip.frame
    end
    clip.frames.first = function ()
        clip.frames.next = table.CreateIterator(clip.quads)
        clip.frame = clip.frames.next()
        return clip.frame
    end
end

function anim.NewAnimation()
    local animation = {}
    animation.cliplist = {}
    animation.clips = {}
    animation.clips.next = function()
        animation.clip = table.CreateIterator(animation.cliplist)
        return animation.clip
    end
    animation.clips.first = function ()
        animation.cliplist.next = table.CreateIterator(animation.cliplist)
        animation.clip = animation.cliplist.next()
        return animation.clip
    end

    return animation
end

function anim.AdvanceFrameTimer(dt)
    anim.current_frame_playtime = anim.current_frame_playtime + dt
    if anim.current_frame_playtime < anim.frame_duration then
        return true
    end

    anim.current_frame_playtime = 0
    return false
end

function anim.AdvanceAnimation(dt, animation, updateNextFrame, updateNextClip, updateAnimationCompleted)
    local clip = animation.clip
    if (not clip) then
        clip = animation.clips.first()

    end

    clip.playtime = clip.playtime + dt

    local shouldRepeat = clip.repeatForSeconds > 0
    if (shouldRepeat and clip.playtime >= clip.repeatForSeconds) then
        updateNextClip()
        return
    end

    if (clip.frames.next()) then
        updateNextFrame()
    else
        if (shouldRepeat) then
            clip.frames.first()
        else
            if(animation.clips.next()) then
                updateNextClip()
            else
                updateAnimationCompleted()
            end
        end
    end
end

return anim