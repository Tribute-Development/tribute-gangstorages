local QBCore = exports['qb-core']:GetCoreObject();

local hackable = Shared.Hackable

local ginfo = Shared.Info

local members = {}

-- Functions

function SetState(gang, state)
    for k,v in pairs(gtable) do
        if gang == k then
            if type(state) ~= "boolean" then return false end
            v['state'] = state
            print('State is Updated for '..QBCore.Shared.Gangs[gang].label)
        end
    end
end

exports('SetState', SetState)

function GetClosestGangStash(pos)
    for k,v in pairs(Shared.Info) do
        local distance = #(pos - v.enterzone)
        if distance <= 5 then
            return k
        end
    end
end

function EnoughMembers(gang)
    if members[gang] >= Shared.Info[gang].requiredmembers then
        return true
    else
        return false
    end
end

function SameGang(gang, v, src)
    if gang ~= Shared.Info[v].gang then
        return true
    else
        TriggerClientEvent('QBCore:Notify', src, 'You cannot rob your own stash', 'error')
        return false
    end
end

-- Handlers

AddEventHandler('playerDropped', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    if Shared.Info[gang] then
        members[gang] = members[gang] - 1
        print('Member leave detected, new '..gang..' gang members online : '..members[gang])
    end
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded')
AddEventHandler('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    if Shared.Info[gang] then
        if not members[gang] then
            members[gang] = 0
        end
        members[gang] = members[gang] + 1
        print('New login detected: New '..gang..' Gang Members: '..members[gang])
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
    TriggerEvent('tirbute-gangstorages:server:UpdateGangMembers')
    end
end)

-- Commands

QBCore.Commands.Add('tsetmetadata', 'Set Meta Data', {{name = "id", help = "Player Id"}, {name = "reptype", help = "Type of rep"}, {name = "amount", help = "Amount to set rep to"}}, false, function(source, args)
    local src = source
    local id = tonumber(args[1])
    local rep = args[2]
    local amount = tonumber(args[3])
    local Player = QBCore.Functions.GetPlayer(id)
    Player.Functions.SetMetaData(rep, amount)
    print('Player: '..Player.PlayerData.name..' ,Rep Type: '..rep..' has been set to '..tonumber(amount))
end, 'admin')

-- Events

RegisterNetEvent('tirbute-gangstorages:server:UpdateGangMembers', function()
    local src = source
    local Players = QBCore.Functions.GetPlayers()
    for i=1, #Players do
        local player = QBCore.Functions.GetPlayer(Players[i])
        for k,v in pairs(ginfo) do
            if not members[k] then 
                members[k] = 0
            end
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
        if player.PlayerData.gang.name == gang and ginfo[gang] then
            TriggerClientEvent('tribute-gangstorages:client:ShowNotification', player.PlayerData.source)
        end
    end
end)

RegisterNetEvent('tribute-gangstorages:server:HackGangStorages', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local gang = Player.PlayerData.gang.name
    local pos = GetEntityCoords(GetPlayerPed(src))
    local info = Shared.Info
    if Shared.RequireItem then
        if exports['qb-inventory']:HasItem(src, Shared.ItemNeeded) then
            if info[gang] and hackable then
                local stash = GetClosestGangStash(pos)
                if info[stash].state then
                    if EnoughMembers(stash) and SameGang(gang, stash, src)then
                        TriggerEvent('tribute-gangstorages:server:NotifyGangMembers', info[stash].gang)
                        TriggerClientEvent('tribute-gangstorages:client:HackStash', src, true, stash)
                    else
                        TriggerClientEvent('QBCore:Notify', src, 'Not enough enemy gang members online', 'error')
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Stash is not robable', 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'Stashes are not robable', 'error')
            end
        else 
            TriggerClientEvent('QBCore:Notify', src, 'You are missing something', 'error')
        end 
    else
        if info[gang] then
            local stash = GetClosestGangStash(pos)
            if hackable then
                if info[stash].state then
                    if EnoughMembers(stash) and SameGang(gang, stash, src) then 
                        TriggerEvent('tribute-gangstorages:server:NotifyGangMembers', info[stash].gang)
                        TriggerClientEvent('tribute-gangstorages:client:HackStash', src, true, stash)
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Stash is not robable', 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'Stashes are not robable', 'error')
            end
        end
    end
end)