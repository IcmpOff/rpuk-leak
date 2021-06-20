local function print() end -- Disable debug prints
allow_defined_top = true
ignore = {'112','113','212'}

read_globals = {
	'source',
	'vector3',
	'json',
	-- Manifest
	'exports',
	'resource_manifest_version',
	'client_script',
	'client_scripts',
	'server_script',
	'server_scripts',
	'export',
	'exports',
	'server_export',
	'server_exports',
	'dependency',
	'dependencies',
	'file',
	'files',
	'resource_type',
	'map',
	'loadscreen',
	'data_file',
	'this_is_a_map',
	'loadscreen',
	'ui_page',
	-- Events
	'AddEventHandler',
	'RemoveEventHandler',
	'TriggerEvent',
	'TriggerClientEvent',
	'RegisterNetEvent',
	'TriggerServerEvent',
	'RegisterServerEvent',
	'RegisterNUICallback',
	-- Misc
	'SendNUIMessage',
	'PerformHttpRequest',
	'GetPlayerIdentifiers',
	'GetPlayers',
	Citizen = {
		fields = {
			'CreateThread',
			'Wait',
			'CreateThreadNow',
			'Await',
			'SetTimeout',
			--'InvokeNative',
			'Trace'
		}
	}
}

-- Add native defintions
do
	local file = io.popen('echo %FIVEM%\\FiveM.app\\citizen\\scripting\\lua', 'r')

	if file then
		local nativeDirectoryPath = file:read('*l')
		local nativeCount = 0
		file:close()
		print(nativeDirectoryPath)

		-- Setup enviroment
		local env = setmetatable({
			Citizen = setmetatable({},{
				__index = function() return function() end end
			}),
			rawset = function(tbl, key, val)
				nativeCount = nativeCount + 1
				table.insert(read_globals, key)
				rawset(tbl, key, val)
			end
		},{__index=_G})

		-- Try load native definitions
		for _,fileName in ipairs({
			'natives_21e43a33',
			'natives_0193d0af',
			'natives_server',
			'natives_universal'
		}) do
			local nativePath = ('%s\\%s.lua'):format(nativeDirectoryPath, fileName)
			local nativeFile = io.open(nativePath, 'r')

			if nativeFile then
				local success, msg = pcall(function()
					load(nativeFile:read('*a'), nil, nil, env)()
					print(fileName, nativeCount)
				end)

				nativeFile:close()

				if not success then
					print(('Failed to load native definition: %s'):format(fileName))
					print('	Error:', msg)
				end
			else
				print(('Failed to load native definition: %s'):format(fileName))
			end
		end

		print(('Loaded %s native definitions'):format(nativeCount))
	else
		print('Could not find the FiveM directory, is %FIVEM% set in your enviroment variable? If so close all active windows of CMD & PowerShell.')
	end
end