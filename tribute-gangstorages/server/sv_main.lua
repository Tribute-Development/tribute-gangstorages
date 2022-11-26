local QBCore = exports['qb-core']:GetCoreObject();

local hackable = Shared.Hackable

local ginfo = Shared.Info

local agangs = Shared.AuthorizedGangs

local members = {
    ['crip'] = 0,
    ['dow'] = 0,
    ['ballas'] = 0,
    ['syn'] = 0,
    ['bnj'] = 0
}


AddEventHandler('playerDropped', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    members[gang] = members[gang] - 1
    print('Member leave detected, new '..gang..' gang members online : '..members[gang])
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    members[gang] = members[gang] + 1
    print('New login detected: New '..gang..' Gang Members: '..members[gang])
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
    TriggerEvent('tirbute-gangstorages:server:UpdateGangMembers')
    end
end)

RegisterNetEvent('tirbute-gangstorages:server:UpdateGangMembers', function()
    local src = source
    local Players = QBCore.Functions.GetPlayers()
    for i=1, #Players do
        local player = QBCore.Functions.GetPlayer(Players[i])
        for k,v in pairs(ginfo) do 
            if player.PlayerData.gang.name == k then
                local pgang = player.PlayerData.gang.name 
                members[pgang] = members[pgang] + 1
                print('Updating Gang Members: New '..pgang..' Gang Members: '..members[pgang])
            end
        end
    end
end)

RegisterNetEvent('tribute-gangstorages:server:NotifyGangMembers', function(gang)
    local src = source
    local Players = QBCore.Functions.GetPlayers()
    for i=1, #Players do
        local player = QBCore.Functions.GetPlayer(Players[i])
        print('Alerting gang of stash break in')
        if player.PlayerData.gang.name == gang then
            TriggerClientEvent('tribute-gangstorages:client:ShowNotification', player.PlayerData.source)
            print('Alerted '..gang..' of stash break in')
        end
    end
end)

function showNotify(src)
    print('Alerting')
    TriggerClientEvent('tribute-gangstorages:client:ShowNotification', src)
    print('Alerted')
end

RegisterNetEvent('tribute-gangstorages:server:HackGangStorages', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    local pos = GetEntityCoords(GetPlayerPed(src))
    local gtable = Shared.AuthorizedGangs
    if Shared.RequireItem then
        print('Item Required')
        if Player.Functions.GetItemByName(Shared.ItemNeeded) then --Item check
            for k,v in pairs(gtable) do
                if gang == k then
                    if hackable then
                        for k,v in pairs(ginfo) do
                            local distance = #(pos - v['enterzone'])
                            if distance <= 5 then
                            if v['state'] == true then
                                if members[gang] >= v['requiredmembers'] then
                                    if gang == v['gang'] then
                                        TriggerClientEvent('QBCore:Notify', src, 'You cannot rob your own stash', 'error')
                                        return
                                    else
                                        TriggerEvent('tribute-gangstorages:server:NotifyGangMembers', v['gang'])
                                        TriggerClientEvent('tribute-gangstorages:client:HackStash', src, true)
                                        return
                                    end
                                else
                                    TriggerClientEvent('QBCore:Notify', src, 'Not enough enemy members online', 'error')
                                    return
                                end
                            else
                                if v['state'] ~= true then
                                    print('Not applicable')
                                    TriggerClientEvent('QBCore:Notify', src, 'Stash is not robable', 'error')
                                    return
                                end
                            end
                        end
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', src, 'Stashes are not robable', 'error')
                    end
                    return
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'You are missing something', 'error')
        end
    else
        print('No Item required')
        for k,v in pairs(gtable) do
            if gang == k then
                if hackable then
                    for k,v in pairs(ginfo) do
                        local distance = #(pos - v['enterzone'])
                        if distance <= 5 then
                        if v['state'] == true then
                            if members[gang] >= v['requiredmembers'] then
                                if gang == v['gang'] then
                                    TriggerClientEvent('QBCore:Notify', src, 'You cannot rob your own stash', 'error')
                                    return
                                else
                                    TriggerEvent('tribute-gangstorages:server:NotifyGangMembers', v['gang'])
                                    TriggerClientEvent('tribute-gangstorages:client:HackStash', src, true)
                                    return
                                end
                            else
                                TriggerClientEvent('QBCore:Notify', src, 'Not enough enemy members online', 'error')
                                return
                            end
                        else
                            if v['state'] ~= true then
                                print('Not applicable')
                                TriggerClientEvent('QBCore:Notify', src, 'Stash is not robable', 'error')
                                return
                            end
                        end
                    end
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Stashes are not robable', 'error')
                end
                return
            end
        end
    end
end)

function SetState(gang, state, table)
    for k,v in pairs(table) do
        if gang == k then
            v['state'] =  state
        else
            print('Unknown gang or information not in shared.lua')
            return
        end
    end
end

exports('SetState', SetState)