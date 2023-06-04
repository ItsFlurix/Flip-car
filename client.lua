ESX = exports['es_extended']:getSharedObject()
PlayerData = nil
PlayerJob = nil
PlayerGrade = nil

local VehicleData = nil

RegisterNetEvent('flipcar-Ryder:Notify', function(message, type)
    if Config.UseCustomNotify then
        TriggerEvent('flipcar-Ryder:CustomNotify', message, type)
    elseif Config.UseESX then
        ESX.ShowNotification(message, false, false, type)
    end
end)

CreateThread(function()
    while ESX == nil do
        TriggerEvent('getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
    PlayerJob = PlayerData.job.name
    PlayerGrade = PlayerData.job.grade

    RegisterNetEvent('esx:setJob', function(job)
        PlayerJob = job.name
        PlayerGrade = job.grade
    end)

    if Config.UseChatCommand then
        RegisterCommand(Config.ChatCommand, function()
            TriggerEvent('flipcar-Ryder:flipcar')
        end)
    end
end)

function hasRequiredJob()
    local jobs = Config.Jobs == nil or next(Config.Jobs)
    if jobs then
        for jobName, gradeLevel in pairs(Config.Jobs) do
            if PlayerJob == jobName and PlayerGrade >= gradeLevel then
                return true
            end
        end
        return false
    else
        return true
    end
end

RegisterNetEvent('flipcar-Ryder:flipcar')
AddEventHandler('flipcar-Ryder:flipcar', function()
    local ped = PlayerPedId()
    local inside = IsPedInAnyVehicle(ped, false)
    local hasJob = hasRequiredJob()
    local hasItem = RequiredItem()
    if inside then
        TriggerEvent('flipcar-Ryder:Notify', Config.Lang['in_vehicle'], Config.LangType['error'])
    elseif Config.AndOr then
        if hasJob and hasItem then
            FlipCarOver()
        else
            TriggerEvent('flipcar-Ryder:Notify', Config.Lang['not_allowed'], Config.LangType['error'])
        end
    elseif hasJob or hasItem then
        FlipCarOver()
    else
        TriggerEvent('flipcar-Ryder:Notify', Config.Lang['not_allowed'], Config.LangType['error'])
    end
end)

CreateThread(function()
    if Config.UseThirdEye then
        exports[Config.ThirdEyeName]:Vehicle({
            options = {
                {
                    event = "flipcar-Ryder:flipcar",
                    icon = "fas fa-arrow-up",
                    label = "Flip Vehicle",
                    distance = 2
                },
            },
        })
    end
end)

function RequiredItem()
    local hasItem = false
    PlayerData = ESX.GetPlayerData()
    for k, v in ipairs(PlayerData.inventory) do
        if v.name == Config.RequiredItem and v.count > 0 then
            hasItem = true
            break
        end
    end
    return hasItem
end

function FlipCarOver()
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    VehicleData = ESX.Game.GetClosestVehicle()
    local dist = #(pedCoords - GetEntityCoords(VehicleData))
    if dist <= 3 and not IsVehicleOnAllWheels(VehicleData) then
        RequestAnimDict('missfinale_c2ig_11')
        while not HasAnimDictLoaded('missfinale_c2ig_11') do
            Wait(10)
        end
        TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
        Wait(Config.TimetoFlip * 1000)
        local carCoords = GetEntityRotation(VehicleData, 2)
        SetEntityRotation(VehicleData, carCoords[1], 0, carCoords[3], 2, true)
        SetVehicleOnGroundProperly(VehicleData)
        TriggerEvent('flipcar-Ryder:Notify', Config.Lang['flipped'], Config.LangType['success'])
        ClearPedTasks(ped)
    elseif IsVehicleOnAllWheels(VehicleData) then
        TriggerEvent('flipcar-Ryder:Notify', Config.Lang['allset'], Config.LangType['error'])
    end
end