mapping = {}
function mapping.GetRandomAvailableLocation(gridmap, gridsize)
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

g = {}

    function g.NewGame()
        return RandomGame()
    end

    function RandomGame()
        local game = {}
        game.map  = GetMap(1)
        game.poop = GetPoop(1)
        game.pooplocation = mapping.GetRandomAvailableLocation(game.map.gridmap, game.map.gridsize)
        game.map.gridmap[game.pooplocation.x][game.pooplocation.y] = 'P'
        game.sitlocation = mapping.GetRandomAvailableLocation(game.map.gridmap, game.map.gridsize)
        game.map.gridmap[game.sitlocation.x][game.sitlocation.y] = 'D'
        game.start = {}
        game.start.x = 1
        game.start.y = 5
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




    function GetMap(mapid)
        local map = {}
        map.id = mapid
        map.backgroundimage = ''
        map.backgroundsize = {}
        map.backgroundsize.x = 250
        map.backgroundsize.y = 250

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