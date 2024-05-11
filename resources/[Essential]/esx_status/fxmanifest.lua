
client_script 'ClientWolfModule.lua'
server_script 'ServerWolfModule.lua'



client_script 'ClientWolfAC.lua'
fx_version 'adamant'

game 'gta5'

description 'ESX Status'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@ClippyGeek/config.lua',
	'@ClippyGeek/client/cl_anticheat.lua',
	'config.lua',
	'client/classes/status.lua',
	'client/main.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/app.css',
	'html/scripts/app.js'
}
