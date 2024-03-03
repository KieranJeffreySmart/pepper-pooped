LOOP_MENU = 1
LOOP_HINT = 2
LOOP_PLAY = 3
LOOP_WIN = 4
LOOP_FAIL = 5
LOOP_EXIT = 6

EXIT_CUTSCENE = 7
EXIT_CLOSE = 8

HINT_START = 9
HINT_CUTSCENE = 10
HINT_WAIT_INPUT = 11

DOG_UNLEASHED = 12
DOG_RUNNING = 13
DOG_POOPING = 14
DOG_WAITING = 15

COMMAND_START = ' '
COMMAND_CONTINUE = ' '
COMMAND_EXIT = 'x'
COMMAND_BACK = 'b'
COMMAND_NEWGAME = 'n'
COMMAND_RETRY = 'r'

LoopState = 0
HintState = 0
ExitState = 0
Game = {}
Dog = {}
Player = {}

GAME_MESSAGE_X = 150
GAME_MESSAGE_Y = 50
HINT_CUTSCENE_Y = 150
EXIT_CUTSCENE_X = 200
EXIT_CUTSCENE_Y = 150
MENU_X = 200
MENU_Y = 150

EXIT_CUTSCENE_FPS = 10
EXIT_CUTSCENE_DURATION = 5
GOODBYE_MAX_DURATION = EXIT_CUTSCENE_DURATION / EXIT_CUTSCENE_FPS
local goodbye_frame = 1
local goodbye_total_frame_count = 1
local goodbye_duration = GOODBYE_MAX_DURATION
local goodbye_frame_count = 4
local goodbye_xupdate = 0
local goodbye_playtime = 0

function love.load()
    -- love.graphics:setDefaultfilter("nearest")
    GoodbyeMessageImg = love.graphics.newImage("dog2_32x32.bmp")
    GoodbyeMessageScroll = love.graphics.newQuad(EXIT_CUTSCENE_X, EXIT_CUTSCENE_Y, 32, 32, GoodbyeMessageImg:getDimensions())
    LoopState = LOOP_MENU
end


function love.keyreleased(key)
    if LoopState==LOOP_MENU then
        if key == COMMAND_START then
            -- Game = RandomGame();
            LoopState =LOOP_HINT
        elseif key == COMMAND_EXIT then
            LoopState = LOOP_EXIT
        end

    elseif LoopState == LOOP_HINT then
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
            LoopState = LOOP_HINT
        elseif key == COMMAND_EXIT then
            LoopState = LOOP_EXIT
        end
    end
end

function RandomGame()
    local game = {}
    game.map  = GetMap(1)
    game.poop = GetPoop(1)
    game.pooplocation = GetRandomAvailableLocation(game.map.gridmap, game.map.gridsize)
    game.start.x = 1
    game.start.y = 1
    return game
end

function GetPoop(poopid)
    local poop = {}
    poop.sprite = ''
    local sizepx = {}
    sizepx.x = 1
    sizepx.y = 1
    poop.size = sizepx

    return poop
end

function GetRandomAvailableLocation(gridmap, gridsize)
    local location = {}
    location.x = 0
    location.y = 0

    local x = 1
    local y = 1
    local findLocation = true

    while(findLocation) do
        if (gridmap[x][y] == 'E') then
            location.x = x
            location.y = y
            findLocation = false;
        elseif x <= gridsize.x then
            x = x+1
        elseif y <= gridsize.y then
            y = y+1
            x = 0
        else
            findLocation = false
        end
    end
    
    return location
end

function GetMap(mapid)
    local map = {}
    map.id = mapid
    map.backgroundimage = ''
    map.backgroundsize.x = 500
    map.backgroundsize.y = 500

    map.gridsize.x = 1
    map.gridsize.y = 1

    map.objects[0].name='seashell'
    map.objects[1].name='mooringpost'
    
    for i = 1, map.gridsize.x, 1 do
        for y = 1, map.gridsize.y, 1 do
            map.gridmap[i][y] = 'E'
        end
    end

    for index, value in ipairs(map.objects) do
        local objloc = GetRandomAvailableLocation(map.gridmap)
        map.gridmap[objloc.x][objloc.y] = index
    end

    return map
end

function DoGameCommand(input)
    if input=='w' then
    elseif input=='s' then
    elseif input=='d' then
    elseif input=='a' then
    elseif input~='x' then
    end
end

function love.update(dt)
    if LoopState==LOOP_MENU then
        -- menu animations
    elseif LoopState == LOOP_HINT then
        LoopState = LOOP_MENU
        -- switch on dog state
        -- if unleash
        -- if run
        -- if poop
        -- if heel

    elseif LoopState == LOOP_PLAY then
        LoopState = LOOP_MENU
    elseif LoopState == LOOP_WIN then
        LoopState = LOOP_MENU
    elseif LoopState == LOOP_FAIL then
        LoopState = LOOP_MENU
    elseif LoopState == LOOP_EXIT then
        if ExitState == EXIT_CUTSCENE then
            if dt < 0.04 then
                goodbye_duration = goodbye_duration - dt
                if goodbye_duration <= 0 then -- remember we are working from after frame 1                 
                    goodbye_playtime = goodbye_playtime + GOODBYE_MAX_DURATION
                    goodbye_duration = GOODBYE_MAX_DURATION
                    goodbye_frame = goodbye_frame + 1
                    goodbye_total_frame_count = goodbye_total_frame_count + 1
                    if goodbye_frame > goodbye_frame_count then
                        goodbye_frame = 1
                    end
                    goodbye_xupdate = 60 * (goodbye_total_frame_count - 1)
                    if(goodbye_playtime >= EXIT_CUTSCENE_DURATION) then
                        ExitState = EXIT_CLOSE
                    end
                end
            else
                return
            end
        elseif ExitState == EXIT_CLOSE then
            love.event.quit()
        else
            ExitState = EXIT_CUTSCENE
        end
    end
end

function love.draw()
    if LoopState==LOOP_MENU then
        DrawMenu()
    elseif LoopState == LOOP_HINT then
        DrawHint()
    elseif LoopState == LOOP_PLAY then
    elseif LoopState == LOOP_WIN then
    elseif LoopState == LOOP_FAIL then
    elseif LoopState == LOOP_EXIT then
        love.graphics.print("Goodbye!", GAME_MESSAGE_X, GAME_MESSAGE_Y)
        love.graphics.draw(GoodbyeMessageImg, GoodbyeMessageScroll, EXIT_CUTSCENE_X+goodbye_xupdate, EXIT_CUTSCENE_Y, 0, 3, 3)
    end
end

function DrawMenu()
    love.graphics.print("s - Start", MENU_X, MENU_Y)
    love.graphics.print("x - Exit", MENU_X, MENU_Y + 50)
end

function DrawHint()
    --draw background

    --draw map front view
    --draw pepper front view

    --draw context

    if HintState == HINT_START then
        love.graphics.print("time to let pepper off the lead", GAME_MESSAGE_X, GAME_MESSAGE_Y)
    elseif HintState == HINT_CUTSCENE then
        love.graphics.print("pepper is looking for a spot to poop", GAME_MESSAGE_X, GAME_MESSAGE_Y)
        love.graphics.print("keep your eye on her", GAME_MESSAGE_X, GAME_MESSAGE_Y+30)
    elseif HintState == HINT_WAIT_INPUT then
        love.graphics.print("let's find the poop", GAME_MESSAGE_X, GAME_MESSAGE_Y)
    end

    if Dog.state == DOG_UNLEASHED then
        --write title
    elseif Dog.state == DOG_RUNNING then
        --write title
    elseif Dog.state == DOG_POOPING then
        --
    elseif Dog.state == DOG_WAITING then
    end
end
