

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end

anim = {}
function anim.PlayAnimation(animation)
    animation.playtime = animation.playtime + animation.max_frame_duration
    animation.frame_duration = animation.max_frame_duration
    animation.frame = animation.frame + 1
    animation.total_frame_count = animation.total_frame_count + 1
    if animation.frame > animation.frame_count then
        animation.frame = 1
    end
end

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

DOG_LEASHED = 12
DOG_RUNNING = 13
DOG_POSITIONING = 14
DOG_POOPING = 15
DOG_WALKING = 16
DOG_WAITING = 17

PLAYER_UNLEASHING = 18
PLAYER_WAITING = 19

COMMAND_START = 's'
COMMAND_CONTINUE = 'c'
COMMAND_EXIT = 'x'
COMMAND_BACK = 'b'
COMMAND_NEWGAME = 'n'
COMMAND_RETRY = 'r'

LoopState = 0
IntroState = 0
ExitState = 0
Game = {}
Dog = {}
Player = {}

GAME_MESSAGE_X = 150
GAME_MESSAGE_Y = 50
PLAYER_SPEACH_X = 150
PLAYER_SPEACH_Y = 100
INTRO_CUTSCENE_X = 100
INTRO_CUTSCENE_Y = 350
INTRO_CUTSCENE_SCALE = 1
EXIT_CUTSCENE_X = 200
EXIT_CUTSCENE_Y = 150
MAIN_MENU_X = 200
MAIN_MENU_Y = 150
INTRO_MENU_X = 200
INTRO_MENU_Y = 400
DOG_DEFAULT_BOX_X = 16
DOG_DEFAULT_BOX_Y = 16
PLAYER_DEFAULT_BOX_X = 16
PLAYER_DEFAULT_BOX_Y = 32

EXIT_CUTSCENE_FPS = 10
EXIT_CUTSCENE_DURATION = 5

INTRO_CUTSCENE_FPS = 10
INTRO_CUTSCENE_DURATION = 15

local player_draw = require"player-draw"
local dog_draw = require"dog-draw"
local goodbye_draw = require"goodbye-draw"

local goodbye = goodbye_draw.NewMessage(EXIT_CUTSCENE_DURATION, EXIT_CUTSCENE_FPS)

local player = player_draw.NewPlayer(INTRO_CUTSCENE_DURATION, INTRO_CUTSCENE_FPS)
local dog = dog_draw.NewDog(INTRO_CUTSCENE_DURATION, INTRO_CUTSCENE_FPS)

LastGeneratedRandomLocation = {}

function IntroRestart()
    player = player_draw.NewPlayer(INTRO_CUTSCENE_DURATION, INTRO_CUTSCENE_FPS)
    dog = dog_draw.NewDog(INTRO_CUTSCENE_DURATION, INTRO_CUTSCENE_FPS)

    LastGeneratedRandomLocation.x = 0
    LastGeneratedRandomLocation.y = 0

    -- love.graphics:setDefaultfilter("nearest")

    dog.state = 0
    dog.location = {}
    dog.location.x = 1
    dog.location.y = 1
    dog.scalepx = INTRO_CUTSCENE_SCALE
    dog.locationpx = {}
    dog.locationpx.x = 0
    dog.locationpx.y = 0
    player.state = 0
    player.location = {}
    player.location.x = 0
    player.location.y = 1
    player.scalepx = INTRO_CUTSCENE_SCALE
    player.locationpx = {}
    player.locationpx.x = 0
    player.locationpx.y = 0
end

function love.load()
    LoopState = LOOP_MENU
end

function love.keyreleased(key)
    if LoopState==LOOP_MENU then
        if key == COMMAND_START then
            Game = RandomGame();
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

function DoGameCommand(input)
    if input=='w' then
    elseif input=='s' then
    elseif input=='d' then
    elseif input=='a' then
    elseif input~='x' then
    end
end



function AnimatePlayer(dt)
    if player.state == PLAYER_UNLEASHING then
        player.unleashing_anim.frame_duration = player.unleashing_anim.frame_duration - dt
        if player.unleashing_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(player.unleashing_anim)
            if(player.unleashing_anim.playtime >= player.unleashing_anim.max_duration) then
                dog.state = DOG_RUNNING
                player.state = PLAYER_WAITING
                IntroState = INTRO_CUTSCENE
            end
        end
    elseif player.state == PLAYER_WAITING then
        player.waiting_anim.frame_duration = player.waiting_anim.frame_duration - dt
        if player.waiting_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(player.waiting_anim)
        end
    else
        player.state = PLAYER_UNLEASHING
    end
end

function AnimateDog(dt)
    if dog.state == DOG_LEASHED then
        dog.leashed_anim.frame_duration = dog.leashed_anim.frame_duration - dt
        if dog.leashed_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(dog.leashed_anim)
        end
    elseif dog.state == DOG_RUNNING then
        dog.running_anim.frame_duration = dog.running_anim.frame_duration - dt
        if dog.running_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            anim.PlayAnimation(dog.running_anim)
            local randomLocation = GetRandomAvailableLocation(Game.map.gridmap, Game.map.gridsize)
            dog.location.x = randomLocation.x
            dog.location.y = randomLocation.y
            if(dog.running_anim.playtime >= dog.running_anim.max_duration) then
                dog.location.x = Game.pooplocation.x
                dog.location.y = Game.pooplocation.y
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
                IntroState = INTRO_WAIT_INPUT
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

function love.update(dt)
    if LoopState==LOOP_MENU then
        IntroRestart()
    elseif LoopState == LOOP_INTRO then
        
        if dt < 0.04 then
            AnimateDog(dt)
            AnimatePlayer(dt)
        else
            return
        end

    elseif LoopState == LOOP_PLAY then
        LoopState = LOOP_MENU
    elseif LoopState == LOOP_WIN then
        LoopState = LOOP_MENU
    elseif LoopState == LOOP_FAIL then
        LoopState = LOOP_MENU
    elseif LoopState == LOOP_EXIT then
        if ExitState == EXIT_CUTSCENE then
            if dt < 0.04 then
                goodbye.message_anim.frame_duration = goodbye.message_anim.frame_duration - dt
                if goodbye.message_anim.frame_duration <= 0 then -- remember we are working from after frame 1   
                    anim.PlayAnimation(goodbye.message_anim)
                    goodbye.message_anim.xupdate = 60 * (goodbye.message_anim.total_frame_count - 1)
                    if(goodbye.message_anim.playtime >= EXIT_CUTSCENE_DURATION) then
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
    elseif LoopState == LOOP_INTRO then
        DrawIntro()
    elseif LoopState == LOOP_PLAY then
    elseif LoopState == LOOP_WIN then
    elseif LoopState == LOOP_FAIL then
    elseif LoopState == LOOP_EXIT then
        love.graphics.print("Goodbye!", GAME_MESSAGE_X, GAME_MESSAGE_Y)
        love.graphics.draw(goodbye_message_anim.image, goodbye_message_anim.quad, EXIT_CUTSCENE_X+goodbye_message_anim.xupdate, EXIT_CUTSCENE_Y, 0, 3, 3)
    end
end

function DrawMenu()
    love.graphics.print("s - Start", MAIN_MENU_X, MAIN_MENU_Y)
    love.graphics.print("x - Exit", MAIN_MENU_X, MAIN_MENU_Y + 25)
end

function DrawIntro()
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

    DrawDog()
    DrawPlayer()
    
    love.graphics.print("Loop State: " .. LoopState, GAME_MESSAGE_X+400, GAME_MESSAGE_Y)
    love.graphics.print("Intro State: " .. IntroState, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+20)
    love.graphics.print("Playe State: " .. player.state, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+40)
    love.graphics.print("Player: x " .. player.location.x .. " y " .. player.location.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+60)
    love.graphics.print("Player px: x " .. player.locationpx.x .. " y " .. player.locationpx.y .. " scale " .. player.scalepx, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+80)
    love.graphics.print("Dog State: " .. dog.state, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+100)
    love.graphics.print("Dog: x " .. dog.location.x .. " y " .. dog.location.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+120)
    love.graphics.print("Dog px: x " .. dog.locationpx.x .. " y " .. dog.locationpx.y .. " scale " .. dog.scalepx, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+140)
    love.graphics.print("Poop: x " .. Game.pooplocation.x .. " y " .. Game.pooplocation.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+160)
    love.graphics.print("map: x " .. Game.map.gridsize.x .. " y " .. Game.map.gridsize.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+180)
    love.graphics.print("rndloc: x " .. LastGeneratedRandomLocation.x .. " y " .. LastGeneratedRandomLocation.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+200)
end

function DrawDog()
    dog.locationpx.x = INTRO_CUTSCENE_X + (dog.location.x * INTRO_CELL_WIDTH)
    dog.locationpx.y = INTRO_CUTSCENE_Y
    dog.scalepx = INTRO_CUTSCENE_SCALE + math.percent(dog.location.y*10, INTRO_CUTSCENE_SCALE)

    if dog.state == DOG_LEASHED then
        DrawAnimation(dog.leashed_anim, dog.locationpx, dog.scalepx)
        --write title
    elseif dog.state == DOG_RUNNING then
        DrawAnimation(dog.running_anim, dog.locationpx, dog.scalepx)
    elseif dog.state == DOG_POSITIONING then
        DrawAnimation(dog.positioning_anim, dog.locationpx, dog.scalepx)
        --write title
    elseif dog.state == DOG_POOPING then
        DrawAnimation(dog.pooping_anim, dog.locationpx, dog.scalepx)
        --
    elseif dog.state == DOG_WALKING then
        love.graphics.print("here!", PLAYER_SPEACH_X, PLAYER_SPEACH_Y)
        DrawAnimation(dog.walking_anim, dog.locationpx, dog.scalepx)
    elseif dog.state == DOG_WAITING then
        DrawAnimation(dog.waiting_anim, dog.locationpx, dog.scalepx)
    end
end

function DrawAnimation(animation, location, scale)
    love.graphics.draw(animation.image, animation.quad, location.x, location.y, 0, scale, -scale)
end

function DrawPlayer()
    player.locationpx.x = INTRO_CUTSCENE_X + player.location.x * INTRO_CELL_WIDTH
    player.locationpx.y = INTRO_CUTSCENE_Y
    player.scalepx = INTRO_CUTSCENE_SCALE + math.percent(player.location.y*10, INTRO_CUTSCENE_SCALE)
    if player.state == PLAYER_UNLEASHING then
        DrawAnimation(player.unleashing_anim, player.locationpx, player.scalepx)
    elseif player.state == PLAYER_WAITING then
        DrawAnimation(player.waiting_anim, player.locationpx, player.scalepx)
    end
end

function RandomGame()
    local game = {}
    game.map  = GetMap(1)
    game.poop = GetPoop(1)
    game.pooplocation = GetRandomAvailableLocation(game.map.gridmap, game.map.gridsize)
    game.map.gridmap[game.pooplocation.x][game.pooplocation.y] = 'P'
    game.start = {}
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

    local random_x = 1
    local random_y = 1
    local findLocation = true


    while(findLocation) do
        random_x = math.random(1, gridsize.x)
        random_y = math.random(1, gridsize.y)
        if ((random_x > 1 or random_y > 1) and gridmap[random_x][random_y] == 'E') then
            location.x = random_x
            location.y = random_y
            findLocation = false
        end
    end

    LastGeneratedRandomLocation = {}
    LastGeneratedRandomLocation.x = random_x
    LastGeneratedRandomLocation.y = random_y

    return location
end

function GetMap(mapid)
    local map = {}
    map.id = mapid
    map.backgroundimage = ''
    map.backgroundsize = {}
    map.backgroundsize.x = 500
    map.backgroundsize.y = 500

    map.gridsize = {}
    map.gridsize.x = 6
    map.gridsize.y = 6
    map.gridmap = {}
    for i = 1, map.gridsize.x, 1 do
        map.gridmap[i] = {}
        for y = 1, map.gridsize.y, 1 do
            map.gridmap[i][y] = 'E'
        end
    end
    return map
end

function GenerateObjects()
    map.objects = {}
    map.objects[1] = {}
    map.objects[2] = {}
    map.objects[1].name='seashell'
    map.objects[2].name='mooringpost'

    for index, value in ipairs(map.objects) do
        local objloc = GetRandomAvailableLocation(map.gridmap, map.gridsize)
        map.gridmap[objloc.x][objloc.y] = index
    end
end