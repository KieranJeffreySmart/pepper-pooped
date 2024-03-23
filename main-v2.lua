require"custextensions"
local log = require"log"
local anim = require"animation"
local tserial = require"Tserial"
local player_draw_v2 = require"player-draw-v2"
local dog_draw_v2 = require"dog-draw-v2"
local goodbye_draw = require"goodbye-draw"
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

LoopState = 0
IntroState = 0
ExitState = 0

GAME_MESSAGE_X = 150
GAME_MESSAGE_Y = 50
PLAYER_SPEACH_X = 150
PLAYER_SPEACH_Y = 100
INTRO_CUTSCENE_X = 100
INTRO_CUTSCENE_Y = 100
INTRO_CUTSCENE_HEIGHT = 250
INTRO_CUTSCENE_WIDTH = 500
INTRO_CUTSCENE_SCALE = 1
EXIT_CUTSCENE_X = 200
EXIT_CUTSCENE_Y = 250
MAIN_MENU_X = 200
MAIN_MENU_Y = 150
INTRO_MENU_X = 200
INTRO_MENU_Y = 400

EXIT_CUTSCENE_FPS = 10
EXIT_CUTSCENE_DURATION = 5

INTRO_CUTSCENE_FPS = 10
INTRO_CUTSCENE_DURATION = 15

local goodbye = goodbye_draw.NewMessage(EXIT_CUTSCENE_DURATION, EXIT_CUTSCENE_FPS, EXIT_CUTSCENE_X, EXIT_CUTSCENE_Y)
local game = {}
local player = {}
local dog = {}

log.outfile = "C:/Repos/pepper-pooped/log.txt"
local handleSerialisation = function () return '' end

local m = {}

local function IntroReset()
    log.debug("reset intro ")
    game = game_generator.NewGame()
    player = player_draw_v2.NewPlayer(PLAYER_UNLEASHING, game.start)
    dog = dog_draw_v2.NewDog(DOG_LEASHED, game.start, game.pooplocation, game.sitlocation)
end

local function DoGameCommand(input)
    if input=='w' then
    elseif input=='s' then
    elseif input=='d' then
    elseif input=='a' then
    elseif input~='x' then
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
    local entityScale = 1
    local animation = entity.animations[entity.state];

    if (animation and animation.clip) then
        local imageScale = cellWidth / animation.clip.quadWidth
        entityScale = imageScale-math.percent((entity.location.y-1)*10, imageScale)

        xpos = xpos - ((animation.clip.quadWidth * entityScale) / 2)
        ypos = ypos - (animation.clip.quadHeight * entityScale)
    end

    
    --log.debug("draw data animation: ", tserial.pack(animation, handleSerialisation, false))

    return { x = xpos, y = ypos, scale = entityScale, animation = animation }
end

local function DrawMap(map)
end

local function DrawMenu()
    love.graphics.print("s - Start", MAIN_MENU_X, MAIN_MENU_Y)
    love.graphics.print("x - Exit", MAIN_MENU_X, MAIN_MENU_Y + 25)
end

local function DrawConsole()
    local playerString = "{}"

    if (player) then 
        local playerLog = {
            state = player.state,
            location = player.location,
            drawData = player.drawData
        }

        playerString = tserial.pack(playerLog, handleSerialisation, true)
    end

    local dogString = "{}"
    if (dog) then 
        local dogLog = {
            state = dog.state,
            location = dog.location,
            sitlocation = dog.sitlocation,
            drawData = dog.drawData
        }

        dogString = tserial.pack(dogLog, handleSerialisation, true)
    end

    coordinatesString = tserial.pack(game.map.drawData, handleSerialisation, true)
    

    love.graphics.print("Map Coordinates: " .. coordinatesString, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+20)
    love.graphics.print("Player: " .. playerString, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+300)
    love.graphics.print("Dog: " .. dogString, GAME_MESSAGE_X+600, GAME_MESSAGE_Y+40)
end

local function DrawIntro()
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

    if (game.map.drawData and player.drawData and dog.drawData) then
        love.graphics.polygon('fill', 
        game.map.drawData.tl.x,game.map.drawData.tl.y, 
        game.map.drawData.tr.x,game.map.drawData.tr.y, 
        game.map.drawData.br.x,game.map.drawData.br.y, 
        game.map.drawData.bl.x,game.map.drawData.bl.y)


        love.graphics.draw(player.drawData.animation.clip.image, player.drawData.animation.clip.frame, player.drawData.x, player.drawData.y, 0, player.drawData.scale, player.drawData.scale)
        --love.graphics.draw(dog.drawData.animation.clip.image, dog.drawData.animation.clip.frame, dog.drawData.x, dog.drawData.y, 0, dog.drawData.scale, dog.drawData.scale)
        --DrawConsole()
    end
end

function m.OnLoad()
    love.window.setMode( 1000, 800)
    LoopState = LOOP_MENU
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
            LoopState = LOOP_PLAY
        elseif key == COMMAND_BACK then
            LoopState = LOOP_MENU
        end

    elseif LoopState == LOOP_PLAY then
        DoGameCommand(key)
    elseif LoopState == LOOP_WIN or LoopState == LOOP_FAIL then
        if key == COMMAND_NEWGAME then
            LoopState = LOOP_MENU
        elseif key == COMMAND_RETRY then
            LoopState = LOOP_INTRO
        elseif key == COMMAND_EXIT then
            LoopState = LOOP_EXIT
        end
    end
end

function m.UpdateFrames(dt)
    local playtime = anim.AdvanceFrameTimer(dt);
    if ( dt < 0.04 and playtime) then
        if LoopState == LOOP_INTRO then
            log.debug("update ")
            
            log.debug("player state: ", player.state)
            if (player.state == PLAYER_UNLEASHING) then
                if (not anim.AdvanceAnimation(playtime, player.animations[player.state])) then
                    player.state = PLAYER_WAITING
                    dog.state = DOG_POOPING
                    log.debug("set dog to pooping ")
                end
            end
            if (player.state == PLAYER_WAITING) then
                if not anim.AdvanceAnimation(playtime, player.animations[player.state]) then
                    player.animations[player.state].clip = false
                    anim.AdvanceAnimation(playtime, player.animations[player.state])
                end
            end

            if (dog.state == DOG_POOPING) then
                if (not anim.AdvanceAnimation(playtime, dog.animations[dog.state])) then
                    dog.state = DOG_SITTING
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

            local mapdrwdata = CreateMapDrawData()
            game.map.drawData = mapdrwdata
            log.debug("map draw data: ", 'cell width: ', mapdrwdata.cellWidth, 'tl x: ', mapdrwdata.tl.x, 'tl y: ', mapdrwdata.tl.y,  'tr x: ', mapdrwdata.tr.x, 'tr y: ', mapdrwdata.tr.y)
            player.drawData = CreateEntityDrawData(mapdrwdata.tl.x, mapdrwdata.tl.y, mapdrwdata.cellWidth, player)
            log.debug("player draw data: ", 'x: ', player.drawData.x, 'y: ', player.drawData.y, 'scale: ', player.drawData.scale )
            dog.drawData = CreateEntityDrawData(mapdrwdata.tl.x, mapdrwdata.tl.y, mapdrwdata.cellWidth, dog)
            log.debug("dog draw data: ", 'x: ', dog.drawData.x, 'y: ', dog.drawData.y, 'scale: ', dog.drawData.scale )
        end
    end
end

function m.DrawFrames()
    if LoopState==LOOP_MENU then
        DrawMenu()
    elseif LoopState == LOOP_INTRO then
        DrawIntro()
    elseif LoopState == LOOP_PLAY then
        DrawMap(game.map)
    elseif LoopState == LOOP_WIN then
    elseif LoopState == LOOP_FAIL then
    elseif LoopState == LOOP_EXIT then
        love.graphics.print("Goodbye!", GAME_MESSAGE_X, GAME_MESSAGE_Y)
        
        goodbye.locationpx.x = EXIT_CUTSCENE_X+goodbye.message_anim.xupdate
        goodbye.locationpx.y = EXIT_CUTSCENE_Y
        
        love.graphics.draw(goodbye.message_anim.image, goodbye.message_anim.quad, goodbye.locationpx.x, goodbye.locationpx.y, 0, goodbye.scalepx, goodbye.scalepx)
    end
end

return m