
ESX = exports["es_extended"]:getSharedObject()

EwenXSertySrv = {
    Notification = function(id, str)
        TriggerClientEvent("iNotificationV3:showNotification:showNotification", id, str)
    end,
    NotifiedAllStaff = function(str)
        for k,v in pairs(EwenXSertySrv.AdminList) do 
            if v.inService then
                EwenXSertySrv.Notification(k, str) 
            end  
        end
    end,
    GetDate = function()
        local date = os.date('*t')
        
        if date.day < 10 then date.day = '0' .. tostring(date.day) end
        if date.month < 10 then date.month = '0' .. tostring(date.month) end
        if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
        if date.min < 10 then date.min = '0' .. tostring(date.min) end
        if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    
        return(date.day ..'/'.. date.month ..'/'.. date.year ..' - '.. date.hour ..':'.. date.min ..':'.. date.sec)
    end,
    GetHours = function()
        local date = os.date('*t')

        if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
        if date.min < 10 then date.min = '0' .. tostring(date.min) end
        if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    
        return(date.hour ..':'.. date.min ..':'.. date.sec)
    end,
    Print = function(str) 
        --print(EwenXSerty.Config.Print.DefaultPrefix.." "..str)
    end,
    Debug = function(str) 
        --print(EwenXSerty.Config.Print.DebugPrefix.." "..str)
    end,
    UpdateReport = function()
        for k,v in pairs(EwenXSertySrv.AdminList) do 
            --if v.inService then
                TriggerClientEvent("EwenXSerty:UpdateReportsList", k, EwenXSertySrv.ReportsList)
            --end
        end
    end,
    AdminList = {},
    PlayersList = {},
    ReportsList = {},
    Items = {},
    TriggersForStaff = function(triggerName, args)
        for k,v in pairs(EwenXSertySrv.AdminList) do 
            --if v.inService then
                TriggerClientEvent(triggerName, k, args)
            --end
        end
    end
}

 EwenXSertySrv.Print("Serty a dit ton menu est start")

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        for k, v in pairs(result) do
            EwenXSertySrv.Items[k] = { label = v.label, name = v.name }
        end
    end)
end)

RegisterNetEvent('EwenXSerty:IEwenXSerty')
AddEventHandler('EwenXSerty:IEwenXSerty', function()
    local _source = source
	if not _source then return end
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end 
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        local dbQuery = false
        if not EwenXSertySrv.AdminList[_source] then 

            EwenXSertySrv.AdminList[_source] = {}
            EwenXSertySrv.AdminList[_source].source = _source
            EwenXSertySrv.AdminList[_source].name = GetPlayerName(_source)
            EwenXSertySrv.AdminList[_source].license = xPlayer.identifier
            EwenXSertySrv.AdminList[_source].inService = false
            EwenXSertySrv.AdminList[_source].grade = xGroup

            MySQL.Async.fetchAll('SELECT * FROM `staff` WHERE `license`=@license', {
                ['@license'] = xPlayer.identifier
            }, function(result)
                if result[1] then
                    EwenXSertySrv.AdminList[_source].reportEffectued = tonumber(result[1].report)
                    EwenXSertySrv.AdminList[_source].appreciation = json.decode(result[1].evaluation)
                else
                    MySQL.Sync.execute('INSERT INTO `staff` (name, license, evaluation, report) VALUES (@name, @license, @evaluation, @report)', {
                        ['@name'] = GetPlayerName(_source),
                        ['@license'] = xPlayer.identifier,
                        ['@evaluation'] = json.encode({}),
                        ['@report'] = 0,
                    }, function() end)

                    EwenXSertySrv.AdminList[_source].reportEffectued = 0
                    EwenXSertySrv.AdminList[_source].appreciation = {}
                end
                dbQuery = true
            end)

            while not dbQuery do Wait(1) end

            EwenXSertySrv.Notification(_source, "~g~Administration~s~\nVotre mode staff est actuellement ~c~désactivé~s~.\n[~y~"..EwenXSerty.Config.KeyOpenMenu.."~s~] pour ouvrir le menu.")
            TriggerClientEvent("EwenXSerty:NewAdmin", -1, EwenXSertySrv.AdminList[_source])
            TriggerClientEvent("EwenXSerty:GetPlayerList", _source, EwenXSertySrv.PlayersList)
            TriggerClientEvent("EwenXSerty:GetReports", _source, EwenXSertySrv.ReportsList)    

            if EwenXSerty.Config.Debug then 
                EwenXSertySrv.Debug("Connexion du staff "..GetPlayerName(_source))
            end

            return
        else
            EwenXSertySrv.AdminList[_source].source = _source
            EwenXSertySrv.AdminList[_source].inService = false
            EwenXSertySrv.AdminList[_source].grade = xGroup
            EwenXSertySrv.Notification(_source, "~g~Administration~s~\nVotre mode staff est actuellement ~c~désactivé~s~.\n[~y~"..EwenXSerty.Config.KeyOpenMenu.."~s~] pour ouvrir le menu.")
            TriggerClientEvent("EwenXSerty:NewAdmin", -1, EwenXSertySrv.AdminList[_source])

            if EwenXSerty.Config.Debug then 
                EwenXSertySrv.Debug("Refresh du staff "..GetPlayerName(_source))
            end
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local _source = source

    if not EwenXSertySrv.PlayersList[_source] then 
        EwenXSertySrv.PlayersList[_source] = {}
        EwenXSertySrv.PlayersList[_source].source = _source
        EwenXSertySrv.PlayersList[_source].name = GetPlayerName(_source)
        EwenXSertySrv.PlayersList[_source].hoursLogin = EwenXSertySrv.GetHours()
        TriggerClientEvent("EwenXSerty:NewPlayerList", -1, _source, EwenXSertySrv.PlayersList[_source])
    end
end)

RegisterNetEvent('EwenXSerty:updateGroupe')
AddEventHandler('EwenXSerty:updateGroupe', function(source, newGroupe)
    local _source = source

    if EwenXSertySrv.AdminList[_source] then 
        EwenXSertySrv.AdminList[_source].grade = newGroupe
        TriggerClientEvent("EwenXSerty:UpdateAdminGroup", _source, _source, newGroupe)
    else 
        DropPlayer(_source, "Déco reco toi pour éviter les petits bugs de synchronisation que tu pourrais rencontrer.")
    end
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source

    if EwenXSertySrv.PlayersList[_source] then 
        EwenXSertySrv.PlayersList[_source] = nil
        EwenXSertySrv.TriggersForStaff("EwenXSerty:RemovePlayerList", _source)
    end

    if EwenXSertySrv.ReportsList[_source] then 
        EwenXSertySrv.ReportsList[_source] = nil 
        EwenXSertySrv.UpdateReport()
    end

    if EwenXSertySrv.AdminList[_source] then 
        MySQL.Sync.execute('UPDATE staff SET evaluation = @evaluation, report = @report WHERE license = @license', {
            ['@license'] = EwenXSertySrv.AdminList[_source].license,
            ['@evaluation'] = json.encode(EwenXSertySrv.AdminList[_source].appreciation),
            ['@report'] = EwenXSertySrv.AdminList[_source].reportEffectued
        })
        EwenXSertySrv.AdminList[_source] = nil
        TriggerClientEvent("EwenXSerty:RemoveAdmin", -1, _source)


        
    end
end)

RegisterNetEvent('EwenXSerty:ChangeState')
AddEventHandler('EwenXSerty:ChangeState', function(state)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        if EwenXSertySrv.AdminList[_source] then 
            EwenXSertySrv.AdminList[_source].inService = state
            return
        else 
            exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
        end
    else 
        exports.SeaShield:ban({
            id = source, 
            reason = "Admin Bypass"
        })
    end
end)

RegisterNetEvent("EwenXSerty:Goto")
AddEventHandler("EwenXSerty:Goto", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= "user" then 
        local targetCoords = GetEntityCoords(GetPlayerPed(id))
        TriggerClientEvent("EwenXSerty:Tp", _source, targetCoords)
    else 
        exports.SeaShield:ban({
            id = source, 
            reason = "Admin Bypass"
        })
    end
end)
RegisterNetEvent("EwenXSerty:wipe")
AddEventHandler("EwenXSerty:wipe", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(id)
    local name = GetPlayerName(id)

    if xGroup ~= "user" then 
        DropPlayer(id, "Wipe en cours...")
        MySQL.Sync.execute("DELETE FROM users WHERE identifier='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM starterpack WHERE identifier='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM billing WHERE identifier='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM owned_vehicles WHERE owner='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM addon_inventory_items WHERE owner='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM addon_account_data WHERE owner='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM user_licenses WHERE owner='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM datastore_data WHERE owner='" .. xPlayer.identifier .. "'")
        MySQL.Sync.execute("DELETE FROM playerstattoos WHERE identifier='" .. xPlayer.identifier .. "'")
    else 
        exports.SeaShield:ban({
            id = source, 
            reason = "Admin Bypass"
        })
    end
end)

RegisterNetEvent("EwenXSerty:Bring")
AddEventHandler("EwenXSerty:Bring", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= "user" then 
        local pCoords = GetEntityCoords(GetPlayerPed(_source))
        TriggerClientEvent("EwenXSerty:Tp", id, pCoords)
    else 
        exports.SeaShield:ban({
            id = source, 
            reason = "Admin Bypass"
        })
    end
end)

RegisterNetEvent("EwenXSerty:Freeze")
AddEventHandler("EwenXSerty:Freeze", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= "user" then 
        TriggerClientEvent("EwenXSerty:FreezePlayer", id)
    else 
                    exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
    end
end)

RegisterNetEvent("EwenXSerty:GiveMoney")
AddEventHandler("EwenXSerty:GiveMoney", function(id, moneyType, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    --if _source == id then EwenXSertySrv.Notification(_source, "Vous pouvez pas vous auto-give") return end

    if xGroup ~= "user" then 
        local xTarget = ESX.GetPlayerFromId(id)
        xTarget.addAccountMoney(moneyType, amount)
    else 
                    exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
    end
end)

RegisterNetEvent("EwenXSerty:GiveItem")
AddEventHandler("EwenXSerty:GiveItem", function(id, item, amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    --if _source == id then EwenXSertySrv.Notification(_source, "Vous pouvez pas vous auto-give") return end

    if xGroup ~= "user" then 
        local xTarget = ESX.GetPlayerFromId(id)
        xTarget.addInventoryItem(item, amount)
    else 
                exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
    end
end)

RegisterNetEvent("EwenXSerty:SendMessage")
AddEventHandler("EwenXSerty:SendMessage", function(id, message)
    local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        EwenXSertySrv.Notification(id, "~r~Message Staff~s~\n"..message)
    else 
                    exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
    end
end)

RegisterNetEvent("EwenXSerty:TpParking")
AddEventHandler("EwenXSerty:TpParking", function(id)
    local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        TriggerClientEvent("EwenXSerty:TpParking", id)
    else 
                    exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
    end
end)

RegisterNetEvent("EwenXSerty:Kick")
AddEventHandler("EwenXSerty:Kick", function(id, reason)
    local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        DropPlayer(id, "Vous avez été kick.\nRaison : "..reason)
    else 
                    exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
    end
end)

RegisterNetEvent("EwenXSerty:AnnonceServer")
AddEventHandler("EwenXSerty:AnnonceServer", function(announce)
    local _source = source
      local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        TriggerClientEvent('chatMessage', -1, "ANNONCE", {255, 0, 0}, "" .. announce)
    else 
                    exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
    end
end)

RegisterNetEvent("EwenXSerty:ShowInventory")
AddEventHandler("EwenXSerty:ShowInventory", function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= "user" then 
        local xTarget = ESX.GetPlayerFromId(id)
        local targetInventory = xTarget.getInventory(false)
        local targetAccount = xTarget.getAccounts()
        local targetWeapons = {}

        local list = ESX.GetWeaponList()

        for i=1, #list, 1 do
            if xTarget.hasWeapon(list[i].name) then 
                table.insert(targetWeapons, list[i].label)
            end
        end
        TriggerClientEvent("EwenXSerty:ShowInventory", _source, targetInventory, targetAccount, targetWeapons)
    else 
                    exports.SeaShield:ban({
                id = source, 
                reason = "Admin Bypass"
            })
    end
end)

RegisterCommand("report", function(source, args)
    local _source = source 
    if not EwenXSertySrv.ReportsList[_source] then 
        if args[1] == nil or args[1] == nil then 
            EwenXSertySrv.Notification(_source, "Il faut minimum 2 mots pour faire la raison d'un report.")
            return
        else
            local xName = GetPlayerName(_source)
            EwenXSertySrv.ReportsList[_source] = {}
            EwenXSertySrv.ReportsList[_source].Name = xName
            EwenXSertySrv.ReportsList[_source].Source = _source
            EwenXSertySrv.ReportsList[_source].Date = EwenXSertySrv.GetDate()
            EwenXSertySrv.ReportsList[_source].Raison = table.concat(args, " ")
            EwenXSertySrv.ReportsList[_source].Taken = false
            EwenXSertySrv.ReportsList[_source].TakenBy = nil
            EwenXSertySrv.NotifiedAllStaff("Nouveau report de "..xName)
            EwenXSertySrv.UpdateReport()
        end
    else 
        EwenXSertySrv.Notification(_source, "Vous avez déjà un report en cours.")
    end
end, false)

RegisterNetEvent('EwenXSerty:UpdateReport')
AddEventHandler('EwenXSerty:UpdateReport', function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        if EwenXSertySrv.ReportsList[id] then 
            EwenXSertySrv.ReportsList[id].Taken = true 
            EwenXSertySrv.ReportsList[id].TakenBy = GetPlayerName(_source)
            EwenXSertySrv.UpdateReport()
            local targetCoords = GetEntityCoords(GetPlayerPed(id))
            TriggerClientEvent("EwenXSerty:Tp", _source, targetCoords, true)
        end
    end
end)

local PlayersPossibleEval = {}

RegisterNetEvent('EwenXSerty:ClotureReport')
AddEventHandler('EwenXSerty:ClotureReport', function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        EwenXSertySrv.AdminList[_source].reportEffectued = EwenXSertySrv.AdminList[_source].reportEffectued + 1
        TriggerClientEvent("EwenXSerty:UpdateNumberReport", _source, EwenXSertySrv.AdminList[_source].reportEffectued)
        TriggerClientEvent("EwenXSerty:OpenAvisMenu", id, {id = _source, name = GetPlayerName(_source), reasonReport = EwenXSertySrv.ReportsList[id].Raison})
        if EwenXSertySrv.ReportsList[id] then 
            EwenXSertySrv.Notification(_source, "Vous avez cloturer le report de "..EwenXSertySrv.ReportsList[id].Name..".")
            EwenXSertySrv.ReportsList[id] = nil
            PlayersPossibleEval[id] = true
            EwenXSertySrv.UpdateReport()
        end
    end
end)

RegisterNetEvent('EwenXSerty:AddEvaluation')
AddEventHandler('EwenXSerty:AddEvaluation', function(staffId, evaluation)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if PlayersPossibleEval[_source] then 
        PlayersPossibleEval[_source] = nil
        if EwenXSertySrv.AdminList[_source] then 
            table.insert(EwenXSertySrv.AdminList[_source].appreciation, evaluation)
        end
        TriggerClientEvent("EwenXSerty:UpdateAvis", staffId, staffId, EwenXSertySrv.AdminList[_source].appreciation)
        EwenXSertySrv.Notification(_source, "Votre évaluation a été envoyé avec succés.")
    end
end)

RegisterCommand("reload", function()
    print(json.encode(EwenXSertySrv.AdminList))
end, false)

RegisterNetEvent('EwenXSerty:GetStaffsList')
AddEventHandler('EwenXSerty:GetStaffsList', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        MySQL.Async.fetchAll('SELECT * FROM `staff`', {}, function(result)
            TriggerClientEvent("EwenXSerty:GetStaffsList", _source, result)
        end)    
    end
end)

RegisterServerEvent("EwenXSerty:WarnPlayer")
AddEventHandler("EwenXSerty:WarnPlayer", function(PlayerSelected, raison)
    local xPlayer = ESX.GetPlayerFromId(PlayerSelected)
    local xPlayerStaff = ESX.GetPlayerFromId(source)
    print(xPlayerStaff)

    if xPlayerStaff.getGroup() ~= "user" then
        if xPlayer ~= nil then
            MySQL.Async.execute("INSERT INTO warns (identifier, raison, date, warn_by, identifier_warn_by) VALUES (@a, @b, @c, @d, @e)", {
                ["@a"] = xPlayer.identifier,
                ["@b"] = raison,
                ["@c"] = os.date("%d/%m/%y à %Hh%M"),
                ["@d"] = xPlayerStaff.getName(),
                ["@e"] = xPlayerStaff.identifier,
            }, function()
            end)
            TriggerClientEvent("iNotificationV3:showNotification:showNotification", source, ("[~g~Succès~s~] Vous avez averti le joueur ~r~%s~s~ pour ~g~%s"):format(xPlayer.getName(), raison))
            TriggerClientEvent("iNotificationV3:showNotification:showNotification", xPlayer.source, ("Vous avez été averti par ~o~%s~s~ pour ~r~%s"):format(xPlayerStaff.getName(), raison))
        else
            TriggerClientEvent("iNotificationV3:showNotification:showNotification", xPlayerStaff.source, "[~r~Erreur~s~] Cet ID n'existe pas.")
        end
    else
        TriggerClientEvent("iNotificationV3:showNotification:showNotification", source, "[~r~Erreur~s~] Vous n'avez pas la permission pour avertir un joueur.")
    end
end)

RegisterServerEvent("EwenXSerty:RemoveWarn")
AddEventHandler("EwenXSerty:RemoveWarn", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() ~= "user" then
        MySQL.Async.execute("DELETE FROM warns WHERE id = @id", {
            ["@id"] = id
        }, function()
        end)
        TriggerClientEvent("iNotificationV3:showNotification:showNotification", source, "[~g~Succès~s~] Vous avez supprimé un avertissement.")
    else
        TriggerClientEvent("iNotificationV3:showNotification:showNotification", source, "[~r~Erreur~s~] Vous n'avez pas la permission pour retirer un warn.")
    end
end)

RegisterNetEvent('EwenXSerty:GetItemList')
AddEventHandler('EwenXSerty:GetItemList', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()

    if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        TriggerClientEvent("EwenXSerty:ReceiveItemList", _source, EwenXSertySrv.Items)   
    end
end)

local function GetStaffWithLicense(license)
    for k,v in pairs(EwenXSertySrv.AdminList) do 
        if v.license == license then 
            return k
        end
    end
    return nil
end

RegisterCommand("clearreport", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        if args[1] then
            local staffId = GetStaffWithLicense(args[1])
            if staffId then
                EwenXSertySrv.AdminList[staffId].reportEffectued = 0
                EwenXSertySrv.Notification(_source, "Votre avez clear les reports de "..EwenXSertySrv.AdminList[staffId].name..".")
                TriggerClientEvent("EwenXSerty:UpdateNumberReport", staffId, EwenXSertySrv.AdminList[_source].reportEffectued)
            else 
                MySQL.Sync.execute('UPDATE staff SET report = @report WHERE license = @license', {
                    ['@license'] = args[1],
                    ['@report'] = 0
                })
                EwenXSertySrv.Notification(_source, "Votre avez clear les reports.")
            end
        else 
            EwenXSertySrv.Notification(_source, "Vous devez spécifier une license.")
        end
    end
end, false)

RegisterCommand("clearavis", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
   if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        if args[1] then
            local staffId = GetStaffWithLicense(args[1])
            if staffId then
                EwenXSertySrv.AdminList[staffId].appreciation = {}
                EwenXSertySrv.Notification(_source, "Votre avez clear les avis de "..EwenXSertySrv.AdminList[staffId].name..".")
                TriggerClientEvent("EwenXSerty:UpdateAvis", staffId, staffId, EwenXSertySrv.AdminList[_source].appreciation)
            else 
                MySQL.Sync.execute('UPDATE staff SET evaluation = @reporevaluationt WHERE license = @license', {
                    ['@license'] = args[1],
                    ['@evaluation'] = json.encode({})
                })
                EwenXSertySrv.Notification(_source, "Votre avez clear les avis.")
            end
        else 
            EwenXSertySrv.Notification(_source, "Vous devez spécifier une license.")
        end
    end
end, false)

RegisterCommand("deletstaff", function(source, args)
    local _source = source 
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xGroup = xPlayer.getGroup()
    
    if xGroup ~= EwenXSerty.Config.DefaultGroup then 
        if args[1] then
            print(args[1])
            local staffId = GetStaffWithLicense(args[1])
            if staffId then
                EwenXSertySrv.AdminList[staffId].appreciation = {}
                EwenXSertySrv.Notification(_source, "Votre avez supprimer le staff "..EwenXSertySrv.AdminList[staffId].name..".")
            else 
                MySQL.Sync.execute('DELETE FROM staff WHERE license=@license', {
                    ['@license'] = args[1]
                })
                EwenXSertySrv.Notification(_source, "Votre avez supprimer le staff.")
            end
        else 
            EwenXSertySrv.Notification(_source, "Vous devez spécifier une license.")
        end
    end
end, false)

print('^3Script by ^1Nostra^3. Discord: ^5discord.gg/cfxdevv')
