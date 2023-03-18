local QBCore = exports['qb-core']:GetCoreObject();

local ginfo = Shared.Info

-- Functions
function TeleportToInterior(x, y, z, h)
    CreateThread(function()
        SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), h)

        Wait(100)

        DoScreenFadeIn(1000)
    end)
end

function authorization(gang)
    if Shared.Info[gang] then
        return true
    else
        return false
    end
end

function GetClosestGangStash(pos)
    for k,v in pairs(Shared.Info) do
        local distance = #(pos - v.enterzone)
        if distance <= 5 then
            return k
        end
    end
end

function createExitZones(name, coords, gang)
    exports['qb-target']:AddBoxZone(gang, coords, 1, 1, {
        name=name,
        heading=57.45,
        debugPoly=false,
        minZ = coords.z - 2.0,
        maxZ = coords.z + 2.0
        }, {
            options = {
                {
                    type = 'client',
                    event = 'tribute-gangstorages:client:ExitGangStash',
                    icon = 'fas fa-warehouse',
                    label = 'Exit Gang Storage',
                },
            },
        distance = 1.5
    })
end

function createStash(name, coords, gang)
    exports['qb-target']:AddBoxZone(name, coords, 1, 1, {
        name=name,
        heading=57.45,
        debugPoly=false,
        minZ = coords.z - 2.0,
        maxZ = coords.z + 2.0
        }, {
            options = {
                {
                    type = 'client',
                    event = 'tribute-gangstorages:client:CreateStash',
                    icon = 'fas fa-warehouse',
                    label = 'Open Gang Storage',
                },
            },
        distance = 1.5
    })
end

function pdCheck(job)
    local pd = Shared.PDJobs
    for i=1, #pd do
        if job == pd[i] then
            return true
        end
    end
    return false
end

function CreateRaidStash()
    local model = 'container2_shell'
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local objects = {}
    local stash = GetClosestGangStash(coords)
    TriggerServerEvent('tribute-gangstorages:server:NotifyGangMembers', stash)
    if ginfo[stash] then
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(10)
        end
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1000)
        end
        local raidedarea = CreateObject(model, Shared.Info[stash].location.x, Shared.Info[stash].location.y, Shared.Info[stash].location.z, false, false, false)
        createExitZones('exit'..stash..'stash', Shared.Info[stash].exitzone, stash)
        createStash('storage'..stash..'1', Shared.Info[stash].stashcoords, stash)
        FreezeEntityPosition(raidedarea, true)
        objects[#objects+1] = raidedarea
        TeleportToInterior(Shared.Info[stash].entercoords.x, Shared.Info[stash].entercoords.y, Shared.Info[stash].entercoords.z, 354.99679)
    end
end

function RaidStash()
    local time = math.random(1, 9)
    local circles = math.random(1, 5)
    local success = exports['qb-lock']:StartLockPickCircle(circles, time, success)
    if success then
        CreateRaidStash()
    else
        QBCore.Functions.Notify('You Are Trash', 'error', 7500)
    end
end

-- Handlers

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    local Data = QBCore.Functions.GetPlayerData()
    local gang = Data.gang.name
    for k,v in pairs(ginfo) do
        exports['qb-target']:AddBoxZone(v.name, v.enterzone, 1, 1, {
            name=v.name,
            heading=57.45,
            debugPoly=false,
            minZ = v.enterzone.z - 2.0,
            maxZ = v.enterzone.z + 2.0,
            }, {
                options = {
                    {
                        type = 'client',
                        event = 'tribute-gangstorages:client:CreateGangStash',
                        icon = 'fas fa-warehouse',
                        label = 'Enter Gang Storage',
                        gang = v.gang
                    },
                    {
                        type = 'server',
                        event = 'tribute-gangstorages:server:HackGangStorages',
                        icon = 'fas fa-microchip',
                        label = 'Hack Warehouse',
                        canInteract = function()
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)
                            local distance = #(pos - v['enterzone'])
                            if distance <=5 then
                                if gang ~= v['gang'] and authorization(gang) then
                                    return true
                                end
                            end
                        end
                    },
                    {
                        type = "client",
                        event = "tribute-gangstorages:client:policeraid",
                        icon = "fas fa-shield",
                        label = "Raid Gang Storage",
                        canInteract = function()
                            if pdCheck(Data.job.name) then
                                if exports['qb-inventory']:HasItem('signed_warrant') then return true end
                            end
                        end
                    }
                },
            distance = 1.5
        })
    end
end)

AddEventHandler('onResourceStart', function()
    local Data = QBCore.Functions.GetPlayerData()
    local gang = Data.gang.name
    for k,v in pairs(ginfo) do
        exports['qb-target']:AddBoxZone(v.name, v.enterzone, 1, 1, {
            name=v.name,
            heading=57.45,
            debugPoly=false,
            minZ = v.enterzone.z - 2.0,
            maxZ = v.enterzone.z + 2.0,
            }, {
                options = {
                    {
                        type = 'client',
                        event = 'tribute-gangstorages:client:CreateGangStash',
                        icon = 'fas fa-warehouse',
                        label = 'Enter Gang Storage',
                        gang = v.gang
                    },
                    {
                        type = 'server',
                        event = 'tribute-gangstorages:server:HackGangStorages',
                        icon = 'fas fa-microchip',
                        label = 'Hack Warehouse',
                        canInteract = function()
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)
                            local distance = #(pos - v['enterzone'])
                            if distance <=5 then
                                if gang ~= v['gang'] and authorization(gang) then
                                    return true
                                end
                            end
                        end
                    },
                    {
                        type = "client",
                        event = "tribute-gangstorages:client:policeraid",
                        icon = "fas fa-shield",
                        label = "Raid Gang Storage",
                        canInteract = function()
                            if pdCheck(Data.job.name) then
                                if exports['qb-inventory']:HasItem('signed_warrant') then return true end
                            end
                        end
                    }
                },
            distance = 1.5
        })
    end
end)

-- Events 

RegisterNetEvent('tribute-gangstorages:client:CreateGangStash', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local gang = PlayerData.gang.name
    local objects = {}
    local model = 'container2_shell'
    if ginfo[gang] then
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(10)
        end
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1000)
        end
        local spot = CreateObject(model, ginfo[gang].location.x, ginfo[gang].location.y, ginfo[gang].location.z, false, false, false)
        createExitZones('exit'..gang..'stash', ginfo[gang].exitzone, gang)
        createStash('storage'..gang..'1', ginfo[gang].stashcoords, gang)
        FreezeEntityPosition(spot, true)
        objects[#objects+1] = spot
        TeleportToInterior(ginfo[gang].entercoords.x, ginfo[gang].entercoords.y, ginfo[gang].entercoords.z, 353.99679)
        return {objects}
    end
end)

RegisterNetEvent('tribute-gangstorages:client:ExitGangStash', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local gang = PlayerData.gang.name
    local pos = GetEntityCoords(PlayerPedId())
    if ginfo[gang] then
        TeleportToInterior(ginfo[gang].exitcoords.x, ginfo[gang].exitcoords.y, ginfo[gang].exitcoords.z, 353.99679)
    end
end)

RegisterNetEvent('tribute-gangstorages:client:CreateStash', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local gang = PlayerData.gang.name
    local pos = GetEntityCoords(PlayerPedId())
    if ginfo[gang] then
        TriggerEvent("inventory:client:SetCurrentStash", gang)
        TriggerServerEvent("inventory:server:OpenInventory", "stash", gang, {
            maxweight = ginfo[gang].weight,
            slots = ginfo[gang].slots,
        })
    end
end)

RegisterNetEvent('tribute-gangstorages:client:HackStash', function(state, stash)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local hackable = state
    if hackable then
        LocalPlayer.state:set('inv_busy', true, true)
        TriggerEvent('animations:client:EmoteCommandStart', { "mechanic" })
        QBCore.Functions.Progressbar('name_here', 'Breaking Into Stash', 3500, false, true, { -- Name | Label | Time | useWhileDead | canCancel
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            LocalPlayer.state:set('inv_busy', false , true)
            TriggerEvent('animations:client:EmoteCommandStart', { "c" })
            exports['varhack']:OpenHackingGame(function(success)
                if success then
                    TriggerEvent('tribute-gangstorages:client:HackSuccess', stash)
                else
                    print("failed")
                end
            end, Shared.Boxes, Shared.Time)
        end, function()
            TriggerEvent('animations:client:EmoteCommandStart', { "c" })
            LocalPlayer.state:set('inv_busy', false, true)
            QBCore.Functions.Notify('Cancelled', 'error')
        end)
    else
        QBCore.Functions.Notify('You are missing something', 'error')
    end
end)

RegisterNetEvent('tribute-gangstorages:client:policeraid', function()
    local Data = QBCore.Functions.GetPlayerData()
    local job = Data.job.name
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if pdCheck(job) then
        local stash = GetClosestGangStash(coords)
        if ginfo[stash] then
            RaidStash()
        else
            QBCore.Functions.Notify('No Stash Found', 'error')
        end
    else
        QBCore.Functions.Notify('You are a not a cop', 'error', 7500)
    end
end)

RegisterNetEvent('tribute-gangstorages:client:HackSuccess', function(stash)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local gang = PlayerData.gang.name
    local pos = GetEntityCoords(PlayerPedId())
    local objects = {}
    local model = 'container2_shell'
    if Shared.Info[stash] then
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(10)
        end
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1000)
        end
        local spot = CreateObject(model, Shared.Info[stash].location.x, Shared.Info[stash].location.y, Shared.Info[stash].location.z, false, false, false)
        createExitZones('exit'..stash..'stash', Shared.Info[stash].exitzone, stash)
        createStash('storage'..stash..'1', Shared.Info[stash].stashcoords, stash)
        FreezeEntityPosition(spot, true)
        objects[#objects+1] = spot
        TeleportToInterior(Shared.Info[stash].entercoords.x, Shared.Info[stash].entercoords.y, Shared.Info[stash].entercoords.z, 354.99679)
    end
end)

RegisterNetEvent('tribute-gangstorages:client:ShowNotification', function()
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "panic", 0.1)
    SendNUIMessage({
        type = 'show'
     })
     Wait(9000)
     SendNUIMessage({
        type = 'close'
     })
end)