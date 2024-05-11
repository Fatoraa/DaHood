ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

----------- CRON 

local Jobs = {}
local LastTime = nil

function RunAt(h, m, cb)
	table.insert(Jobs, {
		h  = h,
		m  = m,
		cb = cb
	})
end

function GetTime()
	local timestamp = os.time()
	local d = os.date('*t', timestamp).wday
	local h = tonumber(os.date('%H', timestamp))
	local m = tonumber(os.date('%M', timestamp))

	return {d = d, h = h, m = m}
end

function OnTime(d, h, m)

	for i=1, #Jobs, 1 do
		if Jobs[i].h == h and Jobs[i].m == m then
			Jobs[i].cb(d, h, m)
		end
	end
end

function Tick()
	local time = GetTime()

	if time.h ~= LastTime.h or time.m ~= LastTime.m then
		OnTime(time.d, time.h, time.m)
		LastTime = time
	end

	SetTimeout(60000, Tick)
end

LastTime = GetTime()

Tick()

AddEventHandler('cron:runAt', function(h, m, cb)
	RunAt(h, m, cb)
end)


-- whitelist c2s events
RegisterServerEvent('hostingSession')
RegisterServerEvent('hostedSession')

-- event handler for pre-session 'acquire'
local currentHosting
local hostReleaseCallbacks = {}

-- TODO: add a timeout for the hosting lock to be held
-- TODO: add checks for 'fraudulent' conflict cases of hosting attempts (typically whenever the host can not be reached)
AddEventHandler('hostingSession', function()
    -- if the lock is currently held, tell the client to await further instruction
    if currentHosting then
        TriggerClientEvent('sessionHostResult', source, 'wait')

        -- register a callback for when the lock is freed
        table.insert(hostReleaseCallbacks, function()
            TriggerClientEvent('sessionHostResult', source, 'free')
        end)

        return
    end

    -- if the current host was last contacted less than a second ago
    if GetHostId() then
        if GetPlayerLastMsg(GetHostId()) < 1000 then
            TriggerClientEvent('sessionHostResult', source, 'conflict')

            return
        end
    end

    hostReleaseCallbacks = {}

    currentHosting = source

    TriggerClientEvent('sessionHostResult', source, 'go')

    -- set a timeout of 5 seconds
    SetTimeout(5000, function()
        if not currentHosting then
            return
        end

        currentHosting = nil

        for _, cb in ipairs(hostReleaseCallbacks) do
            cb()
        end
    end)
end)

AddEventHandler('hostedSession', function()
    -- check if the client is the original locker
    if currentHosting ~= source then
        -- TODO: drop client as they're clearly lying
        print(currentHosting, '~=', source)
        return
    end

    -- free the host lock (call callbacks and remove the lock value)
    for _, cb in ipairs(hostReleaseCallbacks) do
        cb()
    end

    currentHosting = nil
end)

EnableEnhancedHostSupport(true)


---------------------------- SERVICE ----------------------------

local InService    = {}

local MaxInService = {}

function GetInServiceCount(name)
	local count = 0

	for k,v in pairs(InService[name]) do
		if v == true then
			count = count + 1
		end
	end

	return count
end

RegisterServerEvent('esx_service:activateService')
AddEventHandler('esx_service:activateService', function(name, max)
	InService[name] = {}
	MaxInService[name] = max
end)

RegisterServerEvent('esx_service:disableService')
AddEventHandler('esx_service:disableService', function(name)
	InService[name][source] = nil
end)

RegisterServerEvent('esx_service:notifyAllInService')
AddEventHandler('esx_service:notifyAllInService', function(notification, name)
	for k,v in pairs(InService[name]) do
		if v == true then
			TriggerClientEvent('esx_service:notifyAllInService', k, notification, source)
		end
	end
end)

ESX.RegisterServerCallback('esx_service:enableService', function(source, cb, name)
	local inServiceCount = GetInServiceCount(name)

	if inServiceCount >= MaxInService[name] then
		cb(false, MaxInService[name], inServiceCount)
	else
		InService[name][source] = true
		cb(true, MaxInService[name], inServiceCount)
	end
end)

ESX.RegisterServerCallback('esx_service:isInService', function(source, cb, name)
	local isInService = false

	if InService[name] ~= nil then
		if InService[name][source] then
			isInService = true
		end
	else
		print(('[esx_service] [^3WARNING^7] A service "%s" is not activated'):format(name))
	end

	cb(isInService)
end)

ESX.RegisterServerCallback('esx_service:isPlayerInService', function(source, cb, name, target)
	local isPlayerInService = false
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if InService[name][targetXPlayer.source] then
		isPlayerInService = true
	end

	cb(isPlayerInService)
end)

ESX.RegisterServerCallback('esx_service:getInServiceList', function(source, cb, name)
	cb(InService[name])
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	for k,v in pairs(InService) do
		if v[_source] == true then
			v[_source] = nil
		end
	end
end)

------------ map manager 

-- loosely based on MTA's https://code.google.com/p/mtasa-resources/source/browse/trunk/%5Bmanagers%5D/mapmanager/mapmanager_main.lua

local maps = {}
local gametypes = {}

local function refreshResources()
    local numResources = GetNumResources()

    for i = 0, numResources - 1 do
        local resource = GetResourceByFindIndex(i)

        if GetNumResourceMetadata(resource, 'resource_type') > 0 then
            local type = GetResourceMetadata(resource, 'resource_type', 0)
            local params = json.decode(GetResourceMetadata(resource, 'resource_type_extra', 0))
            
            local valid = false
            
            local games = GetNumResourceMetadata(resource, 'game')
            if games > 0 then
				for j = 0, games - 1 do
					local game = GetResourceMetadata(resource, 'game', j)
				
					if game == GetConvar('gamename', 'gta5') or game == 'common' then
						valid = true
					end
				end
            end

			if valid then
				if type == 'map' then
					maps[resource] = params
				elseif type == 'gametype' then
					gametypes[resource] = params
				end
			end
        end
    end
end

AddEventHandler('onResourceListRefresh', function()
    refreshResources()
end)

refreshResources()

AddEventHandler('onResourceStarting', function(resource)
    local num = GetNumResourceMetadata(resource, 'map')

    if num then
        for i = 0, num-1 do
            local file = GetResourceMetadata(resource, 'map', i)

            if file then
                addMap(file, resource)
            end
        end
    end

    if maps[resource] then
        if getCurrentMap() and getCurrentMap() ~= resource then
            if doesMapSupportGameType(getCurrentGameType(), resource) then
                print("Changing map from " .. getCurrentMap() .. " to " .. resource)

                changeMap(resource)
            else
                -- check if there's only one possible game type for the map
                local map = maps[resource]
                local count = 0
                local gt

                for type, flag in pairs(map.gameTypes) do
                    if flag then
                        count = count + 1
                        gt = type
                    end
                end

                if count == 1 then
                    print("Changing map from " .. getCurrentMap() .. " to " .. resource .. " (gt " .. gt .. ")")

                    changeGameType(gt)
                    changeMap(resource)
                end
            end

            CancelEvent()
        end
    elseif gametypes[resource] then
        if getCurrentGameType() and getCurrentGameType() ~= resource then
            print("Changing gametype from " .. getCurrentGameType() .. " to " .. resource)

            changeGameType(resource)

            CancelEvent()
        end
    end
end)

math.randomseed(GetInstanceId())

local currentGameType = nil
local currentMap = nil

AddEventHandler('onResourceStart', function(resource)
    if maps[resource] then
        if not getCurrentGameType() then
            for gt, _ in pairs(maps[resource].gameTypes) do
                changeGameType(gt)
                break
            end
        end

        if getCurrentGameType() and not getCurrentMap() then
            if doesMapSupportGameType(currentGameType, resource) then
                if TriggerEvent('onMapStart', resource, maps[resource]) then
                    if maps[resource].name then
                        print('Started map ' .. maps[resource].name)
                        SetMapName(maps[resource].name)
                    else
                        print('Started map ' .. resource)
                        SetMapName(resource)
                    end

                    currentMap = resource
                else
                    currentMap = nil
                end
            end
        end
    elseif gametypes[resource] then
        if not getCurrentGameType() then
            if TriggerEvent('onGameTypeStart', resource, gametypes[resource]) then
                currentGameType = resource

                local gtName = gametypes[resource].name or resource

                SetGameType(gtName)

                print('Started gametype ' .. gtName)

                SetTimeout(50, function()
                    if not currentMap then
                        local possibleMaps = {}

                        for map, data in pairs(maps) do
                            if data.gameTypes[currentGameType] then
                                table.insert(possibleMaps, map)
                            end
                        end

                        if #possibleMaps > 0 then
                            local rnd = math.random(#possibleMaps)
                            changeMap(possibleMaps[rnd])
                        end
                    end
                end)
            else
                currentGameType = nil
            end
        end
    end

    -- handle starting
    loadMap(resource)
end)

local function handleRoundEnd()
	local possibleMaps = {}

	for map, data in pairs(maps) do
		if data.gameTypes[currentGameType] then
			table.insert(possibleMaps, map)
		end
    end

    if #possibleMaps > 1 then
        local mapname = currentMap

        while mapname == currentMap do
            local rnd = math.random(#possibleMaps)
            mapname = possibleMaps[rnd]
        end

        changeMap(mapname)
    elseif #possibleMaps > 0 then
        local rnd = math.random(#possibleMaps)
        changeMap(possibleMaps[rnd])
	end
end

AddEventHandler('mapmanager:roundEnded', function()
    -- set a timeout as we don't want to return to a dead environment
    SetTimeout(50, handleRoundEnd) -- not a closure as to work around some issue in neolua?
end)

function roundEnded()
    SetTimeout(50, handleRoundEnd)
end

AddEventHandler('onResourceStop', function(resource)
    if resource == currentGameType then
        TriggerEvent('onGameTypeStop', resource)

        currentGameType = nil

        if currentMap then
            StopResource(currentMap)
        end
    elseif resource == currentMap then
        TriggerEvent('onMapStop', resource)

        currentMap = nil
    end

    -- unload the map
    unloadMap(resource)
end)

AddEventHandler('rconCommand', function(commandName, args)
    if commandName == 'map' then
        if #args ~= 1 then
            RconPrint("usage: map [mapname]\n")
        end

        if not maps[args[1]] then
            RconPrint('no such map ' .. args[1] .. "\n")
            CancelEvent()

            return
        end

        if currentGameType == nil or not doesMapSupportGameType(currentGameType, args[1]) then
            local map = maps[args[1]]
            local count = 0
            local gt

            for type, flag in pairs(map.gameTypes) do
                if flag then
                    count = count + 1
                    gt = type
                end
            end

            if count == 1 then
                print("Changing map from " .. getCurrentMap() .. " to " .. args[1] .. " (gt " .. gt .. ")")

                changeGameType(gt)
                changeMap(args[1])

                RconPrint('map ' .. args[1] .. "\n")
            else
                RconPrint('map ' .. args[1] .. ' does not support ' .. currentGameType .. "\n")
            end

            CancelEvent()

            return
        end

        changeMap(args[1])

        RconPrint('map ' .. args[1] .. "\n")

        CancelEvent()
    elseif commandName == 'gametype' then
        if #args ~= 1 then
            RconPrint("usage: gametype [name]\n")
        end

        if not gametypes[args[1]] then
            RconPrint('no such gametype ' .. args[1] .. "\n")
            CancelEvent()

            return
        end

        changeGameType(args[1])

        RconPrint('gametype ' .. args[1] .. "\n")

        CancelEvent()
    end
end)

function getCurrentGameType()
    return currentGameType
end

function getCurrentMap()
    return currentMap
end

function getMaps()
    return maps
end

function changeGameType(gameType)
    if currentMap and not doesMapSupportGameType(gameType, currentMap) then
        StopResource(currentMap)
    end

    if currentGameType then
        StopResource(currentGameType)
    end

    StartResource(gameType)
end

function changeMap(map)
    if currentMap then
        StopResource(currentMap)
    end

    StartResource(map)
end

function doesMapSupportGameType(gameType, map)
    if not gametypes[gameType] then
        return false
    end

    if not maps[map] then
        return false
    end

    if not maps[map].gameTypes then
        return true
    end

    return maps[map].gameTypes[gameType]
end

---- esx_license 

function AddLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
			['@type']  = type,
			['@owner'] = xPlayer.identifier
		}, function(rowsChanged)
			if cb then
				cb()
			end
		end)
	else
		if cb then
			cb()
		end
	end
end

function RemoveLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner', {
			['@type'] = type,
			['@owner'] = xPlayer.identifier
		}, function(rowsChanged)
			if cb then
				cb()
			end
		end)
	else
		if cb then
			cb()
		end
	end
end

function GetLicense(type, cb)
	MySQL.Async.fetchAll('SELECT label FROM licenses WHERE type = @type', {
		['@type'] = type
	}, function(result)
		local data = {
			type  = type,
			label = result[1].label
		}

		cb(data)
	end)
end

function GetLicenses(target, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(result)
		local licenses, asyncTasks = {}, {}

		for i=1, #result, 1 do
			local scope = function(type)
				table.insert(asyncTasks, function(cb)
					MySQL.Async.fetchAll('SELECT label FROM licenses WHERE type = @type', {
						['@type'] = type
					}, function(result2)
						table.insert(licenses, {
							type  = type,
							label = result2[1].label
						})

						cb()
					end)
				end)
			end

			scope(result[i].type)
		end

		Async.parallel(asyncTasks, function(results)
			cb(licenses)
		end)
	end)
end

function CheckLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
			['@type'] = type,
			['@owner'] = xPlayer.identifier
		}, function(result)
			if tonumber(result[1].count) > 0 then
				cb(true)
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end

function GetLicensesList(cb)
	MySQL.Async.fetchAll('SELECT type, label FROM licenses', {
		['@type'] = type
	}, function(result)
		local licenses = {}

		for i=1, #result, 1 do
			table.insert(licenses, {
				type  = result[i].type,
				label = result[i].label
			})
		end

		cb(licenses)
	end)
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('esx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)

---- instance --- 

local instances = {}

function GetInstancedPlayers()
	local players = {}

	for k,v in pairs(instances) do
		for k2,v2 in ipairs(v.players) do
			players[v2] = true
		end
	end

	return players
end

AddEventHandler('playerDropped', function(reason)
	if instances[source] then
		CloseInstance(source)
	end
end)

function CreateInstance(type, player, data)
	instances[player] = {
		type    = type,
		host    = player,
		players = {},
		data    = data
	}

	TriggerEvent('instance:onCreate', instances[player])
	TriggerClientEvent('instance:onCreate', player, instances[player])
	TriggerClientEvent('instance:onInstancedPlayersData', -1, GetInstancedPlayers())
end

function CloseInstance(instance)
	if instances[instance] then

		for i=1, #instances[instance].players do
			TriggerClientEvent('instance:onClose', instances[instance].players[i])
		end

		instances[instance] = nil

		TriggerClientEvent('instance:onInstancedPlayersData', -1, GetInstancedPlayers())
		TriggerEvent('instance:onClose', instance)
	end
end

function AddPlayerToInstance(instance, player)
	local found = false

	for i=1, #instances[instance].players do
		if instances[instance].players[i] == player then
			found = true
			break
		end
	end

	if not found then
		table.insert(instances[instance].players, player)
	end

	TriggerClientEvent('instance:onEnter', player, instances[instance])

	for i=1, #instances[instance].players do
		if instances[instance].players[i] ~= player then
			TriggerClientEvent('instance:onPlayerEntered', instances[instance].players[i], instances[instance], player)
		end
	end

	TriggerClientEvent('instance:onInstancedPlayersData', -1, GetInstancedPlayers())
end

function RemovePlayerFromInstance(instance, player)
	if instances[instance] then
		TriggerClientEvent('instance:onLeave', player, instances[instance])

		if instances[instance].host == player then
			for i=1, #instances[instance].players do
				if instances[instance].players[i] ~= player then
					TriggerClientEvent('instance:onPlayerLeft', instances[instance].players[i], instances[instance], player)
				end
			end

			CloseInstance(instance)
		else
			for i=1, #instances[instance].players do
				if instances[instance].players[i] == player then
					instances[instance].players[i] = nil
				end
			end

			for i=1, #instances[instance].players do
				if instances[instance].players[i] ~= player then
					TriggerClientEvent('instance:onPlayerLeft', instances[instance].players[i], instances[instance], player)
				end

			end

			TriggerClientEvent('instance:onInstancedPlayersData', -1, GetInstancedPlayers())
		end
	end
end

function InvitePlayerToInstance(instance, type, player, data)
	TriggerClientEvent('instance:onInvite', player, instance, type, data)
end

RegisterServerEvent('instance:create')
AddEventHandler('instance:create', function(type, data)
	CreateInstance(type, source, data)
end)

RegisterServerEvent('instance:close')
AddEventHandler('instance:close', function()
	CloseInstance(source)
end)

RegisterServerEvent('instance:enter')
AddEventHandler('instance:enter', function(instance)
	AddPlayerToInstance(instance, source)
end)

RegisterServerEvent('instance:leave')
AddEventHandler('instance:leave', function(instance)
	RemovePlayerFromInstance(instance, source)
end)

RegisterServerEvent('instance:invite')
AddEventHandler('instance:invite', function(instance, type, player, data)
	InvitePlayerToInstance(instance, type, player, data)
end)

--- esx_billing 


RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(amount)

	if amount > 0 and xTarget then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if account then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target'] = sharedAccountName,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					xTarget.showNotification('Vous avez ~r~reçu~s~ une facture')
				end)
			else
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target'] = xPlayer.identifier,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					xTarget.showNotification('Vous avez ~r~reçu~s~ une facture')
				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			cb(result)
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, billId)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT sender, target_type, target, amount FROM billing WHERE id = @id', {
		['@id'] = billId
	}, function(result)
		if result[1] then
			local amount = result[1].amount
			local xTarget = ESX.GetPlayerFromIdentifier(result[1].sender)

			if result[1].target_type == 'player' then
				if xTarget then
					if xPlayer.getMoney() >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								xTarget.addMoney(amount)

								xPlayer.showNotification('Vous avez ~g~payé~s~ une facture de ~r~$%s~s~', ESX.Math.GroupDigits(amount))
								xTarget.showNotification('Vous avez ~g~reçu~s~ un paiement de ~g~$%s~s~', ESX.Math.GroupDigits(amount))
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								xTarget.addAccountMoney('bank', amount)

								xPlayer.showNotification('Vous avez ~g~payé~s~ une facture de ~r~$%s~s~', ESX.Math.GroupDigits(amount))
								xTarget.showNotification('Vous avez ~g~reçu~s~ un paiement de ~g~$%s~s~', ESX.Math.GroupDigits(amount))
							end

							cb()
						end)
					else
						xTarget.showNotification('Le joueur ~r~n\'a pas~s~ assez d\'argent pour payer la facture!')
						xPlayer.showNotification('Vous n\'avez pas assez d\'argent pour payer cette facture')
						cb()
					end
				else
					xPlayer.showNotification('Le joueur n\'est pas connecté')
					cb()
				end
			else
				TriggerEvent('esx_addonaccount:getSharedAccount', result[1].target, function(account)
					if xPlayer.getMoney() >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								account.addMoney(amount)

								xPlayer.showNotification('Vous avez ~g~payé~s~ une facture de ~r~$%s~s~', ESX.Math.GroupDigits(amount))
								if xTarget then
									xTarget.showNotification('Vous avez ~g~reçu~s~ un paiement de ~g~$%s~s~', ESX.Math.GroupDigits(amount))
								end
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						MySQL.Async.execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								account.addMoney(amount)
								xPlayer.showNotification('Vous avez ~g~payé~s~ une facture de ~r~$%s~s~', ESX.Math.GroupDigits(amount))

								if xTarget then
									xTarget.showNotification('Vous avez ~g~reçu~s~ un paiement de ~g~$%s~s~', ESX.Math.GroupDigits(amount))
								end
							end

							cb()
						end)
					else
						if xTarget then
							xTarget.showNotification('Le joueur ~r~n\'a pas~s~ assez d\'argent pour payer la facture!')
						end

						xPlayer.showNotification('Vous n\'avez pas assez d\'argent pour payer cette facture')
						cb()
					end
				end)
			end
		end
	end)
end)

-------------------------------------------------------------------
ESX.RegisterUsableItem('bread', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)



	xPlayer.removeInventoryItem('bread', 1)



	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)

	TriggerClientEvent('esx_basicneeds:onEat', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez mangé du ~r~Pain'))

end)

ESX.RegisterUsableItem('chips', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'chips', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('sandwich', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'sandwich', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('chocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'chocolate', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('cacahuete', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'cacahuete', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('poire', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'poire', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('sucrebrin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'sucrebrin', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('citron', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'citron', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('ananas', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'ananas', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('glacon', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'glacon', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('menthe', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'menthe', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('cerise', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'cerise', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('citronvert', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'citronvert', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

ESX.RegisterUsableItem('goussevanille', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onEat', source, 'prop_cs_burger_01', 'goussevanille', 'hunger', 200000, 'กิน <strong class="green-text">ขนมปัง</strong> 1 ชิ้น')
end)

-- Drink
ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'water', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('cocacola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'cocacola', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('icetea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'icetea', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('bierre', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'bierre', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('gin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'gin', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('liqueurorange', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'liqueurorange', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('juscitron', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'juscitron', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('brancheromarin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'brancheromarin', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('juspamplemouse', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'juspamplemouse', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('siropthea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'siropthea', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('juscanneberge', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'juscanneberge', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('vinblanc', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'vinblanc', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('liqueurcuracaobleu', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'liqueurcuracaobleu', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('jusananaas', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'jusananaas', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('limonade', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'limonade', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('hanesy', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'hanesy', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('siropromarin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'siropromarin', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('angostura', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'angostura', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('bourbon', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'bourbon', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('vermouth', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'vermouth', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('siropcanne', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'siropcanne', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('rhum', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'rhum', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('cremecoco', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'cremecoco', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('watergaz', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'watergaz', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('condelumar', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'condelumar', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('cafe', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'cafe', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('aromevanille', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'aromevanille', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('chantilly', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'chantilly', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('presquesante', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'presquesante', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('rosemarie', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'rosemarie', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('sangria', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'sangria', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('nouvellefrance', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'nouvellefrance', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('oldfashioned', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'oldfashioned', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('martini', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'martini', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('pinacoladaananas', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'pinacoladaananas', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('mojito', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'mojito', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('valhalla', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'valhalla', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)

ESX.RegisterUsableItem('vanilla', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_basicneeds:onDrink', source, 'prop_ld_flow_bottle', 'vanilla', 'thirst', 200000, 'ดื่ม <strong class="blue-text">น้ำ</strong> 1 ขวด')
end)


ESX.RegisterUsableItem('water', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)

	TriggerClientEvent('esx_status:add', source, 'hunger', 30000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez bu de ~b~l\'eau'))

end)

ESX.RegisterUsableItem('apple', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('apple', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 3000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez mangé une ~g~Pomme'))

end)
ESX.RegisterUsableItem('fanta', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fanta', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez bu du ~o~fanta'))

end)
ESX.RegisterUsableItem('7up', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('7up', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez bu du ~g~7UP'))

end)
ESX.RegisterUsableItem('croissant', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('croissant', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 3000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez mangé un ~y~Croissant '))

end)
ESX.RegisterUsableItem('lipton', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('lipton', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez bu du ~y~Ice tea '))

end)
ESX.RegisterUsableItem('mars', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('mars', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 2000)

	TriggerClientEvent('esx_basicneeds:onEat', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez mangé un ~b~Mars '))

end)
ESX.RegisterUsableItem('snickers', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('snickers', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 2000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez mangé un ~o~snickers '))

end)
ESX.RegisterUsableItem('sprite', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('sprite', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez bu du ~g~Sprite '))

end)
ESX.RegisterUsableItem('bounty', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bounty', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 2000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez mangé un ~b~bounty '))

end)
ESX.RegisterUsableItem('cocacola', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cocacola', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 2000)

	TriggerClientEvent('esx_basicneeds:onDrink', source)

	TriggerClientEvent('esx:showNotification', source, ('Vous avez bu un ~b~Coca Cola'))

end)
------------------------------------------------------------------------------------------


TriggerEvent('es:addGroupCommand', 'heal', 'admin', function(source, args, user)

	-- heal another player - don't heal source

	if args[1] then

		local playerId = tonumber(args[1])



		-- is the argument a number?

		if playerId then

			-- is the number a valid player?

			if GetPlayerName(playerId) then

				print(('esx_basicneeds: %s à soigné %s'):format(GetPlayerIdentifier(source, 1), GetPlayerIdentifier(playerId, 1)))

				TriggerClientEvent('esx_basicneeds:healPlayer', playerId)

				TriggerClientEvent('chat:addMessage', source, { args = { '^5HEAL', 'Vous avez été soigné.' } })

			else

				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Joueur non connecté.' } })

			end

		else

			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'ID Incorrecte.' } })

		end

	else

		print(('esx_basicneeds: %s healed self'):format(GetPlayerIdentifier(source, 1)))

		TriggerClientEvent('esx_basicneeds:healPlayer', source)

	end

end, function(source, args, user)

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })

end, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', params = {{name = 'playerId', help = '(optional) player id'}}})

-- addon inventory 


Items = {}
local InventoriesIndex, Inventories, SharedInventories = {}, {}, {}

MySQL.ready(function()
	local items = MySQL.Sync.fetchAll('SELECT * FROM items')

	for i=1, #items, 1 do
		Items[items[i].name] = items[i].label
	end

	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory')

	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', {
			['@inventory_name'] = name
		})

		if shared == 0 then

			table.insert(InventoriesIndex, name)

			Inventories[name] = {}
			local items       = {}

			for j=1, #result2, 1 do
				local itemName  = result2[j].name
				local itemCount = result2[j].count
				local itemOwner = result2[j].owner

				if items[itemOwner] == nil then
					items[itemOwner] = {}
				end

				table.insert(items[itemOwner], {
					name  = itemName,
					count = itemCount,
					label = Items[itemName]
				})
			end

			for k,v in pairs(items) do
				local addonInventory = CreateAddonInventory(name, k, v)
				table.insert(Inventories[name], addonInventory)
			end

		else
			local items = {}

			for j=1, #result2, 1 do
				table.insert(items, {
					name  = result2[j].name,
					count = result2[j].count,
					label = Items[result2[j].name]
				})
			end

			local addonInventory    = CreateAddonInventory(name, nil, items)
			SharedInventories[name] = addonInventory
		end
	end
end)

function GetInventory(name, owner)
	for i=1, #Inventories[name], 1 do
		if Inventories[name][i].owner == owner then
			return Inventories[name][i]
		end
	end
end

function GetSharedInventory(name)
	return SharedInventories[name]
end

AddEventHandler('esx_addoninventory:getInventory', function(name, owner, cb)
	cb(GetInventory(name, owner))
end)

AddEventHandler('esx_addoninventory:getSharedInventory', function(name, cb)
	cb(GetSharedInventory(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonInventories = {}

	for i=1, #InventoriesIndex, 1 do
		local name      = InventoriesIndex[i]
		local inventory = GetInventory(name, xPlayer.identifier)

		if inventory == nil then
			inventory = CreateAddonInventory(name, xPlayer.identifier, {})
			table.insert(Inventories[name], inventory)
		end

		table.insert(addonInventories, inventory)
	end

	xPlayer.set('addonInventories', addonInventories)
end)


function CreateAddonInventory(name, owner, items)
	local self = {}

	self.name  = name
	self.owner = owner
	self.items = items

	self.addItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count + count

		self.saveItem(name, item.count)
	end

	self.removeItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count - count

		self.saveItem(name, item.count)
	end

	self.setItem = function(name, count)
		local item = self.getItem(name)
		item.count = count

		self.saveItem(name, item.count)
	end

	self.getItem = function(name)
		for i=1, #self.items, 1 do
			if self.items[i].name == name then
				return self.items[i]
			end
		end

		item = {
			name  = name,
			count = 0,
			label = Items[name]
		}

		table.insert(self.items, item)

		if self.owner == nil then
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count) VALUES (@inventory_name, @item_name, @count)',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = 0
			})
		else
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count, owner) VALUES (@inventory_name, @item_name, @count, @owner)',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = 0,
				['@owner']          = self.owner
			})
		end

		return item
	end

	self.saveItem = function(name, count)
		if self.owner == nil then
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name', {
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = count
			})
		else
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name AND owner = @owner', {
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = count,
				['@owner']          = self.owner
			})
		end
	end

	return self
end

--esx addont account 

local AccountsIndex, Accounts, SharedAccounts = {}, {}, {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account')

	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
			['@account_name'] = name
		})

		if shared == 0 then
			table.insert(AccountsIndex, name)
			Accounts[name] = {}

			for j=1, #result2, 1 do
				local addonAccount = CreateAddonAccount(name, result2[j].owner, result2[j].money)
				table.insert(Accounts[name], addonAccount)
			end
		else
			local money = nil

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, NULL)', {
					['@account_name'] = name,
					['@money']        = 0
				})

				money = 0
			else
				money = result2[1].money
			end

			local addonAccount   = CreateAddonAccount(name, nil, money)
			SharedAccounts[name] = addonAccount
		end
	end
end)

function GetAccount(name, owner)
	for i=1, #Accounts[name], 1 do
		if Accounts[name][i].owner == owner then
			return Accounts[name][i]
		end
	end
end

function GetSharedAccount(name)
	return SharedAccounts[name]
end

AddEventHandler('esx_addonaccount:getAccount', function(name, owner, cb)
	cb(GetAccount(name, owner))
end)

AddEventHandler('esx_addonaccount:getSharedAccount', function(name, cb)
	cb(GetSharedAccount(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonAccounts = {}

	for i=1, #AccountsIndex, 1 do
		local name    = AccountsIndex[i]
		local account = GetAccount(name, xPlayer.identifier)

		if account == nil then
			MySQL.Async.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, @owner)', {
				['@account_name'] = name,
				['@money']        = 0,
				['@owner']        = xPlayer.identifier
			})

			account = CreateAddonAccount(name, xPlayer.identifier, 0)
			table.insert(Accounts[name], account)
		end

		table.insert(addonAccounts, account)
	end

	xPlayer.set('addonAccounts', addonAccounts)
end)

function CreateAddonAccount(name, owner, money)
	local self = {}

	self.name  = name
	self.owner = owner
	self.money = money

	self.addMoney = function(m)
		self.money = self.money + m
		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end

	self.removeMoney = function(m)
		self.money = self.money - m
		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end

	self.setMoney = function(m)
		self.money = m
		self.save()

		TriggerClientEvent('esx_addonaccount:setMoney', -1, self.name, self.money)
	end

	self.save = function()
		if self.owner == nil then
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name', {
				['@account_name'] = self.name,
				['@money']        = self.money
			})
		else
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name AND owner = @owner', {
				['@account_name'] = self.name,
				['@money']        = self.money,
				['@owner']        = self.owner
			})
		end
	end

	return self
end

--------------- ESX SKIN -----
RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)

	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
				local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

				file:write(json.encode(skin) .. "\n\n")
				file:flush()
				file:close()
			else
				print(('esx_skin: %s attempted saving skin to file'):format(user.getIdentifier()))
			end
		end)
	end)

end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)
