
client_script 'ClientWolfModule.lua'
server_script 'ServerWolfModule.lua'



client_script 'ClientWolfAC.lua'
fx_version 'adamant'

game 'gta5'

description 'ESX RP Chat'
lua54 'yes'
version '1.8.5'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'
