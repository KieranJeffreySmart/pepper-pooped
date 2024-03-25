
local log = require"log"
local anim = require"animation"

mapping = {}
function mapping.GetRandomAvailableLocation(gridmap, gridsize)
    local location = {}
    location.x = 0
    location.y = 0

    local random_x = 1
    local random_y = 1
    local findLocation = true

    while(findLocation) do
        random_x = math.random(gridsize.x)
        random_y = math.random(gridsize.y)
        if (gridmap[random_x][random_y] == 'E') then
            location.x = random_x
            location.y = random_y
            findLocation = false
        end
    end

    return location
end

POOP_DROPPED = 1

QUAD_WIDTH = 16
QUAD_HEIGHT = 16
g = {}

    function g.NewGame()
        return RandomGame()
    end

    function RandomGame()
        local game = {}
        game.map  = GetMap(1)
        game.pooplocation = mapping.GetRandomAvailableLocation(game.map.gridmap, game.map.gridsize)
        log.debug("poop location: x = ", game.pooplocation.x, " y = ", game.pooplocation.y)
        game.map.gridmap[game.pooplocation.x][game.pooplocation.y] = 'S'
        game.poop = GetPoop(1, game.pooplocation, POOP_DROPPED)
        game.sitlocation = mapping.GetRandomAvailableLocation(game.map.gridmap, game.map.gridsize)
        log.debug("sit location: x = ", game.sitlocation.x, " y = ", game.sitlocation.y)
        game.map.gridmap[game.sitlocation.x][game.sitlocation.y] = 'D'
        game.start = {}
        game.start.x = 1
        game.start.y = 5
        game.map.gridmap[game.start.x][game.start.y] = 'P'
        return game
    end

    function GetPoop(poopid, location, defaultState)
        local poop = {}
        poop.id = poopid
        poop.location = { x = location.x, y = location.y }
        poop.state = defaultState

        poop.animations = {}

        local image = love.graphics.newImage("poop_animations_16x16.bmp")

        poop.image = image
        poop.animations[POOP_DROPPED] = anim.NewAnimation(POOP_DROPPED)
        local yPos = 0
        local leashedClip = anim.NewClip(0, yPos, 1, QUAD_WIDTH, QUAD_HEIGHT, image)
        if (leashedClip) then
            table.insert(poop.animations[POOP_DROPPED].cliplist, leashedClip)
        end

        return poop
    end




    function GetMap(mapid)
        local map = {}
        map.id = mapid
        map.backgroundimage = 'map_1_524x524.bmp'
        map.backgroundsize = {}
        map.backgroundsize.x = 524
        map.backgroundsize.y = 524

        map.gridsize = {}
        map.gridsize.x = 7
        map.gridsize.y = 7

        map.gridmap = {}

        for i = 1, map.gridsize.x, 1 do
            map.gridmap[i] = {}
            for y = 1, map.gridsize.y, 1 do
                map.gridmap[i][y] = 'E'
            end
        end
        
        return map
    end

    function GenerateObjects(map)
        map.objects = {}
        map.objects[1] = {}
        map.objects[2] = {}
        map.objects[1].name='seashell'
        map.objects[2].name='mooringpost'

        for index, value in ipairs(map.objects) do
            local objloc = mapping.GetRandomAvailableLocation(map.gridmap, map.gridsize)
            map.gridmap[objloc.x][objloc.y] = index
        end
    end
return g