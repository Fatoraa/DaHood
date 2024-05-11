
 fx_version 'adamant'

lua54 'yes'

game 'gta5'

version 'legacy'

shared_scripts {
'async/async.lua',
'billing/config.lua',
'@es_extended/imports.lua',
'esx_skin/config.lua',
'pSociety/sh_*.lua',
}

loadscreen_manual_shutdown 'yes'
loadscreen 'load/loading.html'

server_scripts {
	'@es_extended/locale.lua',
	'@es_extended/imports.lua',
	'@mysql-async/lib/MySQL.lua',
	'SERVER_FILES/server.lua',
	"mapmanager/mapmanager_shared.lua",
    'esx_skin/locales/de.lua',
	'esx_skin/locales/br.lua',
	'esx_skin/locales/en.lua',
	'esx_skin/locales/fr.lua',
    'instance/locales/br.lua',
	'instance/locales/en.lua',
	'instance/locales/fr.lua',
	'instance/locales/sv.lua',
	'instance/locales/pl.lua',
	'instance/config.lua',
	'instance/server/main.lua',
    'pSociety/sv_*.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'basicneeds/client.lua',
	'service/client.lua',
	"mapmanager/mapmanager_shared.lua",
    "mapmanager/mapmanager_client.lua",
	'sessionmanager/client/empty.lua',
	'scripts/client.lua',
	'billing/main.lua',
    'esx_skin/locales/de.lua',
	'esx_skin/locales/br.lua',
	'esx_skin/locales/en.lua',
	'esx_skin/locales/fr.lua',
	'esx_skin/client/main.lua',
    'skinchanger/locale.lua',
	'skinchanger/locales/br.lua',
	'skinchanger/locales/de.lua',
	'skinchanger/locales/en.lua',
	'skinchanger/locales/es.lua',
	'skinchanger/locales/fi.lua',
	'skinchanger/locales/fr.lua',
	'skinchanger/locales/pl.lua',
	'skinchanger/locales/sv.lua',
	'skinchanger/locales/tr.lua',
    'skinchanger/config.lua',
	'skinchanger/client/main.lua',
    'instance/locales/br.lua',
	'instance/locales/en.lua',
	'instance/locales/fr.lua',
	'instance/locales/sv.lua',
	'instance/locales/pl.lua',
	'instance/config.lua',
	'instance/client/main.lua',

    "pSociety/src/RMenu.lua",
    "pSociety/src/menu/RageUI.lua",
    "pSociety/src/menu/Menu.lua",
    "pSociety/src/menu/MenuController.lua",
    "pSociety/src/components/*.lua",
    "pSociety/src/menu/elements/*.lua",
    "pSociety/src/menu/items/*.lua",
    "pSociety/src/menu/panels/*.lua",
    "pSociety/src/menu/panels/*.lua",
    "pSociety/src/menu/windows/*.lua",
    "pSociety/cl_*.lua",
    "load/client/main.lua",
}

dependency 'es_extended'


rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"
server_export "roundEnded"

export 'getRandomSpawnPoint'
export 'spawnPlayer'
export 'addSpawnPoint'
export 'removeSpawnPoint'
export 'loadSpawns'
export 'setAutoSpawn'
export 'setAutoSpawnCallback'
export 'forceRespawn'


client_scripts {
    "bob74_ipl/lib/common.lua"
    , "bob74_ipl/lib/observers/interiorIdObserver.lua"
    , "bob74_ipl/lib/observers/officeSafeDoorHandler.lua"
    , "bob74_ipl/client.lua"

    -- GTA V
    , "bob74_ipl/gtav/base.lua"   -- Base IPLs to fix holes
    , "bob74_ipl/gtav/ammunations.lua"
    , "bob74_ipl/gtav/bahama.lua"
    , "bob74_ipl/gtav/floyd.lua"
    , "bob74_ipl/gtav/franklin.lua"
    , "bob74_ipl/gtav/franklin_aunt.lua"
    , "bob74_ipl/gtav/graffitis.lua"
    , "bob74_ipl/gtav/pillbox_hospital.lua"
    , "bob74_ipl/gtav/lester_factory.lua"
    , "bob74_ipl/gtav/michael.lua"
    , "bob74_ipl/gtav/north_yankton.lua"
    , "bob74_ipl/gtav/red_carpet.lua"
    , "bob74_ipl/gtav/simeon.lua"
    , "bob74_ipl/gtav/stripclub.lua"
    , "bob74_ipl/gtav/trevors_trailer.lua"
    , "bob74_ipl/gtav/ufo.lua"
    , "bob74_ipl/gtav/zancudo_gates.lua"

    -- GTA Online
    , "bob74_ipl/gta_online/apartment_hi_1.lua"
    , "bob74_ipl/gta_online/apartment_hi_2.lua"
    , "bob74_ipl/gta_online/house_hi_1.lua"
    , "bob74_ipl/gta_online/house_hi_2.lua"
    , "bob74_ipl/gta_online/house_hi_3.lua"
    , "bob74_ipl/gta_online/house_hi_4.lua"
    , "bob74_ipl/gta_online/house_hi_5.lua"
    , "bob74_ipl/gta_online/house_hi_6.lua"
    , "bob74_ipl/gta_online/house_hi_7.lua"
    , "bob74_ipl/gta_online/house_hi_8.lua"
    , "bob74_ipl/gta_online/house_mid_1.lua"
    , "bob74_ipl/gta_online/house_low_1.lua"

    -- DLC High Life
    , "bob74_ipl/dlc_high_life/apartment1.lua"
    , "bob74_ipl/dlc_high_life/apartment2.lua"
    , "bob74_ipl/dlc_high_life/apartment3.lua"
    , "bob74_ipl/dlc_high_life/apartment4.lua"
    , "bob74_ipl/dlc_high_life/apartment5.lua"
    , "bob74_ipl/dlc_high_life/apartment6.lua"

    -- DLC Heists
    , "bob74_ipl/dlc_heists/carrier.lua"
    , "bob74_ipl/dlc_heists/yacht.lua"

    -- DLC Executives & Other Criminals
    , "bob74_ipl/dlc_executive/apartment1.lua"
    , "bob74_ipl/dlc_executive/apartment2.lua"
    , "bob74_ipl/dlc_executive/apartment3.lua"

    -- DLC Finance & Felony
    , "bob74_ipl/dlc_finance/office1.lua"
    , "bob74_ipl/dlc_finance/office2.lua"
    , "bob74_ipl/dlc_finance/office3.lua"
    , "bob74_ipl/dlc_finance/office4.lua"
    , "bob74_ipl/dlc_finance/organization.lua"

    -- DLC Bikers
    , "bob74_ipl/dlc_bikers/cocaine.lua"
    , "bob74_ipl/dlc_bikers/counterfeit_cash.lua"
    , "bob74_ipl/dlc_bikers/document_forgery.lua"
    , "bob74_ipl/dlc_bikers/meth.lua"
    , "bob74_ipl/dlc_bikers/weed.lua"
    , "bob74_ipl/dlc_bikers/clubhouse1.lua"
    , "bob74_ipl/dlc_bikers/clubhouse2.lua"
    , "bob74_ipl/dlc_bikers/gang.lua"

    -- DLC Import/Export
    , "bob74_ipl/dlc_import/garage1.lua"
    , "bob74_ipl/dlc_import/garage2.lua"
    , "bob74_ipl/dlc_import/garage3.lua"
    , "bob74_ipl/dlc_import/garage4.lua"
    , "bob74_ipl/dlc_import/vehicle_warehouse.lua"

    -- DLC Gunrunning
    , "bob74_ipl/dlc_gunrunning/bunkers.lua"
    , "bob74_ipl/dlc_gunrunning/yacht.lua"

    -- DLC Smuggler's Run
    , "bob74_ipl/dlc_smuggler/hangar.lua"

    -- DLC Doomsday Heist
    , "bob74_ipl/dlc_doomsday/facility.lua"

    -- DLC After Hours
    , "bob74_ipl/dlc_afterhours/nightclubs.lua"

    -- DLC Diamond Casino (Requires forced build 2060 or higher)
    , "bob74_ipl/dlc_casino/penthouse.lua"
    , "bob74_ipl/dlc_casino/casino.lua"

    -- DLC Tuners (Requires forced build 2372 or higher)
    , "bob74_ipl/dlc_tuner/garage.lua"
    , "bob74_ipl/dlc_tuner/meetup.lua"
    , "bob74_ipl/dlc_tuner/methlab.lua"

    -- DLC The Contract (Requires forced build 2545 or higher)
    , "bob74_ipl/dlc_security/studio.lua"
    , "bob74_ipl/dlc_security/billboards.lua"
    , "bob74_ipl/dlc_security/musicrooftop.lua"
    , "bob74_ipl/dlc_security/garage.lua"
    , "bob74_ipl/dlc_security/office1.lua"
    , "bob74_ipl/dlc_security/office2.lua"
    , "bob74_ipl/dlc_security/office3.lua"
    , "bob74_ipl/dlc_security/office4.lua"

    -- DLC The Criminal Enterprises (Requires forced build 2699 or higher)
    , "bob74_ipl/gta_mpsum2/simeonfix.lua"
    , "bob74_ipl/gta_mpsum2/vehicle_warehouse.lua"
    , "bob74_ipl/gta_mpsum2/warehouse.lua"
}


files {
	"load/css/font.css",
    "load/css/plugins.css",
    "load/css/style.css",
    "load/js/music-controls.js",
    "load/js/music-handler.js",
    "load/vid/video.mp4",
    "load/webfonts/BAUHS93.eot",
    "load/webfonts/BAUHS93.ttf",
    "load/webfonts/BAUHS93.woff",
    "load/webfonts/HARLOWSI_1.TTF",
    "load/audio.mp3",
    "load/loading.html",
    "load/png.png"
}

