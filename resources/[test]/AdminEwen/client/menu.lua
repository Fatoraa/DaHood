ESX = exports["es_extended"]:getSharedObject()


Menu = {
    GamerTags = {},
    PlayerSelected = nil,
    PlayerInventory = nil,
    PlayerAccounts = nil,
    PlayersWeapons = nil,
    ReportSelected = nil,
    List = {
        ClearZoneIndex = 1,
        ClearZoneItem = {Name = "10", Value = 10},
        TimeZoneIndex = 1,

        AppreciationIndex = 1,
        Item = {Name = "⭐️", Value = 1},

        GiveMoneyIndex = 1,
        GiveMoneyItem = {Name = "Liquide", Value = "money"},
    },
    ListStaff = {},
    ItemList = {}
}
PlayerInSpec = false
local selectedColor = 1
local cVarLongC = { "~c~", ""}
local cVar1, cVar2 = "~c~", ""
local function cVarLong()
    return cVarLongC[selectedColor]
end

EventActif = {}
EventTypeIndex = 1
TimeEvent = {}
IndexTimeEvent = 1

Citizen.CreateThread(function()
    for i = 1, 30 do
        table.insert(TimeEvent, i)
    end
end)



function getEventsActif()
    EventActif = {}
    ESX.TriggerServerCallback(Config_GtaCore.Prefix..':GetEventStarted', function(events)
        for k,v in pairs(events) do
            table.insert(EventActif,{name = v.name, down = v.down, type = v.type, time = v.time})
        end
    end)
end

RegisterNetEvent(Config_GtaCore.Prefix..":DeleteEvent")
AddEventHandler(Config_GtaCore.Prefix..":DeleteEvent", function()
    ESX.TriggerServerCallback(Config_GtaCore.Prefix..':GetEventStarted', function(events)
        for k,v in pairs(events) do
            TriggerServerEvent(Config_GtaCore.Prefix..":RemoveEvents", k)
            EventActif = {}
        end
    end)
end)

function SizeOfReport()
    local count = 0
    for k,v in pairs(EwenXSerty.ReportList) do 
        count = count + 1
    end
    return count
end

function ReportEnCours()
    local count = 0
    for k,v in pairs(EwenXSerty.ReportList) do 
        if v.Taken then 
            count = count + 1
        end
    end
    return count
end

local function MoyenneAppreciation(t)
    local a, b = 0, 0
    for k,v in pairs(t) do 
        a = a + 1
        b = b + v
    end
    return a > 0 and ESX.Math.Round(b/a, 2).."/5" or "Aucun avis"
end

local function CheckStateOfStaff(license)
    for k,v in pairs(EwenXSerty.AdminList) do 
        if v.license == license then 
            return "~g~En ligne"
        end
    end
    return "~r~Hors ligne"
end

local function OpenMenu(data)
    if ESX.GetPlayerData()['group'] == "user" and ESX.GetPlayerData()['group'] == nil then
        ESX.ShowNotification("~r~Vous n'avez pas accès à ce menu.")
        return
    end
    if EwenXSerty.Config.Debug then 
        EwenXSerty.Debug("Ouverture du menu")
    end
    local menu = RageUI.CreateMenu("", "Admin")
    local persoMenu = RageUI.CreateSubMenu(menu, "", "Interaction personnel")
    local vehMenu = RageUI.CreateSubMenu(menu, "", "Interaction véhicule")
    local joueurMenu = RageUI.CreateSubMenu(menu, "", "Interaction joueurs")
    local joueurActionMenu = RageUI.CreateSubMenu(joueurMenu, "Admin", "Actions sur le joueur")
    local serverMenu = RageUI.CreateSubMenu(menu, "", "Interaction serveur")
    local inventoryMenu = RageUI.CreateSubMenu(joueurActionMenu, "", "Inventaire du joueur")
    local inventoryMenu = RageUI.CreateSubMenu(joueurActionMenu, "", "Inventaire du joueur")
    local reportMenu = RageUI.CreateSubMenu(menu, "", "Liste des reports")
    local reportInfoMenu = RageUI.CreateSubMenu(reportMenu, "Admin", "Informations du report")
    local staffList = RageUI.CreateSubMenu(menu, "", "Liste des staffs")
    local staffAction = RageUI.CreateSubMenu(staffList, "", "Actions sur ce staff")
    local itemListe = RageUI.CreateSubMenu(joueurActionMenu, "", "Liste des items")
    local events = RageUI.CreateSubMenu(serverMenu, "", "Evenements")
    local menu_warn_joueurs_warn_historique = RageUI.CreateSubMenu(joueurActionMenu, "", "Historique Warn")
    local menu_warn_joueurs_warn = RageUI.CreateSubMenu(joueurActionMenu, "", "Historique Warn")

    
    RageUI.Visible(menu, not RageUI.Visible(menu))
    
    Citizen.CreateThread(function()
        while menu do
            Wait(800)
            if cVar1 == "" then
                cVar1 = "~c~"
            else
                cVar1 = ""
            end
            if cVar2 == "~c~" then
                cVar2 = ""
            else
                cVar2 = ""
            end
        end
    end)
    Citizen.CreateThread(function()
        while menu do
            Wait(250)
            selectedColor = selectedColor + 1
            if selectedColor > #cVarLongC then
                selectedColor = 1
            end
        end
    end)

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
            if data.inService then 
                state = "~c~Actif"
            else 
                state = "~c~Inactif"
            end
            RageUI.Line()
            RageUI.Separator("Grade : ~c~"..data.grade)
            RageUI.Separator("Appréciation : ~c~"..MoyenneAppreciation(data.appreciation))
            RageUI.Line()
            RageUI.Checkbox("∑ ~c~→ ~s~Service", nil, data.inService, {}, {
                onChecked = function()

                    RegisterNetEvent('prendreservicestaff')
                    AddEventHandler('prendreservicestaff', function()
                        adminservice = true
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            local uniformObject
                            if skin.sex == 0 then
                                uniformObject = EwenXSerty.staff.male
                            else
                                uniformObject = EwenXSerty.staff.female
                            end
                            if uniformObject then
                                TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
                            end
                        end)
                    end)
                    data.inService = true
                    EwenXSerty.inService = true
                    TriggerServerEvent("EwenXSerty:ChangeState", true)
                end,
                onUnChecked = function()
                    data.inService = false
                    EwenXSerty.inService = false
                    TriggerServerEvent("EwenXSerty:ChangeState", false)
                    if inNoclip then
                        inNoclip = false
                        ToogleNoClip()
                    end
                    if isNameShown then 
                        isNameShown = false
                        showNames()
                    end
                    if inInvisible then 
                        inInvisible = false
                        SetEntityInvincible(PlayerPedId(), false)
                        SetEntityVisible(PlayerPedId(), true, false)
                    end
                end,
            })
            RageUI.Line()

            
            RageUI.Button("∑ ~c~→ ~s~Liste des Reports (~c~" .. SizeOfReport() .. ")", nil, {RightLabel = "→→→"}, data.inService, {}, reportMenu)
            RageUI.Button("∑ ~c~→ ~s~Liste des Staffs", nil, {RightLabel = "→→→"}, data.inService and EwenXSerty.Config.Perms.AccesCat["show_staffList"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("EwenXSerty:GetStaffsList")
                end 
            }, staffList)
            RageUI.Button("∑ ~c~→ ~s~Liste des Joueurs", nil, {RightLabel = "→→→"}, data.inService and EwenXSerty.Config.Perms.AccesCat["interaction_players"][data.grade], {}, joueurMenu)
            RageUI.Button("∑ ~c~→ ~s~Gestion Personnage", nil, {RightLabel = "→→→"}, data.inService and EwenXSerty.Config.Perms.AccesCat["interaction_perso"][data.grade], {}, persoMenu)
            RageUI.Button("∑ ~c~→ ~s~Gestion Véhicules", nil, {RightLabel = "→→→"}, data.inService and EwenXSerty.Config.Perms.AccesCat["interaction_vehicle"][data.grade], {}, vehMenu)
             RageUI.Line()
            RageUI.Button("∑ ~c~→ ~s~Gestion du Serveur", nil, {RightLabel = "→→→"}, data.inService and EwenXSerty.Config.Perms.AccesCat["interaction_server"][data.grade], {}, serverMenu)
        
            
        end, function()
        end)
      


        RageUI.IsVisible(reportMenu, function()
            
            RageUI.Separator("Il y'a ~c~"..SizeOfReport().." report(s) dont ~c~"..ReportEnCours().." en cours")
            RageUI.Separator("Vous avez effectué ~r~"..EwenXSerty.AdminList[GetPlayerServerId(PlayerId())].reportEffectued .." reports.")

            for k,v in pairs(EwenXSerty.ReportList) do 
                if not v.Taken then
                    RageUI.Button("[~c~"..k.."] - "..v.Name, "~c~Raison : "..v.Raison.."\n~c~Heure : "..v.Date, {RightLabel = "[~r~EN ATTENTE] - ~c~Prendre →→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent("EwenXSerty:UpdateReport", k)
                            Menu.ReportSelected = v
                        end
                    }, reportInfoMenu)
                else 
                    RageUI.Button("[~c~"..k.."] - "..v.Name, "~c~Raison : "..v.Raison.."\n~c~Heure : "..v.Date.."\n~c~Pris par : "..v.TakenBy, {RightLabel = "[~g~EN COURS]"}, true, {
                        onSelected = function()
                            Menu.ReportSelected = v
                        end
                    }, reportInfoMenu)
                end
            end
         
        end, function()
        end)

        RageUI.IsVisible(reportInfoMenu, function()
            
            while Menu.ReportSelected == nil do Wait(1) end
 
            RageUI.Button("Nom du joueur :", nil, {RightLabel = "~c~"..Menu.ReportSelected.Name}, true, {})
            RageUI.Button("Raison du report :", Menu.ReportSelected.Raison, {}, true, {})
            RageUI.Button("Heure du report :", nil, {RightLabel = "~c~"..Menu.ReportSelected.Date}, true, {})
            if not Menu.ReportSelected.TakenBy then
                RageUI.Button("Status :", nil, {RightLabel = "~c~Pris par vous"}, true, {})
            else 
                RageUI.Button("Status :", nil, {RightLabel = "~c~Pris par "..Menu.ReportSelected.TakenBy}, true, {})
            end
            RageUI.Button("∑ ~c~→ ~s~Gestion du Joueur", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    Menu.PlayerSelected = {ped = GetPlayerPed(Menu.ReportSelected.Source), id = Menu.ReportSelected.Source}
                end
            }, joueurActionMenu)
            RageUI.Button("∑ ~c~→ ~s~Cloturer ce report", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    TriggerServerEvent("EwenXSerty:ClotureReport", Menu.ReportSelected.Source)
                    RageUI.GoBack()
                end
            })
         
        end, function()
        end)

        RageUI.IsVisible(persoMenu, function()
            if EwenXSerty.Config.Perms.Buttons["cat_persoMenu"]["noclip"][data.grade] then
                RageUI.Checkbox('∑ ~c~→ ~s~Mode noclip', nil, inNoclip, {}, {
                    onChecked = function()
                        inNoclip = true
                        ToogleNoClip()
                        ESX.ShowNotification("~g~Administration\nMode noclip activé")
                    end,
                    onUnChecked = function()
                        inNoclip = false
                        ToogleNoClip()
                        ESX.ShowNotification("~g~Administration\nMode noclip désactivé")
                    end,
                })
            end
            if EwenXSerty.Config.Perms.Buttons["cat_persoMenu"]["invisibleMonde"][data.grade] then 
                RageUI.Checkbox('∑ ~c~→ ~s~Mode invisible', nil, inInvisible, {}, {
                    onChecked = function()
                        inInvisible = true
                        SetEntityInvincible(PlayerPedId(), true)
                        SetEntityVisible(PlayerPedId(), false, false)
                        SetEntityNoCollisionEntity(PlayerPedId(), entity2, false)
                        ESX.ShowNotification("~g~Administration\nMode invisible activé")
                    end,
                    onUnChecked = function()
                        inInvisible = false
                        SetEntityInvincible(PlayerPedId(), false)
                        SetEntityVisible(PlayerPedId(), true, false)
                        ESX.ShowNotification("~g~Administration\nMode invisible désactivé")
                    end,
                })
            end
            if EwenXSerty.Config.Perms.Buttons["cat_persoMenu"]["show_gamertags"][data.grade] then
                RageUI.Checkbox('∑ ~c~→ ~s~Affichez les noms', nil, isNameShown, {}, {
                    onChecked = function()
                        isNameShown = true
                        showNames(true)
                        ESX.ShowNotification("~g~Administration\nVous avez affiché les noms")
                    end,
                    onUnChecked = function()
                        isNameShown = false
                        showNames(false)
                        ESX.ShowNotification("~g~Administration\nVous avez masqué les noms")
                    end,
                })
            end
            if EwenXSerty.Config.Perms.Buttons["cat_persoMenu"]["shop_playerBlips"][data.grade] then
                RageUI.Checkbox('∑ ~c~→ ~s~Affichez les blips', nil, showBlips, {}, {
                    onChecked = function()
                        showBlips = true
                        ESX.ShowNotification("~g~Administration\nVous avez affiché les blips")
                    end,
                    onUnChecked = function()
                        showBlips = false
                        ESX.ShowNotification("~g~Administration\nVous avez masqué les blips")
                    end,
                })
            end
            RageUI.Button('∑ ~c~→ ~s~Se téléporter sur marqueur', nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_persoMenu"]["teleport_waypoint"][data.grade], {
                onSelected = function() 
                    local pPed = PlayerPedId()
                    local WaypointHandle = GetFirstBlipInfoId(8)
                    if DoesBlipExist(WaypointHandle) then
                        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
                        SetEntityCoordsNoOffset(pPed, coord.x, coord.y, -199.5, false, false, false, true)
                        ESX.ShowNotification("~g~Administration\nTéléporté au marqueur avec succés")
                    else
                        ESX.ShowNotification("~g~Administration\nIl n'y a pas de marqueur sur ta map")
                    end
                end
            })
            
        end, function()
        end)

        RageUI.IsVisible(vehMenu, function()

            local pPed = PlayerPedId()
            local pVeh = GetVehiclePedIsUsing(pPed)
            RageUI.Button("∑ ~c~→ ~s~Ce give un véhicule", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_vehMenu"]["giveVehicle"][data.grade], {
                onSelected = function()
                    local model = EwenXSerty.KeyboardInput('Model du vehicule', 'Model du vehicule', '', 20)
                    ExecuteCommand("car "..model)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Réparé le véhicule", nil, {RightLabel = "→→→"}, pVeh ~= 0 and EwenXSerty.Config.Perms.Buttons["cat_vehMenu"]["repairVehicle"][data.grade], {
                onSelected = function()
                    SetVehicleFixed(pVeh)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Nettoyer le véhicule", nil, {RightLabel = "→→→"}, pVeh ~= 0 and EwenXSerty.Config.Perms.Buttons["cat_vehMenu"]["clearVehicle"][data.grade], {
                onSelected = function()
                    SetVehicleDirtLevel(pVeh, 0.0)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Changer la plaque", nil, {RightLabel = "→→→"}, pVeh ~= 0 and EwenXSerty.Config.Perms.Buttons["cat_vehMenu"]["changePlate"][data.grade], {
                onSelected = function()
                    local plate = EwenXSerty.KeyboardInput('', 'Nouvelle plaque :', '', 8)
                    SetVehicleNumberPlateText(pVeh, plate)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Supprimer le véhicule", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_vehMenu"]["dv"][data.grade], {
                onActive = function()
                    local pos = GetEntityCoords(PlayerPedId())
                    local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                    local vPos = GetEntityCoords(veh)
                    if dst <= 6 then
                        DrawMarker(2, vPos.x, vPos.y, vPos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                    end
                end,
                onSelected = function()
                    local pos = GetEntityCoords(PlayerPedId())
                    local veh, dst = ESX.Game.GetClosestVehicle({x = pos.x, y = pos.y, z = pos.z})
                    local vPos = GetEntityCoords(veh)
                    if dst <= 6 then
                        DeleteEntity(veh)
                    else 
                        ESX.ShowNotification("~g~Administration\nIl n'y a pas de véhicule à distance")
                    end
                end
            })
            
        end, function()
        end)

        RageUI.IsVisible(joueurMenu, function()
            for k,v in pairs(EwenXSerty.PlayersList) do 
                RageUI.Button("["..k.."] "..v.name, "~r~Heure de connexion : "..v.hoursLogin, {RightLabel = "→→→"}, true, {
                    onActive = function()
                        EwenXSerty.PlayerMakrer(GetPlayerPed(k))
                    end,
                    onSelected = function()
                        Menu.PlayerSelected = {ped = GetPlayerPed(k), id = k}
                    end
                }, joueurActionMenu)
            end
        end, function()
        end)

        RageUI.IsVisible(joueurActionMenu, function()

            RageUI.Button("∑ ~c~→ ~s~Ouvrir menu Warn", nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                   RageUI.CloseAll()
                    ExecuteCommand("warns")
                end 
            })

            RageUI.Button("∑ ~c~→ ~s~Avertir le joueur", nil, {RightLabel = "→→"}, true, {
                onSelected = function()
                    local raison = EwenXSerty.KeyboardInput('Raison :', 'Raison :', '', 100)

                    if raison == "" then
                        ESX.showNotification("[~r~Erreur~s~] Impossible de mettre un avertissement sans entrer de raison.")
                    else
                        if raison ~= nil then
                            TriggerServerEvent("EwenXSerty:WarnPlayer", Menu.PlayerSelected.id, raison)
                        end
                    end
                end
            })
            
            RageUI.Button("∑ ~c~→ ~s~TP sur le Joueur", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["goto"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("EwenXSerty:Goto", Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~TP le Joueur sur Moi", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["bring"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("EwenXSerty:Bring", Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~TP le joueur au PC", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["tpparkingcentral"][data.grade], {
               onSelected = function()
                   TriggerServerEvent("EwenXSerty:TpParking", Menu.PlayerSelected.id)
               end
            })
            RageUI.Button("∑ ~c~→ ~s~Spectate le joueur", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["spec"][data.grade], {
                onSelected = function()
                    if Menu.PlayerSelected.id == PlayerPedId() then 
                        ESX.ShowNotification("Tu peux pas te spec toi même !")
                    else
                        Admin:StartSpectate({
                            id = Menu.PlayerSelected.id,
                            ped = GetPlayerPed(GetPlayerFromServerId(Menu.PlayerSelected.id))
                        })
                    end
                end
            })

            RageUI.Button("∑ ~c~→ ~s~Freeze le joueur", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["freeze"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("EwenXSerty:Freeze", Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Envoyer un message", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["sendMess"][data.grade], {
                onSelected = function()
                    local message = EwenXSerty.KeyboardInput('Message :', 'Message :', '', 100)
                    if message then
                        TriggerServerEvent("EwenXSerty:SendMessage", Menu.PlayerSelected.id, tostring(message))
                    else 
                        ESX.ShowNotification("~g~Administration\nMessage invalide")
                    end
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Réanimer le joueur", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["revive"][data.grade], {
                onSelected = function()
                    ExecuteCommand("revive "..Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Kick le joueur", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["kick"][data.grade], {
                onSelected = function()
                    local reason = EwenXSerty.KeyboardInput('Raison :', 'Raison :', '', 100)
                    if reason then
                        TriggerServerEvent("EwenXSerty:Kick", Menu.PlayerSelected.id, tostring(reason))
                        RageUI.CloseAll()
                    else 
                        ESX.ShowNotification("~g~Administration\nMessage invalide")
                    end
                end
                
            })

            RageUI.Button("∑ ~c~→ ~s~Wipe le joueur", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["wipe"][data.grade], {
                onSelected = function()
                    ESX.ShowNotification("Wipe du joueur en cours...")
                    TriggerServerEvent("EwenXSerty:wipe", Menu.PlayerSelected.id)
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Ban le joueur", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["ban"][data.grade], {
                onSelected = function()
                    local raisonn = EwenXSerty.KeyboardInput('Montant', 'Montant', '', 10)
                    if raisonn then
                        TriggerEvent('player:anticheat:BanPlayer', Menu.PlayerSelected.id, tonumber(raisonn))
                    else
                        ESX.ShowNotification("~r~Erreur\nLe montant est incorrect")
                    end
                end
            })

            RageUI.Button("∑ ~c~→ ~s~Voir l'inventaire", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["showInventory"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("EwenXSerty:ShowInventory", Menu.PlayerSelected.id)
                end
            }, inventoryMenu)
            RageUI.List('∑ ~c~→ ~s~Give de l\'argent', {
                { Name = "Liquide", Value = "money" }, 
                { Name = "Banque", Value = "bank" },
                { Name = "Argent sale", Value = "black_money" }
            }, Menu.List.GiveMoneyIndex, nil, {}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["giveMoney"][data.grade], {
                onListChange = function(Index, Item)
                    Menu.List.GiveMoneyIndex = Index;
                    Menu.List.GiveMoneyItem = Item
                end,
                onSelected = function()
                    local amount = EwenXSerty.KeyboardInput('Montant', 'Montant', '', 10)
                    if amount then
                        TriggerServerEvent("EwenXSerty:GiveMoney", Menu.PlayerSelected.id, Menu.List.GiveMoneyItem.Value, tonumber(amount))
                    else
                        ESX.ShowNotification("~r~Erreur\nLe montant est incorrect")
                    end
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Give un item", nil, {RightLabel = "→→→"}, EwenXSerty.Config.Perms.Buttons["cat_playersActions"]["giveItem"][data.grade], {
                onSelected = function()
                    TriggerServerEvent("EwenXSerty:GetItemList")
                end
            }, itemListe)
        end, function()
        end)

        RageUI.IsVisible(serverMenu, function()
            RageUI.Button(cVarLong() .. "→ ~s~Créer un événement(s)", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {
                onSelected = function()
                    getEventsActif()
                end
            }, events)
        
                      RageUI.Button('• Créé Yacht', nil, {RightLabel = "~c~→→"}, true, {
                onSelected = function()
                    RageUI.CloseAll()
                    ExecuteCommand("yachtbuilder")
                end
            })
        
              RageUI.Button('• Nettoyé Map ~r~(vehicules)', nil, {RightLabel = "~c~→→"}, true, {
                onSelected = function()
                    RageUI.CloseAll()
                    ExecuteCommand("clearmap")
                end
            })
                                RageUI.Button('• Faire une Annonce', nil, {RightLabel = "~c~→→"}, true, {
                onSelected = function()
                    RageUI.CloseAll()
                    ExecuteCommand("annonce")
                end
            })
        
                                        RageUI.Button('• Gestion Meteo', nil, {RightLabel = "~c~→→"}, true, {
                onSelected = function()
                    RageUI.CloseAll()
                    ExecuteCommand("meteo")
                end
            })

        end, function()
        end)

        RageUI.IsVisible(events, function()
            if #EventActif== 0 then
                RageUI.Separator("")
                RageUI.Separator("~p~Aucun évenénement est en cours :(")
                RageUI.Separator("")
            end
            for a,b in pairs(EventActif) do
                RageUI.Separator('↓ ~p~Un évenénement est en cours~s~ ! ↓')
                RageUI.Separator("Type d'événement : ~p~"..b.type)
                RageUI.Separator("Évenénement lancer par : ~p~"..b.name)
                for i,v in pairs(activeBars) do
                    local remainingTime = math.floor(v.endTime - GetGameTimer())
                    RageUI.Separator("Temps restant(s) : ~p~"..SecondsToClock(remainingTime / 1000))
                end
            end
            

            RageUI.List("Définir le type de l'événement", {"Caisse", "Brinks", "Drogue"}, EventTypeIndex, nil, {}, true, {
                onListChange = function(Index, Items)
                    EventTypeIndex = Index
                end
            })
            if EventTypeIndex == 1 then
                RageUI.List("Définir le temps en minute(s) :", TimeEvent, IndexTimeEvent, nil, {}, #EventActif == 0, {
                    onListChange = function(Index, Items)
                        IndexTimeEvent = Index
                    end
                })
                RageUI.Button("Commencer l'évenénement", nil, {RightLabel = "→→"}, #EventActif == 0, {
                    onSelected = function()
                        TriggerServerEvent(Config_GtaCore.Prefix..":StartEventsStaff", "Caisse mystère", IndexTimeEvent)
                        TriggerServerEvent(Config_GtaCore.Prefix..":StartsEvents", "CAISSE", IndexTimeEvent)
                        getEventsActif()
                    end
                })
            elseif EventTypeIndex == 2 then
                RageUI.List("Définir le temps en minute(s) :", TimeEvent, IndexTimeEvent, nil, {}, #EventActif == 0, {
                    onListChange = function(Index, Items)
                        IndexTimeEvent = Index
                    end
                })
                RageUI.Button("Commencer l'évenénement", nil, {RightLabel = "→→"}, #EventActif == 0, {
                    onSelected = function()
                        TriggerServerEvent(Config_GtaCore.Prefix..":StartEventsStaff", "Brinks", IndexTimeEvent)
                        TriggerServerEvent(Config_GtaCore.Prefix..":StartsEvents", "BRINKS", IndexTimeEvent)
                        getEventsActif()
                    end
                })
            elseif EventTypeIndex == 3 then
                RageUI.List("Définir le temps en minute(s) :", TimeEvent, IndexTimeEvent, nil, {}, #EventActif == 0, {
                    onListChange = function(Index, Items)
                        IndexTimeEvent = Index
                    end
                })
                RageUI.Button("Commencer l'évenénement", nil, {RightLabel = "→→"}, #EventActif == 0, {
                    onSelected = function()
                        TriggerServerEvent(Config_GtaCore.Prefix..":StartEventsStaff", "Drogue", IndexTimeEvent)
                        TriggerServerEvent(Config_GtaCore.Prefix..":StartsEvents", "DRUGS", IndexTimeEvent)
                        getEventsActif()
                    end
                })
            end
        end)

        RageUI.IsVisible(inventoryMenu, function()
           
            if Menu.PlayerInventory == nil and Menu.PlayerAccounts == nil and Menu.PlayersWeapons == nil then 
                RageUI.Separator("")
                RageUI.Separator("~r~En attente")
                RageUI.Separator("")
            else 
                RageUI.Line()
                for k,v in pairs(Menu.PlayerAccounts) do
                    RageUI.Button(v.label, nil, {RightLabel = v.money.."$"}, true, {})
                end
                RageUI.Line()
                for k,v in pairs(Menu.PlayerInventory) do 
                    if v.count > 0 then
                        RageUI.Button("x"..v.count.." "..v.label, nil, {}, true, {})
                    end
                end
                RageUI.Line()
                for k,v in pairs(Menu.PlayersWeapons) do 
                    RageUI.Button(v, nil, {}, true, {})
                end
            end

        end, function()
        end)

        RageUI.IsVisible(staffList, function()
        
            for k,v in pairs(Menu.ListStaff) do 
                RageUI.Button(v.name, "~r~Avis :  "..MoyenneAppreciation(json.decode(v.evaluation)).."\n~r~Nombre de report fais :  "..v.report, {RightLabel = CheckStateOfStaff(v.license).." →→→"}, true, {
                    onSelected = function()
                        Menu.PlayerSelected = v
                    end
                }, staffAction)
            end
         
        end, function()
        end)

        RageUI.IsVisible(staffAction, function()
        
            RageUI.Button("∑ ~c~→ ~s~Clear ses reports", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    ExecuteCommand("clearreport "..Menu.PlayerSelected.license)
                    RageUI.CloseAll()
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Clear ses avis", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    ExecuteCommand("clearavis "..Menu.PlayerSelected.license)
                    RageUI.CloseAll()
                end
            })
            RageUI.Button("∑ ~c~→ ~s~Retirer staff", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    ExecuteCommand("deletstaff "..Menu.PlayerSelected.license)
                    RageUI.CloseAll()
                end
            })
         
        end, function()
        end)

        RageUI.IsVisible(itemListe, function()
        
            for id, itemInfos in pairs(Menu.ItemList) do
                RageUI.Button(itemInfos.label.." - ~c~"..itemInfos.name, nil, {RightLabel = "→→→"}, true, {
                    onSelected = function()
                        local amount = EwenXSerty.KeyboardInput('Montant', 'Montant', '', 10)
                        if amount then
                            TriggerServerEvent("EwenXSerty:GiveItem", Menu.PlayerSelected.id, itemInfos.name, tonumber(amount))
                        else
                            ESX.ShowNotification("~r~Erreur\nLe montant est incorrect")
                        end
                        RageUI.GoBack()
                    end
                })
            end
         
        end, function()
        end)

        if not RageUI.Visible(menu) and not RageUI.Visible(persoMenu) and not RageUI.Visible(vehMenu) and not RageUI.Visible(joueurMenu) 
        and not RageUI.Visible(joueurActionMenu) and not RageUI.Visible(serverMenu) and not RageUI.Visible(inventoryMenu) and not RageUI.Visible(reportMenu) 
        and not RageUI.Visible(reportInfoMenu) and not RageUI.Visible(staffList) and not RageUI.Visible(staffAction) and not RageUI.Visible(itemListe) and not RageUI.Visible(events) then
            menu = RMenu:DeleteType('menu', true)
            persoMenu = RMenu:DeleteType('persoMenu', true)
            vehMenu = RMenu:DeleteType('vehMenu', true)
            joueurMenu = RMenu:DeleteType('joueurMenu', true)
            joueurActionMenu = RMenu:DeleteType('joueurActionMenu', true)
            serverMenu = RMenu:DeleteType('serverMenu', true)
            events = RMenu:DeleteType('serverMenu', true)
            inventoryMenu = RMenu:DeleteType('inventoryMenu', true)
            reportMenu = RMenu:DeleteType('reportMenu', true)
            reportMenu = RMenu:DeleteType('reportMenu', true)
            reportInfoMenu = RMenu:DeleteType('reportInfoMenu', true)
            staffList = RMenu:DeleteType('staffList', true)
            staffAction = RMenu:DeleteType('staffAction', true)
            itemListe = RMenu:DeleteType('itemListe', true)
 
            Menu.PlayerSelected = nil 
            Menu.PlayerInventory = nil
            Menu.PlayerAccounts = nil
            Menu.PlayersWeapons = nil
        end
    end
end

--------------------------------------------------------------------------------------------------
-- Script par Desperados#0001                                                                   -- 
-- Lien du discord pour toute mes créations: https://discord.gg/dkHFBkBBPZ                      --
-- Lien du github pour télécharger le script: https://github.com/Desperados-Creation/dpr_Meteo  --
--------------------------------------------------------------------------------------------------
-- Menu --
local open = false
local MenuMeteo = RageUI.CreateMenu("Météo", "INTERACTION")
local MenuHeureMeteo = RageUI.CreateSubMenu(MenuMeteo, "Heure", "INTERACTION")
local MenuTempsMeteo = RageUI.CreateSubMenu(MenuMeteo, "Temps", "INTERACTION")
MenuMeteo.Display.Header = true
MenuMeteo.Closed = function()
    open = false
end

function OpenMenuMeteo() 
    if open then 
        open = false
        RageUI.Visible(MenuMeteo, false)
        return
    else
        open = true
        RageUI.Visible(MenuMeteo, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuMeteo, function()
                    RageUI.Separator("↓     ~g~Temps / Heures     ~s~↓")
                    RageUI.Button("Temps", "Gestion du Temps", {RightLabel = "~y~→→→"}, true, {}, MenuTempsMeteo)
                    RageUI.Button("Heure", "Gestion de l'heure", {RightLabel = "~y~→→→"}, true, {}, MenuHeureMeteo)

                    RageUI.Separator("↓     ~g~Freeze     ~s~↓")
                    RageUI.Button("Freeze Temps", "Block la météo sur laquel elle est définie !", {RightLabel = "~y~→"}, true, {
                        onSelected = function()
                            ExecuteCommand('freezeweather')
                        end
                    })
                    RageUI.Button("Freeze Heure", "Block le sur lequel il est défini !", {RightLabel = "~y~→"}, true, {
                        onSelected = function()
                            ExecuteCommand('freezetime')
                        end
                    })

                    RageUI.Separator("↓     ~c~Blackout     ~s~↓")
                    RageUI.Button("Blackout", "Éteindre les lumières de la ville", {RightLabel = "~g~ON~s~/~r~OFF"}, true, {
                        onSelected = function()
                            ExecuteCommand('blackout')
                        end
                    })

                    RageUI.Separator("↓     ~r~Fermeture     ~s~↓")
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                        end
                    })
                end)

                RageUI.IsVisible(MenuTempsMeteo, function()
    
                    RageUI.Separator("↓     ~g~Raccourci     ~s~↓")
                    RageUI.Button("Normal", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather neutral') end})
                    RageUI.Button("Ensoleillé", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather extrasunny') end})
                    RageUI.Button("Dégager", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather clear') end})
                    RageUI.Button("Nuageux", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather clouds') end})
                    RageUI.Button("Brouillard", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather smog') end})
                    RageUI.Button("Pluie", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather rain') end})
                    RageUI.Button("Nuageux + Brouillard", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather foggy') end})
                    RageUI.Button("Nuageux + Vent", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather overcast') end})
                    RageUI.Button("Nuageux + Pluie", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather clearing') end})
                    RageUI.Button("Nuageux + Vent + Pluie", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather thunder') end})
                    RageUI.Button("Faible Neige", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather snowlight') end})
                    RageUI.Button("Neige", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather snow') end})
                    RageUI.Button("Enneiger", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather xmas') end})
                    RageUI.Button("Tempête", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather blizzard') end})
                    RageUI.Button("Halloween", nil, {RightLabel = "~y~→"}, true, {onSelected = function() ExecuteCommand('weather halloween') end})

                    RageUI.Separator("↓     ~r~Fermeture     ~s~↓")
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                        end
                    })
                end)

                RageUI.IsVisible(MenuHeureMeteo, function()

                    RageUI.Separator("↓     ~g~Raccourci     ~s~↓")
                    RageUI.Button("06:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 06 00') end})
                    RageUI.Button("08:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 08 00') end})
                    RageUI.Button("10:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 10 00') end})
                    RageUI.Button("12:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 12 00') end})
                    RageUI.Button("14:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 14 00') end})
                    RageUI.Button("16:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 16 00') end})
                    RageUI.Button("18:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 18 00') end})
                    RageUI.Button("20:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 20 00') end})
                    RageUI.Button("22:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 22 00') end})
                    RageUI.Button("00:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 00 00') end})
                    RageUI.Button("02:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 02 00') end})
                    RageUI.Button("04:00", nil, {RightLabel = "~y~→"}, true, { onSelected = function() ExecuteCommand('time 04 00') end})

                    RageUI.Separator("↓     ~r~Fermeture     ~s~↓")
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                        end
                    })
                end)
            Wait(0)
            end
        end)
    end
end


RegisterNetEvent('dpr_Meteo:HeurePerso')
AddEventHandler('dpr_Meteo:HeurePerso', function(service, nom, message)
	if service == 'employer' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('Message Avocat', '~y~Message:', 'Employer: ~g~'..nom..'\n~w~Message: ~g~'..message..'', 'CHAR_ESTATE_AGENT', 1)
		Wait(14000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)	
	end
end)

RegisterCommand("+adminMenu", function()
    if not (PlayerJail) and not (SetEntityRagdoll) and not (IsInPersoMenu) then
        local pPed = PlayerId()
        local pId = GetPlayerServerId(pPed)
        for k,v in pairs(EwenXSerty.AdminList) do 
            if k == pId then 
                OpenMenu(v)
                return
            end
        end 
    end
end, false)

RegisterCommand("meteo", function()
    if not (PlayerJail) and not (SetEntityRagdoll) and not (IsInPersoMenu) then
        local pPed = PlayerId()
        local pId = GetPlayerServerId(pPed)
        for k,v in pairs(EwenXSerty.AdminList) do 
            if k == pId then 
                OpenMenuMeteo(v)
                return
            end
        end 
    end
end, false)

RegisterKeyMapping("+adminMenu", "Menu Admin", 'keyboard', EwenXSerty.Config.KeyOpenMenu)

local function OpenAvisMenu(data)
    if EwenXSerty.Config.Debug then 
        EwenXSerty.Debug("Ouverture du menu")
    end
    local menu = RageUI.CreateMenu("", "")
  
    RageUI.Visible(menu, not RageUI.Visible(menu))
    
    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
            
            RageUI.Line()
            RageUI.Separator("Vous allez évaluer le service d'un staff")
            RageUI.Separator("Vous allez évaluer : "..data.name)
            RageUI.Separator("Ce staff vous a aidé pour : "..data.reasonReport)
            RageUI.Line()
            RageUI.List('Appréciation', {
                { Name = "⭐️", Value = 1 }, 
                { Name = "⭐️⭐️", Value = 2 },
                { Name = "⭐️⭐️⭐️", Value = 3 }, 
                { Name = "⭐️⭐️⭐️⭐️", Value = 4 }, 
                { Name = "⭐️⭐️⭐️⭐️⭐️", Value = 5 }
            }, Menu.List.AppreciationIndex, nil, {}, true, {
                onListChange = function(Index, Item)
                    Menu.List.AppreciationIndex = Index;
                    Menu.List.AppreciationItem = Item
                end
            })
            RageUI.Button("Envoyer l'appréciation", nil, {RightLabel = "→→→"}, true, {
                onSelected = function()
                    TriggerServerEvent("EwenXSerty:AddEvaluation", data.id, Menu.List.AppreciationItem.Value)
                    RageUI.CloseAll()
                end 
            })
        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end

RegisterNetEvent("EwenXSerty:OpenAvisMenu")
AddEventHandler("EwenXSerty:OpenAvisMenu", function(data)
    OpenAvisMenu(data)
end)

RegisterNetEvent("EwenXSerty:GetStaffsList")
AddEventHandler("EwenXSerty:GetStaffsList", function(staffList)
    Menu.ListStaff = staffList
end)

RegisterNetEvent("EwenXSerty:ReceiveItemList")
AddEventHandler("EwenXSerty:ReceiveItemList", function(itemList)
    Menu.ItemList = itemList
end)

Citizen.CreateThread(function()
    while true do 
        if PlayerInSpec then 
            Visual.Text({message = "Appuyez sur ~c~[E] pour quitter le mode spectate"})
            if IsControlJustPressed(1, 51) then
                Admin:ExitSpectate()
            end
            Wait(1)
        else 
            Wait(1000)
        end
    end
end)