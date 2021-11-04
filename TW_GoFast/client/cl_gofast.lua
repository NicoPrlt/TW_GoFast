ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)
Citizen.CreateThread(function()
	while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(10)
  end
end)

PlayerData					= {}

local randomSpawnFin   = math.random(#Config.PointlivraisonFin)

local alpha = 255

local function sellVeh()
  local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
  SetEntityVisible(PlayerPedId(), false)
  SetVehicleDoorOpen(vehicle, 5, false, true)
  Citizen.CreateThread(function()
    while true do
      alpha = alpha - 1
      SetEntityAlpha(vehicle, alpha)
      Citizen.Wait(0)
     end
  end)
  Wait(1500)
  ESX.Game.DeleteVehicle(vehicle)
  SetEntityVisible(PlayerPedId(), true)
  TriggerServerEvent('T_GoFast:SellPackage')
  return
end

local function sellPackage(pos)
  Citizen.CreateThread(function()
    local interval = 250
    local way = AddBlipForCoord(pos)
    SetBlipColour(way, 75)
    SetBlipRoute(way, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Trajet du GoFast')
    EndTextCommandSetBlipName(way)
      while true do
        local plyPos = GetEntityCoords(PlayerPedId())
        local zone = pos
        local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
        local Dst = #(plyPos - zone)
        if Dst < 30 then
            interval = 0
            DrawMarker(21, pos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.5, 0.5, 0.2, 255, 255, 255, 120, false, false, false, 1) 
        end
        if Dst < 1 then
          if plate == "GO FAST " then
            RemoveBlip(way)
            ESX.ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour livrer ~y~le véhicule")
            if IsControlJustPressed(0,51) then
                sellVeh()
                break
            end
          else
            ESX.ShowNotification("~r~Vous êtes sortie du véhicule ou vous avez perdu le véhicule contenant la marchandise")
            RemoveBlip(way)
            return
          end
        end
        Citizen.Wait(interval)
      end
  end)
end

local function start(finpos)
  local model = GetHashKey("sultan")
  RequestModel(model)
  while not HasModelLoaded(model) do Citizen.Wait(10) end
  local vehicle = CreateVehicle(model, vector3(755.0101, -1873.225, 29.29156), 82.984802246094, true, true)
  local hash = GetHashKey("s_m_m_bouncer_01") 
  while not HasModelLoaded(hash) do 
      RequestModel(hash) Wait(20) 
  end 
  local blip = AddBlipForEntity(vehicle)
  SetBlipSprite(blip, 734)
  local ped = CreatePed("PED_TYPE_CIVMALE", "s_m_m_bouncer_01", vector3(756.1115, -1875.667, 29.29154), 6.418319702148, false, true) --sud
  SetVehicleNumberPlateText(vehicle, "GO FAST ")
  SetPedIntoVehicle(ped, vehicle, -1)
  Wait(30)
  TaskVehicleDriveToCoord(ped, vehicle, vector3(741.7476, -1840.909, 29.29158) , 8.0, 0, GetEntityModel(vehicle), 411, 10.0)
  ESX.ShowNotification("<C>~r~GoFast</C>\n~s~Le véhicule arrive patienter")
  Wait(7000)
  TaskLeaveAnyVehicle(ped, true, false)
  TaskGoToCoordAnyMeans(ped, vector3(759.0514, -1871.8, 29.29154), 1.0)
  Wait(4500)
  ESX.ShowNotification("<C>~r~GoFast</C>\n~s~Rendez vous au point de livraison")
  Citizen.SetTimeout(15000, function()
    DeletePed(ped)
  end)
  sellPackage(finpos)
  TriggerServerEvent("GoFast:MessagePolice")
end

function Pointgofast()
  local gofast = RageUI.CreateMenu("~r~Go Fast", "~r~Illegal")
  dansmenu = false
  gofast:SetRectangleBanner(0, 0, 0, 255)
  RageUI.Visible(gofast, not RageUI.Visible(gofast))
  while gofast do
    Citizen.Wait(0)
    RageUI.IsVisible(gofast, true, true, true, function()

      if dansmenu then
        FreezeEntityPosition(playerPed, true)
        RageUI.ButtonWithStyle("Commencer une mission", nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)     
          if (Selected) then
            RageUI.CloseAll()
          end
        end)
      else 
        RageUI.ButtonWithStyle("Commencer une mission", nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected) 
          if (Selected) then
            dansmenu = true
            local finpos = Config.PointlivraisonFin[randomSpawnFin]
            start(finpos)
            RageUI.CloseAll()
            cooldown = true
            Citizen.SetTimeout(50000,function()
              cooldown = false
            end)
          end 
        end)
      end
    end, function()
    end)
    if not RageUI.Visible(gofast) then
      gofast = RMenu:DeleteType("gofast", true)
    end
  end
end

local position = vector3(754.7889, -1857.39, 29.29155)

Citizen.CreateThread(function()
  local hash = GetHashKey("s_m_m_bouncer_01") 
  while not HasModelLoaded(hash) do 
      RequestModel(hash) Wait(20) 
  end 
  ped = CreatePed("PED_TYPE_CIVMALE", "s_m_m_bouncer_01", vector3(754.7889, -1857.39, 29.29155-0.98), 83.418319702148, false, true) --sud
  FreezeEntityPosition(ped, true)
  SetEntityInvincible(ped, true) 
  SetBlockingOfNonTemporaryEvents(ped, true)
  Citizen.Wait(200)
  TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING_POT", 0, 1) 

  while true do
    local wait = 750
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position)

    if dist <= 15.0 then
      wait = 0
    end

    if dist <= 1.0 and not (PlayerData.job ~= nil and PlayerData.job.name == 'police') and not (PlayerData.job ~= nil and PlayerData.job.name == 'bcso') and not (PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') then
      wait = 0
      ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour parler à Carlos")
      if IsControlJustPressed(1,51) then
        Pointgofast()
      end
    end
    Citizen.Wait(wait)
  end
end)
