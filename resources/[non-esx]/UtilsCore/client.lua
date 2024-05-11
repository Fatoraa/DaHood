
ESX	= nil



Citizen.CreateThread(function()

	while ESX == nil do

		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

		Citizen.Wait(0)

	end

end)


-- DESACTIVER LE CHANGEMENT DE PLACE AUTO



local disableShuffle = true

function disableSeatShuffle(flag)

	disableShuffle = flag

end



Citizen.CreateThread(function()

	while true do

		Citizen.Wait(0)

		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then

			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then

				if GetIsTaskActive(GetPlayerPed(-1), 165) then

					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)

				end

			end

		end

	end

end)



-- MONTER A L'ARRIERE DU VEHICULE



local doors = {

	{"seat_dside_f", -1},

	{"seat_pside_f", 0},

	{"seat_dside_r", 1},

	{"seat_pside_r", 2}

}



function VehicleInFront(ped)

    local pos = GetEntityCoords(ped)

    local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)

    local _, _, _, _, result = GetRaycastResult(rayHandle)

	

    return result

end



Citizen.CreateThread(function()

	while true do

    	Citizen.Wait(0)

			

		local ped = PlayerPedId()

			

   		if IsControlJustReleased(0, 23) and running ~= true and GetVehiclePedIsIn(ped, false) == 0 then

      		local vehicle = VehicleInFront(ped)

				

      		running = true

				

      		if vehicle ~= nil then

				local plyCoords = GetEntityCoords(ped, false)

        		local doorDistances = {}

					

        		for k, door in pairs(doors) do

          			local doorBone = GetEntityBoneIndexByName(vehicle, door[1])

          			local doorPos = GetWorldPositionOfEntityBone(vehicle, doorBone)

          			local distance = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, doorPos.x, doorPos.y, doorPos.z)

						

          			table.insert(doorDistances, distance)

        		end

					

        		local key, min = 1, doorDistances[1]

					

        		for k, v in ipairs(doorDistances) do

          			if doorDistances[k] < min then

           				key, min = k, v

          			end

        		end

					

        		TaskEnterVehicle(ped, vehicle, -1, doors[key][2], 1.5, 1, 0)

     		end

				

      		running = false

    	end

  	end

end)



-- KEYBIND CHANGEMENT PLACE VEHICLE

Citizen.CreateThread(function()

    while true do

        local plyPed = PlayerPedId()

        if IsPedSittingInAnyVehicle(plyPed) then

            local plyVehicle = GetVehiclePedIsIn(plyPed, false)

			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h

			if CarSpeed <= 40.0 then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 60 km/h

				if IsControlJustReleased(0, 157) then -- conducteur

					SetPedIntoVehicle(plyPed, plyVehicle, -1)

					Citizen.Wait(10)

				end

				if IsControlJustReleased(0, 158) then -- avant droit

					SetPedIntoVehicle(plyPed, plyVehicle, 0)

					Citizen.Wait(10)

				end

				if IsControlJustReleased(0, 160) then -- arriere gauche

					SetPedIntoVehicle(plyPed, plyVehicle, 1)

					Citizen.Wait(10)

				end

				if IsControlJustReleased(0, 164) then -- arriere gauche

					SetPedIntoVehicle(plyPed, plyVehicle, 2)

					Citizen.Wait(10)

				end

			end

		end

		Citizen.Wait(10) -- Fix Crash Client

	end

end)



-- REMOVE COPS PEDS



Citizen.CreateThread(function()

	while true do

	Citizen.Wait(0)

	local playerPed = GetPlayerPed(-1)

	local playerLocalisation = GetEntityCoords(playerPed)

	ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 400.0)

	end

	end)



-- NO DROP PNJ 



function SetWeaponDrops()

    local handle, ped = FindFirstPed()

    local finished = false



    repeat

        if not IsEntityDead(ped) then

            SetPedDropsWeaponsWhenDead(ped, false)

        end

        finished, ped = FindNextPed(handle)

    until not finished



    EndFindPed(handle)

end



Citizen.CreateThread(function()

    while true do

        SetWeaponDrops()

        Citizen.Wait(500)

    end

end)







-- ADD PVP



AddEventHandler("playerSpawned", function()

    NetworkSetFriendlyFireOption(true)

    SetCanAttackFriendly(PlayerPedId(), true, true)

end)





-- Disable dispatch & Weapon POLICE



Citizen.CreateThread(function()

	for i = 1, 12 do

		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)

	end

end)



Citizen.CreateThread(function()

    while true do

        Citizen.Wait(3000)

       

        if GetPlayerWantedLevel(PlayerId()) ~= 0 then

            SetPlayerWantedLevel(PlayerId(), 0, false)

            SetPlayerWantedLevelNow(PlayerId(), false)

        end

    end

end)



Citizen.CreateThread(function()

    while true do

        Citizen.Wait(0)

        local myCoords = GetEntityCoords(GetPlayerPed(-1))

        ClearAreaOfCops(myCoords.x, myCoords.y, myCoords.z, 100.0, 0)

    end

end)



Citizen.CreateThread(function()

    while true do

        Citizen.Wait(0)

        DisablePlayerVehicleRewards(PlayerId())

    end

end)



Citizen.CreateThread(function()

    while true

        do

            -- 1.

        SetVehicleDensityMultiplierThisFrame(0.4)

        SetPedDensityMultiplierThisFrame(0.7)

        SetRandomVehicleDensityMultiplierThisFrame(0.4)

        SetParkedVehicleDensityMultiplierThisFrame(0.4)

        SetScenarioPedDensityMultiplierThisFrame(0.3, 0.4)

       

        local playerPed = GetPlayerPed(-1)

        local pos = GetEntityCoords(playerPed)

        RemoveVehiclesFromGeneratorsInArea(pos['x'] - 900.0, pos['y'] - 900.0, pos['z'] - 900.0, pos['x'] + 900.0, pos['y'] + 900.0, pos['z'] + 900.0);

       

       

        -- 2.

        SetGarbageTrucks(0)

        SetRandomBoats(0)

     --   SetRandomBus(0)

        Citizen.Wait(1)

    end

 

end)

--------------- KNOCKOUT



local knockedOut = false

local wait = 15

local count = 60



Citizen.CreateThread(function()

	while true do

		Citizen.Wait(5)

		local myPed = GetPlayerPed(-1)

		if IsPedInMeleeCombat(myPed) then

			if GetEntityHealth(myPed) < 115 then

				SetPlayerInvincible(PlayerId(), true)

				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)

				ShowNotification("~r~Vous êtes KO!")

				wait = 15

				knockedOut = true

				SetEntityHealth(myPed, 116)

			end

		end

		if knockedOut == true then

			SetPlayerInvincible(PlayerId(), true)

			DisablePlayerFiring(PlayerId(), true)

			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)

			ResetPedRagdollTimer(myPed)

			

			if wait >= 0 then

				count = count - 1

				if count == 0 then

					count = 60

					wait = wait - 1

					SetEntityHealth(myPed, GetEntityHealth(myPed)+4)

				end

			else

				SetPlayerInvincible(PlayerId(), false)

				knockedOut = false

			end

		end

	end

end)



function ShowNotification(text)

	SetNotificationTextEntry("STRING")

	AddTextComponentString(text)

	DrawNotification(false, false)

end







---- COUP DE CROSSE OFF 



Citizen.CreateThread(function()

    while true do

        Citizen.Wait(0)

	local ped = PlayerPedId()

        if IsPedArmed(ped, 6) then

	   DisableControlAction(1, 140, true)

       	   DisableControlAction(1, 141, true)

           DisableControlAction(1, 142, true)

        end

    end

end)







---- ENLEVER VISEUR 





Citizen.CreateThread(function()

    local isSniper = false

    while true do

        Citizen.Wait(0)



        local ped = GetPlayerPed(-1)

        local currentWeaponHash = GetSelectedPedWeapon(ped)



        if currentWeaponHash == 100416529 then

            isSniper = true

        elseif currentWeaponHash == 205991906 then

            isSniper = true

        elseif currentWeaponHash == -952879014 then

            isSniper = true

        elseif currentWeaponHash == GetHashKey('WEAPON_HEAVYSNIPER_MK2') then

            isSniper = true

        else

            isSniper = false

        end



        if not isSniper then

            HideHudComponentThisFrame(14)

        end

    end

end)

	  --------------------- PAUSE MENU ------------------



function SetData()

	players = {}

	for _, player in ipairs(GetActivePlayers()) do

		local ped = GetPlayerPed(player)

		table.insert( players, player )

end



	

	local name = GetPlayerName(PlayerId())

	local id = GetPlayerServerId(PlayerId())

	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', "~r~Shiganshina~w~ RP~s~ | Discord : https://discord.gg/kaiitoo  ~g~~s~ | ID: "..id.." | ~r~".. #players .." connecté(e)s")

end



Citizen.CreateThread(function()

	while true do

		Citizen.Wait(100)

		SetData()

	end

end)



Citizen.CreateThread(function()

    AddTextEntry("PM_PANE_LEAVE", "~r~Se déconnecter de ~p~Shiganshina~w~ RP 😭")

end)



Citizen.CreateThread(function()

    AddTextEntry("PM_PANE_QUIT", "~r~Quitter ~o~FiveM🐌")

end)

---- UTILISER UNIQUEMENT cayo ----------------------

Citizen.CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(GetPlayerPed(-1))        
            local distance1 = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4840.571, -5174.425, 2.0, false)
            if distance1 < 2000.0 then
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- load the map and removes the city
            Citizen.InvokeNative("0x5E1460624D194A38", true) -- load the minimap/pause map and removes the city minimap/pause map
            else
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
            Citizen.InvokeNative("0x5E1460624D194A38", false)
            end
        Citizen.Wait(5000)
    end
end)

local requestedIpl = {
	"h4_mph4_terrain_01_grass_0",
	"h4_mph4_terrain_01_grass_1",
	"h4_mph4_terrain_02_grass_0",
	"h4_mph4_terrain_02_grass_1",
	"h4_mph4_terrain_02_grass_2",
	"h4_mph4_terrain_02_grass_3",
	"h4_mph4_terrain_04_grass_0",
	"h4_mph4_terrain_04_grass_1",
	"h4_mph4_terrain_05_grass_0",
	"h4_mph4_terrain_06_grass_0",
	"h4_islandx_terrain_01",
	"h4_islandx_terrain_01_lod",
	"h4_islandx_terrain_01_slod",
	"h4_islandx_terrain_02",
	"h4_islandx_terrain_02_lod",
	"h4_islandx_terrain_02_slod",
	"h4_islandx_terrain_03",
	"h4_islandx_terrain_03_lod",
	"h4_islandx_terrain_04",
	"h4_islandx_terrain_04_lod",
	"h4_islandx_terrain_04_slod",
	"h4_islandx_terrain_05",
	"h4_islandx_terrain_05_lod",
	"h4_islandx_terrain_05_slod",
	"h4_islandx_terrain_06",
	"h4_islandx_terrain_06_lod",
	"h4_islandx_terrain_06_slod",
	"h4_islandx_terrain_props_05_a",
	"h4_islandx_terrain_props_05_a_lod",
	"h4_islandx_terrain_props_05_b",
	"h4_islandx_terrain_props_05_b_lod",
	"h4_islandx_terrain_props_05_c",
	"h4_islandx_terrain_props_05_c_lod",
	"h4_islandx_terrain_props_05_d",
	"h4_islandx_terrain_props_05_d_lod",
	"h4_islandx_terrain_props_05_d_slod",
	"h4_islandx_terrain_props_05_e",
	"h4_islandx_terrain_props_05_e_lod",
	"h4_islandx_terrain_props_05_e_slod",
	"h4_islandx_terrain_props_05_f",
	"h4_islandx_terrain_props_05_f_lod",
	"h4_islandx_terrain_props_05_f_slod",
	"h4_islandx_terrain_props_06_a",
	"h4_islandx_terrain_props_06_a_lod",
	"h4_islandx_terrain_props_06_a_slod",
	"h4_islandx_terrain_props_06_b",
	"h4_islandx_terrain_props_06_b_lod",
	"h4_islandx_terrain_props_06_b_slod",
	"h4_islandx_terrain_props_06_c",
	"h4_islandx_terrain_props_06_c_lod",
	"h4_islandx_terrain_props_06_c_slod",
	"h4_mph4_terrain_01",
	"h4_mph4_terrain_01_long_0",
	"h4_mph4_terrain_02",
	"h4_mph4_terrain_03",
	"h4_mph4_terrain_04",
	"h4_mph4_terrain_05",
	"h4_mph4_terrain_06",
	"h4_mph4_terrain_06_strm_0",
	"h4_mph4_terrain_lod",
	"h4_mph4_terrain_occ_00",
	"h4_mph4_terrain_occ_01",
	"h4_mph4_terrain_occ_02",
	"h4_mph4_terrain_occ_03",
	"h4_mph4_terrain_occ_04",
	"h4_mph4_terrain_occ_05",
	"h4_mph4_terrain_occ_06",
	"h4_mph4_terrain_occ_07",
	"h4_mph4_terrain_occ_08",
	"h4_mph4_terrain_occ_09",
	"h4_boatblockers",
	"h4_islandx",
	"h4_islandx_disc_strandedshark",
	"h4_islandx_disc_strandedshark_lod",
	"h4_islandx_disc_strandedwhale",
	"h4_islandx_disc_strandedwhale_lod",
	"h4_islandx_props",
	"h4_islandx_props_lod",
	"h4_islandx_sea_mines",
	"h4_mph4_island",
	"h4_mph4_island_long_0",
	"h4_mph4_island_strm_0",
	"h4_aa_guns",
	"h4_aa_guns_lod",
	"h4_beach",
	"h4_beach_bar_props",
	"h4_beach_lod",
	"h4_beach_party",
	"h4_beach_party_lod",
	"h4_beach_props",
	"h4_beach_props_lod",
	"h4_beach_props_party",
	"h4_beach_props_slod",
	"h4_beach_slod",
	"h4_islandairstrip",
	"h4_islandairstrip_doorsclosed",
	"h4_islandairstrip_doorsclosed_lod",
	"h4_islandairstrip_doorsopen",
	"h4_islandairstrip_doorsopen_lod",
	"h4_islandairstrip_hangar_props",
	"h4_islandairstrip_hangar_props_lod",
	"h4_islandairstrip_hangar_props_slod",
	"h4_islandairstrip_lod",
	"h4_islandairstrip_props",
	"h4_islandairstrip_propsb",
	"h4_islandairstrip_propsb_lod",
	"h4_islandairstrip_propsb_slod",
	"h4_islandairstrip_props_lod",
	"h4_islandairstrip_props_slod",
	"h4_islandairstrip_slod",
	"h4_islandxcanal_props",
	"h4_islandxcanal_props_lod",
	"h4_islandxcanal_props_slod",
	"h4_islandxdock",
	"h4_islandxdock_lod",
	"h4_islandxdock_props",
	"h4_islandxdock_props_2",
	"h4_islandxdock_props_2_lod",
	"h4_islandxdock_props_2_slod",
	"h4_islandxdock_props_lod",
	"h4_islandxdock_props_slod",
	"h4_islandxdock_slod",
	"h4_islandxdock_water_hatch",
	"h4_islandxtower",
	"h4_islandxtower_lod",
	"h4_islandxtower_slod",
	"h4_islandxtower_veg",
	"h4_islandxtower_veg_lod",
	"h4_islandxtower_veg_slod",
	"h4_islandx_barrack_hatch",
	"h4_islandx_barrack_props",
	"h4_islandx_barrack_props_lod",
	"h4_islandx_barrack_props_slod",
	"h4_islandx_checkpoint",
	"h4_islandx_checkpoint_lod",
	"h4_islandx_checkpoint_props",
	"h4_islandx_checkpoint_props_lod",
	"h4_islandx_checkpoint_props_slod",
	"h4_islandx_maindock",
	"h4_islandx_maindock_lod",
	"h4_islandx_maindock_props",
	"h4_islandx_maindock_props_2",
	"h4_islandx_maindock_props_2_lod",
	"h4_islandx_maindock_props_2_slod",
	"h4_islandx_maindock_props_lod",
	"h4_islandx_maindock_props_slod",
	"h4_islandx_maindock_slod",
	"h4_islandx_mansion",
	"h4_islandx_mansion_b",
	"h4_islandx_mansion_b_lod",
	"h4_islandx_mansion_b_side_fence",
	"h4_islandx_mansion_b_slod",
	"h4_islandx_mansion_entrance_fence",
	"h4_islandx_mansion_guardfence",
	"h4_islandx_mansion_lights",
	"h4_islandx_mansion_lockup_01",
	"h4_islandx_mansion_lockup_01_lod",
	"h4_islandx_mansion_lockup_02",
	"h4_islandx_mansion_lockup_02_lod",
	"h4_islandx_mansion_lockup_03",
	"h4_islandx_mansion_lockup_03_lod",
	"h4_islandx_mansion_lod",
	"h4_islandx_mansion_office",
	"h4_islandx_mansion_office_lod",
	"h4_islandx_mansion_props",
	"h4_islandx_mansion_props_lod",
	"h4_islandx_mansion_props_slod",
	"h4_islandx_mansion_slod",
	"h4_islandx_mansion_vault",
	"h4_islandx_mansion_vault_lod",
	"h4_island_padlock_props",
	-- "h4_mansion_gate_broken",
	"h4_mansion_gate_closed",
	"h4_mansion_remains_cage",
	"h4_mph4_airstrip",
	"h4_mph4_airstrip_interior_0_airstrip_hanger",
	"h4_mph4_beach",
	"h4_mph4_dock",
	"h4_mph4_island_lod",
	"h4_mph4_island_ne_placement",
	"h4_mph4_island_nw_placement",
	"h4_mph4_island_se_placement",
	"h4_mph4_island_sw_placement",
	"h4_mph4_mansion",
	"h4_mph4_mansion_b",
	"h4_mph4_mansion_b_strm_0",
	"h4_mph4_mansion_strm_0",
	"h4_mph4_wtowers",
	"h4_ne_ipl_00",
	"h4_ne_ipl_00_lod",
	"h4_ne_ipl_00_slod",
	"h4_ne_ipl_01",
	"h4_ne_ipl_01_lod",
	"h4_ne_ipl_01_slod",
	"h4_ne_ipl_02",
	"h4_ne_ipl_02_lod",
	"h4_ne_ipl_02_slod",
	"h4_ne_ipl_03",
	"h4_ne_ipl_03_lod",
	"h4_ne_ipl_03_slod",
	"h4_ne_ipl_04",
	"h4_ne_ipl_04_lod",
	"h4_ne_ipl_04_slod",
	"h4_ne_ipl_05",
	"h4_ne_ipl_05_lod",
	"h4_ne_ipl_05_slod",
	"h4_ne_ipl_06",
	"h4_ne_ipl_06_lod",
	"h4_ne_ipl_06_slod",
	"h4_ne_ipl_07",
	"h4_ne_ipl_07_lod",
	"h4_ne_ipl_07_slod",
	"h4_ne_ipl_08",
	"h4_ne_ipl_08_lod",
	"h4_ne_ipl_08_slod",
	"h4_ne_ipl_09",
	"h4_ne_ipl_09_lod",
	"h4_ne_ipl_09_slod",
	"h4_nw_ipl_00",
	"h4_nw_ipl_00_lod",
	"h4_nw_ipl_00_slod",
	"h4_nw_ipl_01",
	"h4_nw_ipl_01_lod",
	"h4_nw_ipl_01_slod",
	"h4_nw_ipl_02",
	"h4_nw_ipl_02_lod",
	"h4_nw_ipl_02_slod",
	"h4_nw_ipl_03",
	"h4_nw_ipl_03_lod",
	"h4_nw_ipl_03_slod",
	"h4_nw_ipl_04",
	"h4_nw_ipl_04_lod",
	"h4_nw_ipl_04_slod",
	"h4_nw_ipl_05",
	"h4_nw_ipl_05_lod",
	"h4_nw_ipl_05_slod",
	"h4_nw_ipl_06",
	"h4_nw_ipl_06_lod",
	"h4_nw_ipl_06_slod",
	"h4_nw_ipl_07",
	"h4_nw_ipl_07_lod",
	"h4_nw_ipl_07_slod",
	"h4_nw_ipl_08",
	"h4_nw_ipl_08_lod",
	"h4_nw_ipl_08_slod",
	"h4_nw_ipl_09",
	"h4_nw_ipl_09_lod",
	"h4_nw_ipl_09_slod",
	"h4_se_ipl_00",
	"h4_se_ipl_00_lod",
	"h4_se_ipl_00_slod",
	"h4_se_ipl_01",
	"h4_se_ipl_01_lod",
	"h4_se_ipl_01_slod",
	"h4_se_ipl_02",
	"h4_se_ipl_02_lod",
	"h4_se_ipl_02_slod",
	"h4_se_ipl_03",
	"h4_se_ipl_03_lod",
	"h4_se_ipl_03_slod",
	"h4_se_ipl_04",
	"h4_se_ipl_04_lod",
	"h4_se_ipl_04_slod",
	"h4_se_ipl_05",
	"h4_se_ipl_05_lod",
	"h4_se_ipl_05_slod",
	"h4_se_ipl_06",
	"h4_se_ipl_06_lod",
	"h4_se_ipl_06_slod",
	"h4_se_ipl_07",
	"h4_se_ipl_07_lod",
	"h4_se_ipl_07_slod",
	"h4_se_ipl_08",
	"h4_se_ipl_08_lod",
	"h4_se_ipl_08_slod",
	"h4_se_ipl_09",
	"h4_se_ipl_09_lod",
	"h4_se_ipl_09_slod",
	"h4_sw_ipl_00",
	"h4_sw_ipl_00_lod",
	"h4_sw_ipl_00_slod",
	"h4_sw_ipl_01",
	"h4_sw_ipl_01_lod",
	"h4_sw_ipl_01_slod",
	"h4_sw_ipl_02",
	"h4_sw_ipl_02_lod",
	"h4_sw_ipl_02_slod",
	"h4_sw_ipl_03",
	"h4_sw_ipl_03_lod",
	"h4_sw_ipl_03_slod",
	"h4_sw_ipl_04",
	"h4_sw_ipl_04_lod",
	"h4_sw_ipl_04_slod",
	"h4_sw_ipl_05",
	"h4_sw_ipl_05_lod",
	"h4_sw_ipl_05_slod",
	"h4_sw_ipl_06",
	"h4_sw_ipl_06_lod",
	"h4_sw_ipl_06_slod",
	"h4_sw_ipl_07",
	"h4_sw_ipl_07_lod",
	"h4_sw_ipl_07_slod",
	"h4_sw_ipl_08",
	"h4_sw_ipl_08_lod",
	"h4_sw_ipl_08_slod",
	"h4_sw_ipl_09",
	"h4_sw_ipl_09_lod",
	"h4_sw_ipl_09_slod",
	"h4_underwater_gate_closed",
	"h4_islandx_placement_01",
	"h4_islandx_placement_02",
	"h4_islandx_placement_03",
	"h4_islandx_placement_04",
	"h4_islandx_placement_05",
	"h4_islandx_placement_06",
	"h4_islandx_placement_07",
	"h4_islandx_placement_08",
	"h4_islandx_placement_09",
	"h4_islandx_placement_10",
	"h4_mph4_island_placement"
	}
	
	
	
	CreateThread(function()
		for i = #requestedIpl, 1, -1 do
			RequestIpl(requestedIpl[i])
			requestedIpl[i] = nil
		end
	
		requestedIpl = nil
	end)
	
	CreateThread(function()
		while true do
			SetRadarAsExteriorThisFrame()
			SetRadarAsInteriorThisFrame('h4_fake_islandx', vec(4700.0, -5145.0), 0, 0)
			Wait(0)
		end
	end)
	
	CreateThread(function()
		SetDeepOceanScaler(0.0)
		local islandLoaded = false
		local islandCoords = vector3(4840.571, -5174.425, 2.0)
	
		while true do
			local pCoords = GetEntityCoords(PlayerPedId())
	
			if #(pCoords - islandCoords) < 2000.0 then
				if not islandLoaded then
					islandLoaded = true
					Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", 1)
					Citizen.InvokeNative(0xF74B1FFA4A15FBEA, 1) -- island path nodes (from Disquse)
					SetScenarioGroupEnabled('Heist_Island_Peds', 1)
					-- SetAudioFlag('PlayerOnDLCHeist4Island', 1)
					SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', 1, 1)
					SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', 0, 1)
				end
			else
				if islandLoaded then
					islandLoaded = false
					Citizen.InvokeNative(0x9A9D1BA639675CF1, "HeistIsland", 0)
					Citizen.InvokeNative(0xF74B1FFA4A15FBEA, 0)
					SetScenarioGroupEnabled('Heist_Island_Peds', 0)
					-- SetAudioFlag('PlayerOnDLCHeist4Island', 0)
					SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', 0, 0)
					SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', 1, 0)
				end
			end
	
			Wait(5000)
		end
	end)
	
	Citizen.CreateThread(function()
	  SetDeepOceanScaler(0.0)
	end)
