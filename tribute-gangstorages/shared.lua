Shared = {}

Shared.Info = { -- This is how you create new gang stashes
    ['crip'] = {
        name = 'ballasstorage', --name
        location = vector3(-697.53, -879.86, 8.23), --physical location that the stash house will be created
        slots = 500, --slots of stash 
        weight = 500000, --max weight of stash
        entercoords = vector3(-697.35, -885.55, 9.35), --Coordinates player will spawn inside the stash house
        enterzone = vector3(-690.68, -880.06, 24.5), --Target Zone of the enter event
        exitzone = vector3(-697.35, -885.55, 9.35), --Target Zone of the exit event
        exitcoords = vector3(-690.68, -880.06, 24.5),--Coordinated player will spawn outside the stash house
        stashcoords = vector3(-697.58, -875.56, 9.35), --Coordinates of the stash
        gang = 'crip', --Gang that ownes
        state = true, --True/False whether the stash can be robbed
        requiredmembers = 0 --Amount of gang members needed for the stash to be robbed
    },
    ['vagos'] = {
        name = 'vagosstorage',
        location = vector3(-709.39, -1300.58, -3.53),
        slots = 500,
        weight = 500000,
        entercoords = vector3(-709.3, -1306.23, -2.41),
        enterzone = vector3(-711.55, -1299.27, 5.4),
        exitzone = vector3(-709.3, -1306.23, -2.41),
        exitcoords = vector3(-711.55, -1299.27, 5.4),
        stashcoords = vector3(-709.42, -1296.27, -2.41),
        gang = 'vagos',
        state = true,
        requiredmembers = 0
    },
}

Shared.Hackable = true --Make stashes hackable and able to be robbed by other gangs

Shared.AuthorizedGangs = { --Authorized Gangs for hacking stashes
    [1] = {
        name = 'ballas'
    },
    [2] = {
        name = 'vagos'
    }
}