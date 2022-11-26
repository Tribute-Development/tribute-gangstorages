local QBCore = exports['qb-core']:GetCoreObject();

local ginfo = Shared.Info

function TeleportToInterior(x, y, z, h)
    CreateThread(function()
        SetEntityCoords(PlayerPedId(), x, y, z, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), h)

        Wait(100)

        DoScreenFadeIn(1000)
    end)
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
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
                        label = 'Hack Warehouse'
                    }
                },
            distance = 1.5
        })
    end
end)

AddEventHandler('onResourceStart', function()
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
                        label = 'Hack Warehouse'
                    }
                },
            distance = 1.5
        })
    end
end)

RegisterNetEvent('tribute-gangstorages:client:CreateGangStash', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local gang = PlayerData.gang.name
    local objects = {}
    local model = 'container2_shell'
    for k,v in pairs(ginfo) do
        if gang == k then
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(10)
            end
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(1000)
            end
            local spot = CreateObject(model, v['location'].x, v['location'].y, v['location'].z, false, false, false)
            createExitZones('exit'..gang..'stash', v['exitzone'], k)
            createStash('storage'..gang..'1', v['stashcoords'], gang)
            FreezeEntityPosition(spot, true)
            objects[#objects+1] = spot
            TeleportToInterior(v['entercoords'].x, v['entercoords'].y, v['entercoords'].z, 353.99679)
            return {objects}
        end
    end
end)

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

RegisterNetEvent('tribute-gangstorages:client:ExitGangStash', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local gang = PlayerData.gang.name
    local pos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(ginfo) do
        local distance = #(pos - v['exitzone'])
        if distance <= 6 then
            TeleportToInterior(v['exitcoords'].x, v['exitcoords'].y, v['exitcoords'].z, 353.99679)
        end
    end
end)

RegisterNetEvent('tribute-gangstorages:client:CreateStash', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local gang = PlayerData.gang.name
    local pos = GetEntityCoords(PlayerPedId())
    for k,v in pairs(ginfo) do
        local distance = #(pos - v['stashcoords'])
        if distance <= 12 then
            TriggerEvent("inventory:client:SetCurrentStash", v['gang'])
	        TriggerServerEvent("inventory:server:OpenInventory", "stash", v['gang'], {
		        maxweight = v['weight'],
		        slots = v['slots'],
	        })
        end
    end
end)

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

RegisterNetEvent('tribute-gangstorages:client:HackStash', function(state)
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
                    TriggerEvent('tribute-gangstorages:client:HackSuccess')
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

RegisterNetEvent('tribute-gangstorages:client:HackSuccess', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local gang = PlayerData.gang.name
    local pos = GetEntityCoords(PlayerPedId())
    local objects = {}
    local model = 'container2_shell'
    for k,v in pairs(ginfo) do
        local distance = #(pos - v['enterzone'])
        if distance <= 5 then
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do
                Wait(10)
            end
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(1000)
            end
            local spot = CreateObject(model, v['location'].x, v['location'].y, v['location'].z, false, false, false)
            createExitZones('exit'..v['gang']..'stash', v['exitzone'], k)
            createStash('storage'..v['gang']..'1', v['stashcoords'], v['gang'])
            FreezeEntityPosition(spot, true)
            objects[#objects+1] = spot
            TeleportToInterior(v['entercoords'].x, v['entercoords'].y, v['entercoords'].z, 353.99679)
            return {objects}
        end
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