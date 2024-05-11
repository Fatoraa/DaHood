ESX = exports["es_extended"]:getSharedObject()


EwenXSerty.AdminList = {}
EwenXSerty.PlayersList = {}
EwenXSerty.ReportList = {}
EwenXSerty.inService = false

function Visual.Subtitle(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

EwenXSerty.Print = function(str) 
    print(EwenXSerty.Config.Print.DefaultPrefix.." "..str)
end

EwenXSerty.Debug = function(str) 
    print(EwenXSerty.Config.Print.DebugPrefix.." "..str)
end

local isNameShown = false
local gamerTags = {}
function showNames(bool)
    isNameShown = bool
    if isNameShown then
        CreateThread(function()
            while isNameShown do
                local plyPed = PlayerPedId()
                for _, player in pairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)
                    if ped ~= plyPed then
                        if #(GetEntityCoords(plyPed, false) - GetEntityCoords(ped, false)) < 5000.0 then
                            gamerTags[player] = CreateFakeMpGamerTag(ped, ('[%s] %s'):format(GetPlayerServerId(player), GetPlayerName(player)), false, false, '', 0)
                            SetMpGamerTagAlpha(gamerTags[player], 0, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 2, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 4, 255)
                            SetMpGamerTagAlpha(gamerTags[player], 7, 255)
                            SetMpGamerTagVisibility(gamerTags[player], 0, true)
                            SetMpGamerTagVisibility(gamerTags[player], 2, true)
                            SetMpGamerTagVisibility(gamerTags[player], 4, NetworkIsPlayerTalking(player))
                            SetMpGamerTagVisibility(gamerTags[player], 7, DecorExistOn(ped, "staffl") and DecorGetInt(ped, "staffl") > 0)
                            SetMpGamerTagColour(gamerTags[player], 7, 55)
                            if NetworkIsPlayerTalking(player) then
                                SetMpGamerTagHealthBarColour(gamerTags[player], 211)
                                SetMpGamerTagColour(gamerTags[player], 4, 211)
                                SetMpGamerTagColour(gamerTags[player], 0, 211)
                            else
                                SetMpGamerTagHealthBarColour(gamerTags[player], 0)
                                SetMpGamerTagColour(gamerTags[player], 4, 0)
                                SetMpGamerTagColour(gamerTags[player], 0, 0)
                            end
                            if DecorExistOn(ped, "staffl") then
                                SetMpGamerTagWantedLevel(ped, DecorGetInt(ped, "staffl"))
                            end
                            if mpDebugMode then
                                print(json.encode(DecorExistOn(ped, "staffl")).." - "..json.encode(DecorGetInt(ped, "staffl")))
                            end
                        else
                            RemoveMpGamerTag(gamerTags[player])
                            gamerTags[player] = nil
                        end
                    end
                end
              Wait(100)
            end
            for k,v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
            end
            gamerTags = {}
        end)
    end
end

EwenXSerty.KeyboardInput = function(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

EwenXSerty.PlayerMakrer = function(player)
    local ped = GetPlayerPed(player)
    local pos = GetEntityCoords(ped)
    DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

Citizen.CreateThread(function()
    Wait(5000)
    TriggerServerEvent("EwenXSerty:IEwenXSerty")
end)

RegisterNetEvent('EwenXSerty:GetReports')
AddEventHandler('EwenXSerty:GetReports', function(data)
    EwenXSerty.ReportList = data
end)

RegisterNetEvent('EwenXSerty:UpdateReportsList')
AddEventHandler('EwenXSerty:UpdateReportsList', function(newReportList)
    EwenXSerty.ReportList = newReportList
end)

RegisterNetEvent('EwenXSerty:UpdateNumberReport')
AddEventHandler('EwenXSerty:UpdateNumberReport', function(newReportsCount)
    EwenXSerty.AdminList[GetPlayerServerId(PlayerId())].reportEffectued = newReportsCount
end)

RegisterNetEvent('EwenXSerty:NewAdmin')
AddEventHandler('EwenXSerty:NewAdmin', function(data)
    EwenXSerty.AdminList[data.source] = data
end)

RegisterNetEvent('EwenXSerty:UpdateAdminGroup')
AddEventHandler('EwenXSerty:UpdateAdminGroup', function(_source, newGroupe)
    if EwenXSerty.AdminList[_source] then 
        EwenXSerty.AdminList[_source].grade = newGroupe
    end
end)

RegisterNetEvent('EwenXSerty:RemoveAdmin')
AddEventHandler('EwenXSerty:RemoveAdmin', function(adminId)
    EwenXSerty.AdminList[adminId] = nil
end)

RegisterNetEvent('EwenXSerty:UpdateAvis')
AddEventHandler('EwenXSerty:UpdateAvis', function(staffId, eval)
    EwenXSerty.AdminList[staffId].appreciation = eval
end)

RegisterNetEvent('EwenXSerty:GetPlayerList')
AddEventHandler('EwenXSerty:GetPlayerList', function(playerList)
    EwenXSerty.PlayersList = playerList
end)

RegisterNetEvent('EwenXSerty:NewPlayerList')
AddEventHandler('EwenXSerty:NewPlayerList', function(playerId, data)
    EwenXSerty.PlayersList[playerId] = data
end)

RegisterNetEvent('EwenXSerty:RemovePlayerList')
AddEventHandler('EwenXSerty:RemovePlayerList', function(playerId)
    EwenXSerty.PlayersList[playerId] = nil
end)


RegisterNetEvent("EwenXSerty:Tp")
AddEventHandler("EwenXSerty:Tp", function(coords, noClip)
    if noClip then 
        if not inNoclip then
            inNoclip = true
            ToogleNoClip()
        end
    end
    local pPed = PlayerPedId()
    SetEntityCoords(pPed, coords, false, false, false, false)
end)

RegisterNetEvent("EwenXSerty:TpParking")
AddEventHandler("EwenXSerty:TpParking", function()
    local pPed = PlayerPedId()
    SetEntityCoords(pPed, vector3(213.65, -809.03, 31.01), false, false, false, false)
end)

IsFrozen = false
RegisterNetEvent("EwenXSerty:FreezePlayer")
AddEventHandler("EwenXSerty:FreezePlayer", function()
    local pPed = PlayerPedId()
    if not IsFrozen then 
        FreezeEntityPosition(pPed, true)
        IsFrozen = true 
    elseif IsFrozen then 
        FreezeEntityPosition(pPed, false)
        IsFrozen = false
    end
end)

RegisterNetEvent("EwenXSerty:ShowInventory")
AddEventHandler("EwenXSerty:ShowInventory", function(inventory, account, weapons)
    Menu.PlayerInventory = inventory
    Menu.PlayerAccounts = account
    Menu.PlayersWeapons = weapons
end)

Citizen.CreateThread(function()
	while true do
        if showBlips then
            Wait(1)
            if showBlips then
                for k,v in pairs(EwenXSerty.PlayersList) do
                    local ped = GetPlayerPed(GetPlayerFromServerId(k))
                    local blip = GetBlipFromEntity( ped )
                    if not DoesBlipExist( blip ) then
                        blip = AddBlipForEntity(ped)
                        SetBlipCategory(blip, 7)
                        SetBlipScale( blip,  0.85 )
                        ShowHeadingIndicatorOnBlip(blip, true)
                        SetBlipSprite(blip, 1)
                        SetBlipColour(blip, 0)
                    end

                    SetBlipNameToPlayerName(blip, k)

                    local veh = GetVehiclePedIsIn(ped, false)
                    local blipSprite = GetBlipSprite(blip)

                    if IsEntityDead(ped) then
                        if blipSprite ~= 303 then
                            SetBlipSprite( blip, 303 )
                            SetBlipColour(blip, 1)
                            ShowHeadingIndicatorOnBlip( blip, false )
                        end
                    elseif veh ~= nil then
                        if IsPedInAnyBoat( ped ) then
                            if blipSprite ~= 427 then
                                SetBlipSprite( blip, 427 )
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip( blip, false )
                            end
                        elseif IsPedInAnyHeli( ped ) then
                            if blipSprite ~= 43 then
                                SetBlipSprite( blip, 43 )
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip( blip, false )
                            end
                        elseif IsPedInAnyPlane( ped ) then
                            if blipSprite ~= 423 then
                                SetBlipSprite( blip, 423 )
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip( blip, false )
                            end
                        elseif IsPedInAnyPoliceVehicle( ped ) then
                            if blipSprite ~= 137 then
                                SetBlipSprite( blip, 137 )
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip( blip, false )
                            end
                        elseif IsPedInAnySub( ped ) then
                            if blipSprite ~= 308 then
                                SetBlipSprite( blip, 308 )
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip( blip, false )
                            end
                        elseif IsPedInAnyVehicle( ped ) then
                            if blipSprite ~= 225 then
                                SetBlipSprite( blip, 225 )
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip( blip, false )
                            end
                        else
                            if blipSprite ~= 1 then
                                SetBlipSprite(blip, 1)
                                SetBlipColour(blip, 0)
                                ShowHeadingIndicatorOnBlip( blip, true )
                            end
                        end
                    else
                        if blipSprite ~= 1 then
                            SetBlipSprite( blip, 1 )
                            SetBlipColour(blip, 0)
                            ShowHeadingIndicatorOnBlip( blip, true )
                        end
                    end
                    if veh then
                        SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) )
                    else
                        SetBlipRotation( blip, math.ceil( GetEntityHeading( ped ) ) )
                    end
                end
            else
                for k,v in pairs(EwenXSerty.PlayersList) do
                    local blip = GetBlipFromEntity( GetPlayerPed(GetPlayerFromServerId(k)) )
                    if blip ~= nil then
                        RemoveBlip(blip)
                    end
                end
            end
        else 
            Wait(1000)
        end
	end
end)

function SizeOfPlayersList()
    local count = 0
    for k,v in pairs(EwenXSerty.PlayersList) do 
        count = count + 1
    end
    return count
end

Citizen.CreateThread(function()
    local alreadythread = false
	while true do
        Wait(1)
        if not EwenXSerty.inService and not PlayerInSpec and alreadythread and ESX.GetPlayerData()['group'] ~= "user" then
            alreadythread = false
            Wait(1000)
        elseif not PlayerInSpec and EwenXSerty.inService and not alreadythread and ESX.GetPlayerData()['group'] ~= "user" then
            alreadythread = true
            generateReportDisplay()
        else
            Wait(2000)
        end
	end
end)

function generateReportDisplay()
    local cVar1 = "~c~"
    local cVar2 = "/\\"
    Citizen.CreateThread(function()
        while EwenXSerty.inService and not PlayerInSpec do
            Wait(650)
            if cVar1 == "~s~" then cVar1 = "~c~" else cVar1 = "~s~" end
        end
    end)
    Citizen.CreateThread(function()
        while EwenXSerty.inService and not PlayerInSpec do
            Wait(450)
            if cVar2 == "/\\" then cVar2 = "\\/" else cVar2 = "/\\" end
        end
    end)
    Citizen.CreateThread(function()
        while EwenXSerty.inService and not PlayerInSpec do
            Wait(1)
            RageUI.Text({message = cVar1..cVar2.." ADMINISTRATION "..cVar1..cVar2.."\n~s~Report : ~c~"..SizeOfReport().."~s~ | Joueurs : ~c~"..SizeOfPlayersList().."~s~", time_display = 1})
        end
    end)
end

RegisterCommand("+noclip", function()
    local pPed = PlayerId()
    local pId = GetPlayerServerId(pPed)
    
    for k,v in pairs(EwenXSerty.AdminList) do 
        if k == pId then 
            if v.inService then 
                if inNoclip then
                    inNoclip = false
                    ToogleNoClip()
                    ESX.ShowNotification("~g~Administration~s~\nMode noclip désactivé")
                else 
                    inNoclip = true
                    ToogleNoClip()
                    ESX.ShowNotification("~g~Administration~s~\nMode noclip activé")
                end
            end
            return
        end
    end 
end, false)

RegisterKeyMapping("+noclip", "Noclip", 'keyboard', EwenXSerty.Config.KeyNoclip)

RegisterCommand("reload", function()
    TriggerServerEvent("EwenXSerty:IEwenXSerty")
end)