fx_version "cerulean"

lua54 "yes"

game "gta5"

client_scripts {
    "client/*.lua",
    '@oxmysql/lib/MySQL.lua',
    "src/vendors/TheRageUI/client/RMenu.lua",
    "src/vendors/TheRageUI/client/menu/RageUI.lua",
    "src/vendors/TheRageUI/client/menu/Menu.lua",
    "src/vendors/TheRageUI/client/menu/MenuController.lua",
    "src/vendors/TheRageUI/client/components/*.lua",
    "src/vendors/TheRageUI/client/menu/elements/*.lua",
    "src/vendors/TheRageUI/client/menu/items/*.lua",
    "src/vendors/TheRageUI/client/menu/panels/*.lua",
    "src/vendors/TheRageUI/client/menu/windows/*.lua",

    -- RageUI
    "src/vendors/RageUI2/client/menu.lua",
    "src/vendors/RageUI/RMenu.lua",
    "src/vendors/RageUI/menu/RageUI.lua",
    "src/vendors/RageUI/menu/Menu.lua",
    "src/vendors/RageUI/menu/MenuController.lua",
    "src/vendors/RageUI/components/*.lua",
    "src/vendors/RageUI/menu/elements/*.lua",
    "src/vendors/RageUI/menu/items/*.lua",
    "src/vendors/RageUI/menu/panels/*.lua",
    "src/vendors/RageUI/menu/windows/*.lua",

    -- SertyModuleUI
    "src/vendors/SertyModuleUI/RMenu.lua",
    "src/vendors/SertyModuleUI/menu/RageUI.lua",
    "src/vendors/SertyModuleUI/menu/Menu.lua",
    "src/vendors/SertyModuleUI/menu/MenuController.lua",
    "src/vendors/SertyModuleUI/components/*.lua",
    "src/vendors/SertyModuleUI/menu/elements/*.lua",
    "src/vendors/SertyModuleUI/menu/items/*.lua",
    "src/vendors/SertyModuleUI/menu/panels/*.lua",
    "src/vendors/SertyModuleUI/menu/windows/*.lua",

    -- Bob74
    "src/vendors/Bob74/lib/common.lua",
    "src/vendors/Bob74/lib/observers/interiorIdObserver.lua",
    "src/vendors/Bob74/lib/observers/officeSafeDoorHandler.lua",
    "src/vendors/Bob74/client.lua",

    -- GTA V
    "src/vendors/Bob74/gtav/base.lua",   -- Base IPLs to fix holes
    "src/vendors/Bob74/gtav/ammunations.lua",
    "src/vendors/Bob74/gtav/bahama.lua",
    "src/vendors/Bob74/gtav/floyd.lua",
    "src/vendors/Bob74/gtav/franklin.lua",
    "src/vendors/Bob74/gtav/franklin_aunt.lua",
    "src/vendors/Bob74/gtav/graffitis.lua",
    "src/vendors/Bob74/gtav/pillbox_hospital.lua",
    "src/vendors/Bob74/gtav/lester_factory.lua",
    "src/vendors/Bob74/gtav/michael.lua",
    "src/vendors/Bob74/gtav/north_yankton.lua",
    "src/vendors/Bob74/gtav/red_carpet.lua",
    "src/vendors/Bob74/gtav/simeon.lua",
    "src/vendors/Bob74/gtav/stripclub.lua",
    "src/vendors/Bob74/gtav/trevors_trailer.lua",
    "src/vendors/Bob74/gtav/ufo.lua",
    "src/vendors/Bob74/gtav/zancudo_gates.lua",

    -- GTA Online
    "src/vendors/Bob74/gta_online/apartment_hi_1.lua",
    "src/vendors/Bob74/gta_online/apartment_hi_2.lua",
    "src/vendors/Bob74/gta_online/house_hi_1.lua",
    "src/vendors/Bob74/gta_online/house_hi_2.lua",
    "src/vendors/Bob74/gta_online/house_hi_3.lua",
    "src/vendors/Bob74/gta_online/house_hi_4.lua",
    "src/vendors/Bob74/gta_online/house_hi_5.lua",
    "src/vendors/Bob74/gta_online/house_hi_6.lua",
    "src/vendors/Bob74/gta_online/house_hi_7.lua",
    "src/vendors/Bob74/gta_online/house_hi_8.lua",
    "src/vendors/Bob74/gta_online/house_mid_1.lua",
    "src/vendors/Bob74/gta_online/house_low_1.lua",

    -- DLC High Life
    "src/vendors/Bob74/dlc_high_life/apartment1.lua",
    "src/vendors/Bob74/dlc_high_life/apartment2.lua",
    "src/vendors/Bob74/dlc_high_life/apartment3.lua",
    "src/vendors/Bob74/dlc_high_life/apartment4.lua",
    "src/vendors/Bob74/dlc_high_life/apartment5.lua",
    "src/vendors/Bob74/dlc_high_life/apartment6.lua",

    -- DLC Heists
    "src/vendors/Bob74/dlc_heists/carrier.lua",
    "src/vendors/Bob74/dlc_heists/yacht.lua",

    -- DLC Executives & Other Criminals
    "src/vendors/Bob74/dlc_executive/apartment1.lua",
    "src/vendors/Bob74/dlc_executive/apartment2.lua",
    "src/vendors/Bob74/dlc_executive/apartment3.lua",

    -- DLC Finance & Felony
    "src/vendors/Bob74/dlc_finance/office1.lua",
    "src/vendors/Bob74/dlc_finance/office2.lua",
    "src/vendors/Bob74/dlc_finance/office3.lua",
    "src/vendors/Bob74/dlc_finance/office4.lua",
    "src/vendors/Bob74/dlc_finance/organization.lua",

    -- DLC Bikers
    "src/vendors/Bob74/dlc_bikers/cocaine.lua",
    "src/vendors/Bob74/dlc_bikers/counterfeit_cash.lua",
    "src/vendors/Bob74/dlc_bikers/document_forgery.lua",
    "src/vendors/Bob74/dlc_bikers/meth.lua",
    "src/vendors/Bob74/dlc_bikers/weed.lua",
    "src/vendors/Bob74/dlc_bikers/clubhouse1.lua",
    "src/vendors/Bob74/dlc_bikers/clubhouse2.lua",
    "src/vendors/Bob74/dlc_bikers/gang.lua",

    -- DLC Import/Export
    "src/vendors/Bob74/dlc_import/garage1.lua",
    "src/vendors/Bob74/dlc_import/garage2.lua",
    "src/vendors/Bob74/dlc_import/garage3.lua",
    "src/vendors/Bob74/dlc_import/garage4.lua",
    "src/vendors/Bob74/dlc_import/vehicle_warehouse.lua",

    -- DLC Gunrunning
    "src/vendors/Bob74/dlc_gunrunning/bunkers.lua",
    "src/vendors/Bob74/dlc_gunrunning/yacht.lua",

    -- DLC Smuggler's Run
    "src/vendors/Bob74/dlc_smuggler/hangar.lua",

    -- DLC Doomsday Heist
    "src/vendors/Bob74/dlc_doomsday/facility.lua",

    -- DLC After Hours
    "src/vendors/Bob74/dlc_afterhours/nightclubs.lua",

    -- DLC Diamond Casino (Requires forced build 2060 or higher)
    "src/vendors/Bob74/dlc_casino/casino.lua",
    "src/vendors/Bob74/dlc_casino/penthouse.lua",

    -- DLC Tuners (Requires forced build 2372 or higher)
    "src/vendors/Bob74/dlc_tuner/garage.lua",
    "src/vendors/Bob74/dlc_tuner/meetup.lua",
    "src/vendors/Bob74/dlc_tuner/methlab.lua",

    -- DLC The Contract (Requires forced build 2545 or higher)
    "src/vendors/Bob74/dlc_security/studio.lua",
    "src/vendors/Bob74/dlc_security/billboards.lua",
    "src/vendors/Bob74/dlc_security/musicrooftop.lua",
    "src/vendors/Bob74/dlc_security/garage.lua",
    "src/vendors/Bob74/dlc_security/office1.lua",
    "src/vendors/Bob74/dlc_security/office2.lua",
    "src/vendors/Bob74/dlc_security/office3.lua",
    "src/vendors/Bob74/dlc_security/office4.lua",

    -- DLC The Criminal Enterprises (Requires forced build 2699 or higher)
    "src/vendors/Bob74/gta_mpsum2/simeonfix.lua",
    "src/vendors/Bob74/gta_mpsum2/vehicle_warehouse.lua",
    "src/vendors/Bob74/gta_mpsum2/warehouse.lua",
}

server_scripts {
    "server/*.lua",
}

shared_scripts {
    "shared/*.lua",
}