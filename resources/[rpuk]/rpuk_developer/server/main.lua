function tprint (tbl, indent)
	if not indent then indent = 0 end
	if type(tbl) == 'table' then
		for k, v in pairs(tbl) do
			local formatting = string.rep("  ", indent) .. k .. ": "
			if type(v) == "table" then
				print(formatting)
				tprint(v, indent+1)
			elseif type(v) == 'boolean' then
				print(formatting .. tostring(v))
			else
				print(formatting .. v)
			end
		end
	else
		print(tbl)
	end
end

RegisterNetEvent('rpuk:debug')
AddEventHandler('rpuk:debug', function(value)
	tprint(value)
end)