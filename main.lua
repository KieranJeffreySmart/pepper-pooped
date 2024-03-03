

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


function anim.DrawAnimation(animation, location, scale)
    love.graphics.draw(animation.image, animation.quad, location.x, location.y, 0, scale, -scale)
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
INTRO_CUTSCENE_Y = 350
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

local player_draw = require"player-draw"
local dog_draw = require"dog-draw"
local goodbye_draw = require"goodbye-draw"
local game_generator = require"game-generator"
local goodbye = goodbye_draw.NewMessage(EXIT_CUTSCENE_DURATION, EXIT_CUTSCENE_FPS, EXIT_CUTSCENE_X, EXIT_CUTSCENE_Y)
local game = {}
local player = {}
local dog = {}

LastGeneratedRandomLocation = {}

function IntroRestart()
    player = player_draw.NewPlayer(INTRO_CUTSCENE_DURATION, INTRO_CUTSCENE_FPS, INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y)
    dog = dog_draw.NewDog(INTRO_CUTSCENE_DURATION, INTRO_CUTSCENE_FPS, INTRO_CUTSCENE_X, INTRO_CUTSCENE_Y)

    LastGeneratedRandomLocation.x = 0
    LastGeneratedRandomLocation.y = 0

    -- love.graphics:setDefaultfilter("nearest")

end

function love.load()
    LoopState = LOOP_MENU
end

function love.keyreleased(key)
    if LoopState==LOOP_MENU then
        if key == COMMAND_START then
            game = game_generator.NewGame();
            dog.pooplocation = game.pooplocation
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

function love.update(dt)
    if LoopState==LOOP_MENU then
        IntroRestart()
    elseif LoopState == LOOP_INTRO then
        if dt < 0.04 then
            dog_draw.AnimateDog(dt, dog, game.map)
            player_draw.AnimatePlayer(dt, player)
            if (player.state == PLAYER_WAITING and dog.state == DOG_LEASHED) then
                dog.state = DOG_RUNNING
                IntroState = INTRO_CUTSCENE
            end
            if(dog.state == DOG_WAITING) then                
                IntroState = INTRO_WAIT_INPUT
            end
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
                goodbye_draw.AnimateMessage(dt, goodbye)
                if(goodbye.message_anim.playtime >= goodbye.message_anim.max_duration) then
                    ExitState = EXIT_CLOSE
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
        local location = {}
        location.x = EXIT_CUTSCENE_X+goodbye.message_anim.xupdate
        location.y = EXIT_CUTSCENE_Y
        anim.DrawAnimation(goodbye.message_anim, location, 3)
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

    dog.locationpx.x = INTRO_CUTSCENE_X + (dog.location.x * INTRO_CELL_WIDTH)
    dog.locationpx.y = INTRO_CUTSCENE_Y
    dog.scalepx = INTRO_CUTSCENE_SCALE + math.percent(dog.location.y*10, INTRO_CUTSCENE_SCALE)
    dog_draw.DrawDog(dog)

    player.locationpx.x = INTRO_CUTSCENE_X + player.location.x * INTRO_CELL_WIDTH
    player.locationpx.y = INTRO_CUTSCENE_Y
    player.scalepx = INTRO_CUTSCENE_SCALE + math.percent(player.location.y*10, INTRO_CUTSCENE_SCALE)
    player_draw.DrawPlayer(player)

    DrawConsole()
    
end

function DrawConsole()
    love.graphics.print("Loop State: " .. LoopState, GAME_MESSAGE_X+400, GAME_MESSAGE_Y)
    love.graphics.print("Intro State: " .. IntroState, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+20)
    love.graphics.print("Playe State: " .. player.state, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+40)
    love.graphics.print("Player: x " .. player.location.x .. " y " .. player.location.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+60)
    love.graphics.print("Player px: x " .. player.locationpx.x .. " y " .. player.locationpx.y .. " scale " .. player.scalepx, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+80)
    love.graphics.print("Dog State: " .. dog.state, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+100)
    love.graphics.print("Dog: x " .. dog.location.x .. " y " .. dog.location.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+120)
    love.graphics.print("Dog px: x " .. dog.locationpx.x .. " y " .. dog.locationpx.y .. " scale " .. dog.scalepx, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+140)
    love.graphics.print("Poop: x " .. game.pooplocation.x .. " y " .. game.pooplocation.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+160)
    love.graphics.print("map: x " .. game.map.gridsize.x .. " y " .. game.map.gridsize.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+180)
    love.graphics.print("rndloc: x " .. LastGeneratedRandomLocation.x .. " y " .. LastGeneratedRandomLocation.y, GAME_MESSAGE_X+400, GAME_MESSAGE_Y+200)

end