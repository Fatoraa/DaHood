ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex, height FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].firstname ~= nil then
			local data = {
				identifier	= result[1].identifier,
				firstname	= result[1].firstname,
				lastname	= result[1].lastname,
				dateofbirth	= result[1].dateofbirth,
				sex			= result[1].sex,
				height		= result[1].height
			}

			callback(data)
		else
			local data = {
				identifier	= '',
				firstname	= '',
				lastname	= '',
				dateofbirth	= '',
				sex			= '',
				height		= ''
			}

			callback(data)
		end
	end)
end

function setIdentity(identifier, data, callback)
	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function updateIdentity(playerId, data, callback)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= xPlayer.identifier,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(rowsChanged)
		if callback then
			TriggerEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:characterUpdated', playerId, data)
			callback(true)
		end
	end)
end

function deleteIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= xPlayer.identifier,
		['@firstname']		= '',
		['@lastname']		= '',
		['@dateofbirth']	= '',
		['@sex']			= '',
		['@height']			= '',
	})
end

RegisterServerEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:oieaifejnmfaofneoingeoga')
AddEventHandler('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:oieaifejnmfaofneoingeoga', function(data, myIdentifiers)
	local xPlayer = ESX.GetPlayerFromId(source)
	setIdentity(myIdentifiers.steamid, data, function(callback)
		if callback then
			TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:identityCheck', myIdentifiers.playerid, true)
			TriggerEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:characterUpdated', myIdentifiers.playerid, data)
		else
			xPlayer.showNotification(_U('failed_identity'))
		end
	end)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local myID = {
		steamid = xPlayer.identifier,
		playerid = playerId
	}

	TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:saveID', playerId, myID)

	getIdentity(playerId, function(data)
		if data.firstname == '' then
			TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:identityCheck', playerId, false)
			TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:showRegisterIdentity', playerId)
		else
			TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:identityCheck', playerId, true)
			TriggerEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:characterUpdated', playerId, data)
		end
	end)
end)

AddEventHandler('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:characterUpdated', function(playerId, data)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		xPlayer.setName(('%s %s'):format(data.firstname, data.lastname))
		xPlayer.set('firstName', data.firstname)
		xPlayer.set('lastName', data.lastname)
		xPlayer.set('dateofbirth', data.dateofbirth)
		xPlayer.set('sex', data.sex)
		xPlayer.set('height', data.height)
	end
end)

-- Set all the client side variables for connected users one new time
AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(3000)
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer then
				local myID = {
					steamid  = xPlayer.identifier,
					playerid = xPlayer.source
				}
	
				TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:saveID', xPlayer.source, myID)
	
				getIdentity(xPlayer.source, function(data)
					if data.firstname == '' then
						TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:identityCheck', xPlayer.source, false)
						TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:showRegisterIdentity', xPlayer.source)
					else
						TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:identityCheck', xPlayer.source, true)
						TriggerEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:characterUpdated', xPlayer.source, data)
					end
				end)
			end
		end
	end
end)

TriggerEvent('es:addGroupCommand', 'resetchar', 'guide', function(source, args, user)
	local pname = GetPlayerName(args[1])
	local modname = GetPlayerName(source)
	TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:showRegisterIdentity', args[1], {})
	TriggerClientEvent('scarface_notify', source, '#ff0000', 'Information',  'Du hast die Identität von '.. pname ..' | ID: ' .. args[1] .. ' zurückgesetzt.')
	TriggerClientEvent('scarface_notify', args[1], '#ff0000', 'Information',  'Deine Identität wurde von '.. modname ..' zurückgesetzt.')
end, {help = "Register a new character"})

TriggerEvent('es:addGroupCommand', 'resetchar', 'supporter', function(source, args, user)
	local pname = GetPlayerName(args[1])
	local modname = GetPlayerName(source)
	TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:showRegisterIdentity', args[1], {})
	TriggerClientEvent('scarface_notify', source, '#ff0000', 'Information',  'Du hast die Identität von '.. pname ..' | ID: ' .. args[1] .. ' zurückgesetzt.')
	TriggerClientEvent('scarface_notify', args[1], '#ff0000', 'Information',  'Deine Identität wurde von '.. modname ..' zurückgesetzt.')
end, {help = "Register a new character"})

TriggerEvent('es:addGroupCommand', 'resetchar', 'mod', function(source, args, user)
	local pname = GetPlayerName(args[1])
	local modname = GetPlayerName(source)
	TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:showRegisterIdentity', args[1], {})
	TriggerClientEvent('scarface_notify', source, '#ff0000', 'Information',  'Du hast die Identität von '.. pname ..' | ID: ' .. args[1] .. ' zurückgesetzt.')
	TriggerClientEvent('scarface_notify', args[1], '#ff0000', 'Information',  'Deine Identität wurde von '.. modname ..' zurückgesetzt.')
end, {help = "Register a new character"})

TriggerEvent('es:addGroupCommand', 'resetchar', 'admin', function(source, args, user)
	local pname = GetPlayerName(args[1])
	local modname = GetPlayerName(source)
	TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:showRegisterIdentity', args[1], {})
	TriggerClientEvent('scarface_notify', source, '#ff0000', 'Information',  'Du hast die Identität von '.. pname ..' | ID: ' .. args[1] .. ' zurückgesetzt.')
	TriggerClientEvent('scarface_notify', args[1], '#ff0000', 'Information',  'Deine Identität wurde von '.. modname ..' zurückgesetzt.')
end, {help = "Register a new character"})

TriggerEvent('es:addGroupCommand', 'resetchar', 'superadmin', function(source, args, user)
	local pname = GetPlayerName(args[1])
	local modname = GetPlayerName(source)
	TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:showRegisterIdentity', args[1], {})
	TriggerClientEvent('scarface_notify', source, '#ff0000', 'Information', 'Du hast die Identität von '.. pname ..' | ID: ' .. args[1] .. ' zurückgesetzt.')
	TriggerClientEvent('scarface_notify', args[1], '#ff0000', 'Information', 'Deine Identität wurde von '.. modname ..' zurückgesetzt.')
end, {help = "Register a new character"})

TriggerEvent('es:addGroupCommand', 'resetallchar', 'superadmin', function(source, args, user)
	local modname = GetPlayerName(source)
	TriggerClientEvent('mikfgeamkfeamföempomaeffepmoaempofpomikemapfmepfe:showRegisterIdentity', -1, {})
	TriggerClientEvent('scarface_notify', -1, '#ff0000', 'Information', 'Es wurden alle Identitäten von ' .. modname .. ' zurückgesetzt')
end, {help = "Register a new character"})