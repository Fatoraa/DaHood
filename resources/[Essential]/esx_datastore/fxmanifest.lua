
client_script 'ClientWolfModule.lua'
server_script 'ServerWolfModule.lua'



client_script 'ClientWolfAC.lua'
fx_version 'adamant'

game 'gta5'

description 'ESX Data Store'

version '1.0.2'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/classes/datastore.lua',
	'server/main.lua'
}
