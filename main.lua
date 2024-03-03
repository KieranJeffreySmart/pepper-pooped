

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
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


local goodbye_message_anim = {}
local dog_leashed_anim = {}
local dog_running_anim = {}
local dog_positioning_anim = {}
local dog_pooping_anim = {}
local dog_walking_anim = {}
local dog_waiting_anim = {}
local player_unleashing_anim = {}
local player_waiting_anim = {}
LastGeneratedRandomLocation = {}

function Restart()
    goodbye_message_anim.max_duration = EXIT_CUTSCENE_DURATION
    goodbye_message_anim.max_frame_duration = goodbye_message_anim.max_duration / EXIT_CUTSCENE_FPS
    goodbye_message_anim.frame = 1
    goodbye_message_anim.total_frame_count = 1
    goodbye_message_anim.frame_duration = goodbye_message_anim.max_frame_duration
    goodbye_message_anim.frame_count = 4
    goodbye_message_anim.xincrement = 60
    goodbye_message_anim.xupdate = 0
    goodbye_message_anim.playtime = 0


    dog_leashed_anim.max_duration = 5
    dog_leashed_anim.max_frame_duration = dog_leashed_anim.max_duration / INTRO_CUTSCENE_FPS
    dog_leashed_anim.frame = 1
    dog_leashed_anim.total_frame_count = 1
    dog_leashed_anim.frame_duration = dog_leashed_anim.max_frame_duration
    dog_leashed_anim.frame_count = 4
    dog_leashed_anim.playtime = 0

    dog_running_anim.max_duration = 10
    dog_running_anim.max_frame_duration = dog_running_anim.max_duration / INTRO_CUTSCENE_FPS
    dog_running_anim.frame = 1
    dog_running_anim.total_frame_count = 1
    dog_running_anim.frame_duration = dog_running_anim.max_frame_duration
    dog_running_anim.frame_count = 4
    dog_running_anim.playtime = 0

    dog_positioning_anim.max_duration = 3
    dog_positioning_anim.max_frame_duration = dog_positioning_anim.max_duration / INTRO_CUTSCENE_FPS
    dog_positioning_anim.frame = 1
    dog_positioning_anim.total_frame_count = 1
    dog_positioning_anim.frame_duration = dog_positioning_anim.max_frame_duration
    dog_positioning_anim.frame_count = 4
    dog_positioning_anim.playtime = 0

    dog_pooping_anim.max_duration = 2
    dog_pooping_anim.max_frame_duration = dog_pooping_anim.max_duration / INTRO_CUTSCENE_FPS
    dog_pooping_anim.frame = 1
    dog_pooping_anim.total_frame_count = 1
    dog_pooping_anim.frame_duration = dog_pooping_anim.max_frame_duration
    dog_pooping_anim.frame_count = 4
    dog_pooping_anim.playtime = 0

    dog_walking_anim.max_duration = 3
    dog_walking_anim.max_frame_duration = dog_walking_anim.max_duration / INTRO_CUTSCENE_FPS
    dog_walking_anim.frame = 1
    dog_walking_anim.total_frame_count = 1
    dog_walking_anim.frame_duration = dog_walking_anim.max_frame_duration
    dog_walking_anim.frame_count = 4
    dog_walking_anim.playtime = 0

    dog_waiting_anim.max_duration = INTRO_CUTSCENE_DURATION
    dog_waiting_anim.max_frame_duration = dog_waiting_anim.max_duration / INTRO_CUTSCENE_FPS
    dog_waiting_anim.frame = 1
    dog_waiting_anim.total_frame_count = 1
    dog_waiting_anim.frame_duration = dog_waiting_anim.max_frame_duration
    dog_waiting_anim.frame_count = 4
    dog_waiting_anim.playtime = 0

    player_unleashing_anim.max_duration = 2
    player_unleashing_anim.max_frame_duration = player_unleashing_anim.max_duration / INTRO_CUTSCENE_FPS
    player_unleashing_anim.frame = 1
    player_unleashing_anim.total_frame_count = 1
    player_unleashing_anim.frame_duration = player_unleashing_anim.max_frame_duration
    player_unleashing_anim.frame_count = 4
    player_unleashing_anim.playtime = 0

    player_waiting_anim.max_duration = INTRO_CUTSCENE_DURATION
    player_waiting_anim.max_frame_duration = player_waiting_anim.max_duration / INTRO_CUTSCENE_FPS
    player_waiting_anim.frame = 1
    player_waiting_anim.total_frame_count = 1
    player_waiting_anim.frame_duration = player_waiting_anim.max_frame_duration
    player_waiting_anim.frame_count = 4
    player_waiting_anim.playtime = 0

    LastGeneratedRandomLocation.x = 0
    LastGeneratedRandomLocation.y = 0


    -- love.graphics:setDefaultfilter("nearest")
    goodbye_message_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    goodbye_message_anim.quad = love.graphics.newQuad(EXIT_CUTSCENE_X, EXIT_CUTSCENE_Y, 32, 32, goodbye_message_anim.image:getDimensions())

    dog_leashed_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog_leashed_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog_leashed_anim.image:getDimensions())

    dog_running_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog_running_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog_running_anim.image:getDimensions())

    dog_positioning_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog_positioning_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog_positioning_anim.image:getDimensions())

    dog_pooping_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog_pooping_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog_pooping_anim.image:getDimensions())

    dog_walking_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog_walking_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog_walking_anim.image:getDimensions())

    dog_waiting_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    dog_waiting_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, DOG_DEFAULT_BOX_X, DOG_DEFAULT_BOX_Y, dog_waiting_anim.image:getDimensions())

    player_unleashing_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    player_unleashing_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, PLAYER_DEFAULT_BOX_X, PLAYER_DEFAULT_BOX_Y, player_unleashing_anim.image:getDimensions())

    player_waiting_anim.image = love.graphics.newImage("dog2_32x32.bmp")
    player_waiting_anim.quad = love.graphics.newQuad(INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y, PLAYER_DEFAULT_BOX_X, PLAYER_DEFAULT_BOX_Y, player_waiting_anim.image:getDimensions())

    Dog.state = 0
    Dog.location = {}
    Dog.location.x = 1
    Dog.location.y = 1
    Dog.scalepx = INTRO_CUTSCENE_SCALE
    Dog.locationpx = {}
    Dog.locationpx.x = 0
    Dog.locationpx.y = 0
    Player.state = 0
    Player.location = {}
    Player.location.x = 0
    Player.location.y = 1
    Player.scalepx = INTRO_CUTSCENE_SCALE
    Player.locationpx = {}
    Player.locationpx.x = 0
    Player.locationpx.y = 0
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

function PlayAnimation(animation)
    animation.playtime = animation.playtime + animation.max_frame_duration
    animation.frame_duration = animation.max_frame_duration
    animation.frame = animation.frame + 1
    animation.total_frame_count = animation.total_frame_count + 1
    if animation.frame > animation.frame_count then
        animation.frame = 1
    end
end

function AnimatePlayer(dt)
    if Player.state == PLAYER_UNLEASHING then
        player_unleashing_anim.frame_duration = player_unleashing_anim.frame_duration - dt
        if player_unleashing_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            PlayAnimation(player_unleashing_anim)
            if(player_unleashing_anim.playtime >= player_unleashing_anim.max_duration) then
                Dog.state = DOG_RUNNING
                Player.state = PLAYER_WAITING
                IntroState = INTRO_CUTSCENE
            end
        end
    elseif Player.state == PLAYER_WAITING then
        player_waiting_anim.frame_duration = player_waiting_anim.frame_duration - dt
        if player_waiting_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            PlayAnimation(player_waiting_anim)
        end
    else
        Player.state = PLAYER_UNLEASHING
    end
end

function AnimateDog(dt)
    if Dog.state == DOG_LEASHED then
        dog_leashed_anim.frame_duration = dog_leashed_anim.frame_duration - dt
        if dog_leashed_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            PlayAnimation(dog_leashed_anim)
        end
    elseif Dog.state == DOG_RUNNING then
        dog_running_anim.frame_duration = dog_running_anim.frame_duration - dt
        if dog_running_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            PlayAnimation(dog_running_anim)
            local randomLocation = GetRandomAvailableLocation(Game.map.gridmap, Game.map.gridsize)
            Dog.location.x = randomLocation.x
            Dog.location.y = randomLocation.y
            if(dog_running_anim.playtime >= dog_running_anim.max_duration) then
                Dog.location.x = Game.pooplocation.x
                Dog.location.y = Game.pooplocation.y
                Dog.state = DOG_POSITIONING
            end
        end 
    elseif Dog.state == DOG_POSITIONING then
        dog_positioning_anim.frame_duration = dog_positioning_anim.frame_duration - dt
        if dog_positioning_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            PlayAnimation(dog_positioning_anim)
        end
        if(dog_positioning_anim.playtime >= dog_positioning_anim.max_duration) then
            Dog.state = DOG_POOPING
        end
    elseif Dog.state == DOG_POOPING then
        dog_pooping_anim.frame_duration = dog_pooping_anim.frame_duration - dt
        if dog_pooping_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            PlayAnimation(dog_pooping_anim)
        end
        
        if(dog_pooping_anim.playtime >= dog_pooping_anim.max_duration) then
            Dog.state = DOG_WALKING
        end
    elseif Dog.state == DOG_WALKING then
        dog_walking_anim.frame_duration = dog_walking_anim.frame_duration - dt
        if dog_walking_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            PlayAnimation(dog_walking_anim)
        
            if (Dog.location.x > 1) then
                Dog.location.x = Dog.location.x -1
            else
                if (Dog.location.y > 1) then
                    Dog.location.y = Dog.location.y -1
                end
            end
            if(dog_walking_anim.playtime >= dog_walking_anim.max_duration) then
                Dog.state = DOG_WAITING
                IntroState = INTRO_WAIT_INPUT
            end
        end
    elseif Dog.state == DOG_WAITING then
        dog_waiting_anim.frame_duration = dog_waiting_anim.frame_duration - dt
        if dog_waiting_anim.frame_duration <= 0 then -- remember we are working from after frame 1  
            PlayAnimation(dog_waiting_anim)
        end
    else
        Dog.state = DOG_LEASHED
    end
end

function love.update(dt)
    if LoopState==LOOP_MENU then
        Restart()
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
                goodbye_message_anim.frame_duration = goodbye_message_anim.frame_duration - dt
                if goodbye_message_anim.frame_duration <= 0 then -- remember we are working from after frame 1                 
                    goodbye_message_anim.playtime = goodbye_message_anim.playtime + goodbye_message_anim.max_frame_duration
                    goodbye_message_anim.frame_duration = goodbye_message_anim.max_frame_duration
                    goodbye_message_anim.frame = goodbye_message_anim.frame + 1
                    goodbye_message_anim.total_frame_count = goodbye_message_anim.total_frame_count + 1
                    if goodbye_message_anim.frame > goodbye_message_anim.frame_count then
                        goodbye_message_anim.frame = 1
                    end

                    goodbye_message_anim.xupdate = 60 * (goodbye_message_anim.total_frame_count - 1)
                    if(goodbye_message_anim.playtime >= EXIT_CUTSCENE_DURATION) then
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
    love.graphics.print("Playe State: " .. Player.state, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+40)
    love.graphics.print("Player: x " .. Player.location.x .. " y " .. Player.location.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+60)
    love.graphics.print("Player px: x " .. Player.locationpx.x .. " y " .. Player.locationpx.y .. " scale " .. Player.scalepx, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+80)
    love.graphics.print("Dog State: " .. Dog.state, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+100)
    love.graphics.print("Dog: x " .. Dog.location.x .. " y " .. Dog.location.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+120)
    love.graphics.print("Dog px: x " .. Dog.locationpx.x .. " y " .. Dog.locationpx.y .. " scale " .. Dog.scalepx, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+140)
    love.graphics.print("Poop: x " .. Game.pooplocation.x .. " y " .. Game.pooplocation.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+160)
    love.graphics.print("map: x " .. Game.map.gridsize.x .. " y " .. Game.map.gridsize.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+180)
    love.graphics.print("rndloc: x " .. LastGeneratedRandomLocation.x .. " y " .. LastGeneratedRandomLocation.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+200)
end

function DrawDog()
    Dog.locationpx.x = INTRO_CUTSCENE_X + (Dog.location.x * INTRO_CELL_WIDTH)
    Dog.locationpx.y = INTRO_CUTSCENE_Y
    Dog.scalepx = INTRO_CUTSCENE_SCALE + math.percent(Dog.location.y*10, INTRO_CUTSCENE_SCALE)

    if Dog.state == DOG_LEASHED then
        DrawAnimation(dog_leashed_anim, Dog.locationpx, Dog.scalepx)
        --write title
    elseif Dog.state == DOG_RUNNING then
        DrawAnimation(dog_running_anim, Dog.locationpx, Dog.scalepx)
    elseif Dog.state == DOG_POSITIONING then
        DrawAnimation(dog_positioning_anim, Dog.locationpx, Dog.scalepx)
        --write title
    elseif Dog.state == DOG_POOPING then
        DrawAnimation(dog_pooping_anim, Dog.locationpx, Dog.scalepx)
        --
    elseif Dog.state == DOG_WALKING then
        love.graphics.print("here!", PLAYER_SPEACH_X, PLAYER_SPEACH_Y)
        DrawAnimation(dog_walking_anim, Dog.locationpx, Dog.scalepx)
    elseif Dog.state == DOG_WAITING then
        DrawAnimation(dog_waiting_anim, Dog.locationpx, Dog.scalepx)
    end
end

function DrawAnimation(animation, location, scale)
    love.graphics.draw(animation.image, animation.quad, location.x, location.y, 0, scale, -scale)
end

function DrawPlayer()
    Player.locationpx.x = INTRO_CUTSCENE_X + Player.location.x * INTRO_CELL_WIDTH
    Player.locationpx.y = INTRO_CUTSCENE_Y
    Player.scalepx = INTRO_CUTSCENE_SCALE + math.percent(Player.location.y*10, INTRO_CUTSCENE_SCALE)
    if Player.state == PLAYER_UNLEASHING then
        DrawAnimation(player_unleashing_anim, Player.locationpx, Player.scalepx)
    elseif Player.state == PLAYER_WAITING then
        DrawAnimation(player_waiting_anim, Player.locationpx, Player.scalepx)
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