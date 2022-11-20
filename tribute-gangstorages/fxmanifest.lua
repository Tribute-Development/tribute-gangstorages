fx_version 'cerulean'
game 'gta5'

author 'Tribute Development'
description 'Gang Storages by Tribute Development'
version '1.0.0'

shared_scripts {
    'shared.lua'
}

client_scripts {
    'client/cl_main.lua'
}

server_scripts {
    'server/sv_main.lua'
}

dependencies {
    'qb-core'
}

exports {
    'SetState'
}

lua54 'yes'