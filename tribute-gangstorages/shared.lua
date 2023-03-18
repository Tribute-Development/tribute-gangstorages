Shared = {}

Shared.RequireItem = true -- Whether for the stash hacking to require item
Shared.ItemNeeded = 'hacking_device' -- Item needed for stash hacking if set to true

Shared.PDJobs = {'police', 'sasp', 'bcso', 'fib'}

Shared.Info = { -- This is how you create new gang stashes
    ['crip'] = {
        name = 'cripstorage', --name
        location = vector3(-697.53, -879.86, 8.23), --physical location that the stash house will be created
        slots = 500, --slots of stash
        weight = 7000000, --max weight of stash
        entercoords = vector3(-697.35, -885.55, 9.35), --Coordinates player will spawn inside the stash house
        enterzone = vector3(-352.79, 19.41, 52.11), --Target Zone of the enter event
        exitzone = vector3(-697.35, -885.55, 9.35), --Target Zone of the exit event
        exitcoords = vector3(-352.79, 19.41, 52.11),--Coordinated player will spawn outside the stash house
        stashcoords = vector3(-697.58, -875.56, 9.35), --Coordinates of the stash
        gang = 'crip', --Gang that ownes the storage
        state = true, --True/False whether the stash can be robbed
        requiredmembers = 4 --Amount of gang members needed for the stash to be robbed
    },
    ['bnj'] = {
        name = 'bnjstorage',
        location = vector3(-67.15, 2605.7, 81.94),
        slots = 500,
        weight = 7000000,
        entercoords = vector3(-66.92, 2600.97, 83.06),
        enterzone = vector3(268.22, 3036.61, 43.14),
        exitzone = vector3(-66.91, 2600.32, 83.06),
        exitcoords = vector3(266.43, 3035.74, 43.15),
        stashcoords = vector3(-67.19, 2610.0, 83.06),
        gang = 'bnj',
        state = true,
        requiredmembers = 4
    },
    ['syn'] = {
        name = 'synstorage',
        location = vector3(-1353.092, -135.5007, 42.15533),
        slots = 500,
        weight = 7000000,
        entercoords = vector3(-1352.968, -140.784, 43.279354),
        enterzone = vector3(-1351.712, -128.7404, 50.107284),
        exitzone = vector3(-1352.931, -141.2426, 43.279354),
        exitcoords = vector3(-1351.837, -127.8387, 50.159317),
        stashcoords = vector3(-1353.127, -131.1947, 43.279354),
        gang = 'syn',
        state = true,
        requiredmembers = 4
    },
    ['dow'] = {
        name = 'dowstorage',
        location = vector3(938.31, -2507.85, 17.67),
        slots = 500,
        weight = 7000000,
        entercoords = vector3(938.57, -2512.62, 18.79),
        enterzone = vector3(882.01, -2509.04, 48.29),
        exitzone = vector3(938.42, -2512.75, 18.79),
        exitcoords = vector3(882.15, -2508.78, 48.29),
        stashcoords = vector3(938.27, -2503.55, 18.79),
        gang = 'dow',
        state = true,
        requiredmembers = 4
    },
    ['yakuza'] = {
        name = 'yakuzastorage',
        location = vector3(-1804.12, 444.48, 93.09),
        slots = 500,
        weight = 7000000,
        entercoords = vector3(-1804.09, 439.22, 94.21),
        enterzone = vector3(-1796.83, 439.51, 129.24),
        exitzone = vector3(-1804.13, 438.89, 94.21),
        exitcoords = vector3(-1796.83, 439.51, 129.24),
        stashcoords = vector3(-1804.18, 448.78, 94.21),
        gang = 'yakuza',
        state = true,
        requiredmembers = 4
    },
}

Shared.Hackable = true --Make stashes hackable and able to be robbed by other gangs


Shared.Time = 4 -- Time for the player to see the boxes then start the hack

Shared.Boxes = 8 -- Amount of boxes in the hack