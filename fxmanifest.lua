fx_version 'cerulean'

game 'gta5'

name 'Flip-car'

repository 'https://github.com/ItsFlurix/Flip-car'

version '1.0.0'

author 'ItsFlurix'

lua54 'yes'

client_script 'client.lua'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts {
    'check_update.lua',
}
