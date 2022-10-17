RegisterNetEvent('EngineToggle:Engine')
RegisterNetEvent('EngineToggle:RPDamage')

local vehicles = {}; RPWorking = true
local currentVehicle = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if UseKey and ToggleKey then
            if IsControlJustReleased(1, ToggleKey) then
                TriggerEvent('EngineToggle:Engine')
                Citizen.Wait(300)
            end
        end
        if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 and not table.contains(vehicles, GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))) then
            table.insert(vehicles, {GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)), IsVehicleEngineOn(GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)))})
        elseif IsPedInAnyVehicle(GetPlayerPed(-1), false) and not table.contains(vehicles, GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
            table.insert(vehicles, {GetVehiclePedIsIn(GetPlayerPed(-1), false), IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false))})
        end
        for i, vehicle in ipairs(vehicles) do
            if DoesEntityExist(vehicle[1]) then
                if (GetPedInVehicleSeat(vehicle[1], -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle[1], -1) then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                    local currentEngineHealth = GetVehicleEngineHealth(veh)
                    if currentEngineHealth > 50.0 then
                        if RPWorking then
                            SetVehicleEngineOn(vehicle[1], vehicle[2], false, true)
                            SetVehicleJetEngineOn(vehicle[1], vehicle[2])
                            if not IsPedInAnyVehicle(GetPlayerPed(-1), false) or (IsPedInAnyVehicle(GetPlayerPed(-1), false) and vehicle[1]~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                                if IsThisModelAHeli(GetEntityModel(vehicle[1])) or IsThisModelAPlane(GetEntityModel(vehicle[1])) then
                                    if vehicle[2] then
                                        SetHeliBladesFullSpeed(vehicle[1])
                                    end
                                end
                            end
                        end
                    end
                end
            else
                table.remove(vehicles, i)
            end
        end
    end
end)

AddEventHandler('EngineToggle:Engine', function()
    local veh
    local StateIndex
    for i, vehicle in ipairs(vehicles) do
        if vehicle[1] == GetVehiclePedIsIn(GetPlayerPed(-1), false) then
            veh = vehicle[1]
            StateIndex = i
        end
    end
    Citizen.Wait(0)
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then 
        if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
            vehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
            if vehicles[StateIndex][2] then
            else
            end
        end 
    end 
end)

AddEventHandler('EngineToggle:RPDamage', function(State)
    RPWorking = State
end)

if OnAtEnter then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 then
                for i, vehicle in ipairs(vehicles) do
                    if vehicle[1] == GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) and not vehicle[2] then
                        Citizen.Wait(0)
                        vehicle[2] = true
                    end
                end
            end
        end
    end)
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value[1] == element then
      return true
    end
  end
  return false
end