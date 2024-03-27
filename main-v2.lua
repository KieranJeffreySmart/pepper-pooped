require"custextensions"
local log = require"log"
local anim = require"animation"
local tserial = require"Tserial"
local player_draw_v2 = require"player-draw-v2"
local dog_draw_v2 = require"dog-draw-v2"
local goodbye_draw = require"goodbye-drawV2"
local game_generator = require"game-generator"

LOOP_MENU = 1
LOOP_INTRO = 2
LOOP_PLAY = 3
LOOP_WIN = 4
LOOP_FAIL = 5
LOOP_EXIT = 6

EXIT_CUTSCENE = 7
EXIT_CLOSE = 8

INTRO_START = 9
INTRO_CUTSCENE = 10
INTRO_WAIT_INPUT = 11

INTRO_CELL_WIDTH = 40
INTRO_CELL_HEIGHT = 40

COMMAND_START = 's'
COMMAND_CONTINUE = 'c'
COMMAND_EXIT = 'x'
COMMAND_BACK = 'b'
COMMAND_NEWGAME = 'n'
COMMAND_RETRY = 'r'

COMMAND_UP = 'w'
COMMAND_DOWN = 's'
COMMAND_LEFT = 'a'
COMMAND_RIGHT = 'd'

ORIENTATION_RIGHT = 1
ORIENTATION_DOWN = 2
ORIENTATION_LEFT = 3
ORIENTATION_UP = 4

LoopState = 0
IntroState = 0
ExitState = 0

MAIN_MENU_X = 200
MAIN_MENU_Y = 150
INTRO_MENU_X = 200
INTRO_MENU_Y = 400

GAME_MESSAGE_X = 150
GAME_MESSAGE_Y = 50
PLAYER_SPEACH_X = 150
PLAYER_SPEACH_Y = 100

INTRO_CUTSCENE_X = 100
INTRO_CUTSCENE_Y = 100
INTRO_CUTSCENE_HEIGHT = 250
INTRO_CUTSCENE_WIDTH = 500
INTRO_CUTSCENE_SCALE = 1

PLAY_X = 100
PLAY_Y = 100
PLAY_HEIGHT = 600
PLAY_WIDTH = 600
PLAY_SCALE = 1

EXIT_CUTSCENE_X = 200
EXIT_CUTSCENE_Y = 250

local goodbye = goodbye_draw.NewMessage()
local game = {}
local player = {}
local dog = {}

log.outfile = "C:/Repos/pepper-pooped/log.txt"
local handleSerialisation = function () return '' end

local m = {}

function m.OnLoad()
    love.window.setMode( 1000, 800)
    math.randomseed( os.time() )
    LoopState = LOOP_MENU
end

local function IntroReset()
    --log.debug("reset intro ")
    game = game_generator.NewGame()
    player = player_draw_v2.NewPlayer(PLAYER_UNLEASHING, game.start)
    dog = dog_draw_v2.NewDog(DOG_LEASHED, game.start)

    anim.AdvanceAnimation(0, player.animations[player.state])
    anim.AdvanceAnimation(0, dog.animations[dog.state])
end

local function PlayReset()
    player = player_draw_v2.NewPlayer(PLAYER_WAITING_TOP, game.start, ORIENTATION_RIGHT)
    dog = dog_draw_v2.NewDog(DOG_SITTING_TOP, game.sitlocation)
    anim.AdvanceAnimation(0, player.animations[player.state])
    anim.AdvanceAnimation(0, dog.animations[dog.state])
    anim.AdvanceAnimation(0, game.poop.animations[game.poop.state])
end

local function DoGameCommand(input)
    if input == COMMAND_EXIT then
        LoopState = LOOP_EXIT
    end

    if input == COMMAND_UP then
        player.orientation = ORIENTATION_UP
        if (player.location.y > 1 and game.map.gridmap[player.location.x][player.location.y-1] ~= 'D') then
            player.location.y = player.location.y-1
        end         
    end
    
    if input == COMMAND_DOWN then
        player.orientation = ORIENTATION_DOWN
        if (player.location.y < game.map.gridsize.y and game.map.gridmap[player.location.x][player.location.y+1] ~= 'D') then
            player.location.y = player.location.y+1
        end
    end
    
    if input == COMMAND_LEFT then
        player.orientation = ORIENTATION_LEFT
        if (player.location.x > 1 and game.map.gridmap[player.location.x-1][player.location.y] ~= 'D') then
            player.location.x = player.location.x-1
        end         
    end
    
    if input == COMMAND_RIGHT then
        player.orientation = ORIENTATION_RIGHT
        if (player.location.x < game.map.gridsize.x and  game.map.gridmap[player.location.x+1][player.location.y] ~= 'D') then
            player.location.x = player.location.x+1
        end
    end
    
    log.debug("player location: ", player.location.x,'/', player.location.y)
    log.debug("poop location: ", game.poop.location.x,'/', game.poop.location.y)
end

function m.OnKeyreleased(key)
    if LoopState==LOOP_MENU then
        if key == COMMAND_START then
            IntroReset()
            LoopState = LOOP_INTRO
        elseif key == COMMAND_EXIT then
            LoopState = LOOP_EXIT
        end

    elseif LoopState == LOOP_INTRO then
        if key == COMMAND_CONTINUE then
            PlayReset()
            LoopState = LOOP_PLAY
        elseif key == COMMAND_BACK then
            LoopState = LOOP_MENU
        end

    elseif LoopState == LOOP_PLAY then
        DoGameCommand(key)
    elseif LoopState == LOOP_WIN or LoopState == LOOP_FAIL then
        if key == COMMAND_NEWGAME then
            IntroReset()
            LoopState = LOOP_INTRO
        elseif key == COMMAND_RETRY then
            PlayReset()
            LoopState = LOOP_PLAY
        elseif key == COMMAND_EXIT then
            LoopState = LOOP_EXIT
            ExitState = EXIT_CUTSCENE
        end
    end
end

local function UpdateIntroState(playtime)
    --log.debug("player state: ", player.state)
    if (player.state == PLAYER_UNLEASHING) then
        if (not anim.AdvanceAnimation(playtime, player.animations[player.state])) then
            player.state = PLAYER_WAITING
            dog.state = DOG_RUNNING
            IntroState = INTRO_CUTSCENE
            --log.debug("set dog to pooping ")
        end
    end
    if (player.state == PLAYER_WAITING) then
        if not anim.AdvanceAnimation(playtime, player.animations[player.state]) then
            player.animations[player.state].clip = false
            anim.AdvanceAnimation(playtime, player.animations[player.state])
        end
    end

    if (dog.state == DOG_RUNNING) then
        if (not anim.AdvanceAnimation(playtime, dog.animations[dog.state])) then
            dog.state = DOG_POOPING
            dog.location = { x = game.poop.location.x, y = game.poop.location.y }
        else
            local randomLocation = mapping.GetRandomAvailableLocation(game.map.gridmap, game.map.gridsize)
            dog.flipVirticle = dog.location.x > randomLocation.x
            dog.location = { x = randomLocation.x, y = randomLocation.y }
        end
    end

    if (dog.state == DOG_POOPING) then
        if (not anim.AdvanceAnimation(playtime, dog.animations[dog.state])) then
            dog.state = DOG_WALKING
        end
    end

    if (dog.state == DOG_WALKING) then
        if (not anim.AdvanceAnimation(playtime, dog.animations[dog.state])) then
            dog.animations[dog.state].clip = false
            anim.AdvanceAnimation(playtime, dog.animations[dog.state])
        else
            if (dog.location.x == game.sitlocation.x and dog.location.y == game.sitlocation.y) then 
                dog.state = DOG_SITTING
            else
                if(dog.location.x > game.sitlocation.x) then dog.location.x = dog.location.x -1 end
                if(dog.location.x < game.sitlocation.x) then dog.location.x = dog.location.x +1 end
                if(dog.location.y > game.sitlocation.y) then dog.location.y = dog.location.y -1 end
                if(dog.location.y < game.sitlocation.y) then dog.location.y = dog.location.y +1  end
            end

            dog.flipVirticle = dog.location.x > game.sitlocation.x
        end
    end

    if (dog.state == DOG_LEASHED) then
        if (not anim.AdvanceAnimation(playtime, dog.animations[dog.state])) then
            dog.animations[dog.state].clip = false
            anim.AdvanceAnimation(playtime, dog.animations[dog.state])
        end
    end

    if (dog.state == DOG_SITTING) then
        if (not anim.AdvanceAnimation(playtime, dog.animations[dog.state])) then
            dog.animations[dog.state].clip = false
            anim.AdvanceAnimation(playtime, dog.animations[dog.state])
        end
        IntroState = INTRO_WAIT_INPUT
    end
end

function m.UpdateFrames(dt)
    local playtime = anim.AdvanceFrameTimer(dt);
    if (playtime > 0) then
        if LoopState == LOOP_INTRO then
            UpdateIntroState(playtime)
        end

        if LoopState == LOOP_PLAY then
            if (player.location.x == game.poop.location.x and player.location.y == game.poop.location.y) then
                LoopState = LOOP_FAIL
                log.debug("stepped in poop")
            end
            if (player.state == PLAYER_WAITING_TOP) then
                if not anim.AdvanceAnimation(playtime, player.animations[player.state]) then
                    player.animations[player.state].clip = false
                    anim.AdvanceAnimation(playtime, player.animations[player.state])
                end
            end
            if (dog.state == DOG_SITTING_TOP) then
                if not anim.AdvanceAnimation(playtime, dog.animations[dog.state]) then
                    dog.animations[dog.state].clip = false
                    anim.AdvanceAnimation(playtime, dog.animations[dog.state])
                end
            end
        end
        
        if LoopState == LOOP_EXIT then
           --log.debug("LOOP_EXIT")
            if (not anim.AdvanceAnimation(playtime, goodbye.message_anim)) then
                love.event.quit()
            else
               --log.debug("exiting")
                goodbye.xupdate = goodbye.xupdate + 20
            end
        end
    end
end

local function CreateMapDrawData()
    -- these first two are not used, should I keep them?
    local frametlTransform = love.math.newTransform(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y)
    local frametrTransform = love.math.newTransform(INTRO_CUTSCENE_X+INTRO_CUTSCENE_WIDTH, INTRO_CUTSCENE_Y)
    local frameblTransform = love.math.newTransform(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y+INTRO_CUTSCENE_HEIGHT)
    local framebrTransform = love.math.newTransform(INTRO_CUTSCENE_X+INTRO_CUTSCENE_WIDTH, INTRO_CUTSCENE_Y+INTRO_CUTSCENE_HEIGHT)

    local mapheight = 10

    local maptlx, maptly = frameblTransform:transformPoint(0, -mapheight)
    local maptrx, maptry = framebrTransform:transformPoint(0, -mapheight)
    local mapbrx, mapbry = framebrTransform:transformPoint(0, 0)
    local mapblx, mapbly = frameblTransform:transformPoint(0, 0)
    
    local cellWidth = (maptrx - maptlx) / game.map.gridsize.x
    local data = {}
    data.tl = {}
    data.tl.x = maptlx
    data.tl.y = maptly
    data.tr = {}
    data.tr.x = maptrx
    data.tr.y = maptry
    data.bl = {}
    data.bl.x = mapblx
    data.bl.y = mapbly
    data.br = {}
    data.br.x = mapbrx
    data.br.y = mapbry
    data.cellWidth = cellWidth

    return data
end

local function CreateEntityDrawData(platformX, platformY, cellWidth, entity)
    if (not entity.state) then
        error("the entity does not have a valid state")
    end

    local platformTransform = love.math.newTransform()
    platformTransform:translate(platformX, platformY+1)

    local relativeX = (cellWidth * (entity.location.x - 1)) + (cellWidth / 2)
    local xpos, ypos =  platformTransform:transformPoint(relativeX, -1)
    local entityscalex = 1
    local entityscaley = 1
    local animation = entity.animations[entity.state]

    if (animation and animation.clip) then
        local imageScale = cellWidth / animation.clip.quadWidth
        entityscalex = imageScale-math.percent((entity.location.y-1)*10, imageScale)
        entityscaley = entityscalex

        xpos = xpos - ((animation.clip.quadWidth * entityscalex) / 2)
        ypos = ypos - (animation.clip.quadHeight * entityscaley)
    end

    if (entity.flipVirticle) then
        entityscalex = -entityscalex
    end

    --log.debug("draw data animation: ", tserial.pack(animation, handleSerialisation, false))
    return { x = xpos, y = ypos, scalex = entityscalex, scaley = entityscaley, animation = animation, rotation = 0 }
end

local function CreateMapDrawDataTop(map)
    local data = {}
    data.tl = {}
    data.tl.x = PLAY_X
    data.tl.y = PLAY_Y
    data.tr = {}
    data.tr.x = PLAY_X + PLAY_WIDTH
    data.tr.y = PLAY_Y
    data.bl = {}
    data.bl.x = PLAY_X
    data.bl.y = PLAY_Y + PLAY_HEIGHT
    data.br = {}
    data.br.x = PLAY_X + PLAY_WIDTH
    data.br.y = PLAY_Y + PLAY_HEIGHT
    data.image = love.graphics.newImage(map.backgroundimage)
    data.backgroundscale = PLAY_HEIGHT/data.image:getHeight()
    data.cellWidth = PLAY_WIDTH / map.gridsize.x

    return data
end

local function CreateEntityDrawDataTop(maptlx, maptly, cellWidth, scaleToCell, entity)
    if (not entity.state) then
        error("the entity does not have a valid state")
    end

    local platformTransform = love.math.newTransform()
    platformTransform:translate(maptlx, maptly)

    local relativeX = (cellWidth * (entity.location.x - 1)) + (cellWidth / 2)
    local relativeY = (cellWidth * (entity.location.y - 1)) + (cellWidth / 2)
    local xpos, ypos =  platformTransform:transformPoint(relativeX, relativeY)
    local animation = entity.animations[entity.state]

    local imageScale = 1

    if (animation and animation.clip) then
        imageScale = (cellWidth / animation.clip.quadWidth) * scaleToCell
        xpos = xpos - ((animation.clip.quadWidth * imageScale) / 2)
        ypos = ypos - ((animation.clip.quadHeight * imageScale) / 2)
    end

    local rotation = 0
    if (player.orientation > 0) then
        -- rotation = 90*(player.orientation - 1)
    end

    return { x = xpos, y = ypos, scalex = imageScale, scaley = imageScale, animation = animation, rotation = rotation }
end

function m.DrawFrames()
   --log.debug("draw")
    if LoopState==LOOP_MENU then
        love.graphics.print("s - Start", MAIN_MENU_X, MAIN_MENU_Y)
        love.graphics.print("x - Exit", MAIN_MENU_X, MAIN_MENU_Y + 25)
    elseif LoopState == LOOP_INTRO then
        if IntroState == INTRO_START then
            love.graphics.print("time to let pepper off the lead", GAME_MESSAGE_X, GAME_MESSAGE_Y)
        elseif IntroState == INTRO_CUTSCENE then
            love.graphics.print("pepper is looking for a spot to poop", GAME_MESSAGE_X, GAME_MESSAGE_Y)
            love.graphics.print("keep your eye on her", GAME_MESSAGE_X, GAME_MESSAGE_Y+30)
        elseif IntroState == INTRO_WAIT_INPUT then
            love.graphics.print("let's find the poop", GAME_MESSAGE_X, GAME_MESSAGE_Y)
            love.graphics.print("b - Back", INTRO_MENU_X, INTRO_MENU_Y)
            love.graphics.print("c - Continue", INTRO_MENU_X, INTRO_MENU_Y+25)
        else
            IntroState = INTRO_START
        end

        local mapdrwdata = CreateMapDrawData()
        local playerdrawData = CreateEntityDrawData(mapdrwdata.tl.x, mapdrwdata.tl.y, mapdrwdata.cellWidth, player)
        local dogdrawData = CreateEntityDrawData(mapdrwdata.tl.x, mapdrwdata.tl.y, mapdrwdata.cellWidth, dog)

        love.graphics.polygon('fill',
        mapdrwdata.tl.x,mapdrwdata.tl.y,
        mapdrwdata.tr.x,mapdrwdata.tr.y,
        mapdrwdata.br.x,mapdrwdata.br.y,
        mapdrwdata.bl.x,mapdrwdata.bl.y)

        if (mapdrwdata and playerdrawData and dogdrawData) then
            love.graphics.draw(playerdrawData.animation.clip.image, playerdrawData.animation.clip.frame, playerdrawData.x, playerdrawData.y, 0, playerdrawData.scalex, playerdrawData.scaley)
            love.graphics.draw(dogdrawData.animation.clip.image, dogdrawData.animation.clip.frame, dogdrawData.x, dogdrawData.y, 0, dogdrawData.scalex, dogdrawData.scaley)
        end

    elseif LoopState == LOOP_PLAY then
        love.graphics.print("This is a work in progress, thank you for watching my into", GAME_MESSAGE_X, GAME_MESSAGE_Y)
        love.graphics.print("x - Exit", MAIN_MENU_X, MAIN_MENU_Y)
        
        local mapDrawData = CreateMapDrawDataTop(game.map)
        local playerDrawData = CreateEntityDrawDataTop(mapDrawData.tl.x, mapDrawData.tl.y, mapDrawData.cellWidth, 1, player)
        local dogDrawData = CreateEntityDrawDataTop(mapDrawData.tl.x, mapDrawData.tl.y, mapDrawData.cellWidth, 0.75, dog)
        local poopDrawData = CreateEntityDrawDataTop(mapDrawData.tl.x, mapDrawData.tl.y, mapDrawData.cellWidth, 0.5, game.poop)

        if (mapDrawData and playerDrawData and dogDrawData) then
            love.graphics.draw(mapDrawData.image, mapDrawData.tl.x, mapDrawData.tl.y, 0, mapDrawData.backgroundscale, mapDrawData.backgroundscale)
            love.graphics.draw(playerDrawData.animation.clip.image, playerDrawData.animation.clip.frame, playerDrawData.x, playerDrawData.y, playerDrawData.rotation, playerDrawData.scalex, playerDrawData.scaley)
            love.graphics.draw(dogDrawData.animation.clip.image, dogDrawData.animation.clip.frame, dogDrawData.x, dogDrawData.y, 0, dogDrawData.scalex, dogDrawData.scaley)
            love.graphics.draw(poopDrawData.animation.clip.image, poopDrawData.animation.clip.frame, poopDrawData.x, poopDrawData.y, 0, poopDrawData.scalex, poopDrawData.scaley)
        end
    elseif LoopState == LOOP_WIN then
    elseif LoopState == LOOP_FAIL then
        love.graphics.print("Oh no! You stepped in the poo", GAME_MESSAGE_X, GAME_MESSAGE_Y)
        love.graphics.print("n - New Game", MAIN_MENU_X, MAIN_MENU_Y)
        love.graphics.print("r - Retry", MAIN_MENU_X, MAIN_MENU_Y+20)
        love.graphics.print("x - Exit", MAIN_MENU_X, MAIN_MENU_Y+40)
    elseif LoopState == LOOP_EXIT then
        --log.debug("draw")
        love.graphics.print("Goodbye!", GAME_MESSAGE_X, GAME_MESSAGE_Y)

        if (goodbye.message_anim.clip) then
            goodbye.locationpx.x = EXIT_CUTSCENE_X+goodbye.xupdate
            goodbye.locationpx.y = EXIT_CUTSCENE_Y

            love.graphics.draw(goodbye.message_anim.clip.image, goodbye.message_anim.clip.frame, goodbye.locationpx.x, goodbye.locationpx.y, 0, goodbye.scalepx, goodbye.scalepx)
        end
    end
end

return m