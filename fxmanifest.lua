fx_version 'adamant'
games { 'gta5' }

description 'ESX New MoneyWash'
version '0.1.0'
author 'kleinkiko'

shared_script '@es_extended/imports.lua'

client_scripts {

	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/de.lua',
	'config.lua',
	'client/main.lua',

}

server_scripts {

	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/de.lua',
	'config.lua',
	'server/main.lua',
	'version.lua'

}

dependencies {

    'es_extended',

}