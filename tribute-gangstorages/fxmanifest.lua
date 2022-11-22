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

ui_page 'html/index.html'

files {
    'html/app.js',
    'html/style.css',
    'html/index.html'
}

dependencies {
    'qb-core'
}

exports {
    'SetState'
}

escrow_ignore 'shared.lua'

lua54 'yes'