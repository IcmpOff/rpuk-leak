local Charset = {}

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

ESX.GetRandomString = function(length)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

ESX.GetConfig = function()
	return Config
end

ESX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)

	return Config.Weapons[weaponName]
end

ESX.GetWeaponFromHash = function(weaponHash)
	for k,v in pairs(Config.Weapons) do
		if GetHashKey(v.name) == weaponHash then
			return v
		end
	end
end

ESX.GetWeaponList = function()
	return Config.Weapons
end

ESX.GetWeaponLabel = function(weaponName)
	if not weaponName then
		return "Unidentified"
	end
	weaponName = string.upper(weaponName)

	return Config.Weapons[weaponName].label
end

ESX.GetAmmo = function(ammoType)
	if ammoType then
		return Config.ammoTypes[ammoType]
	else
		return Config.ammoTypes
	end
end

ESX.GetAmmoLabel = function(ammoType)
	return Config.ammoTypes[ammoType].label
end

ESX.GetWeaponAmmoType = function(weaponHash)
	weaponHash = string.upper(weaponHash)

	return Config.Weapons[weaponHash]
end

ESX.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	local weapons = Config.Weapons

	for k,v in pairs(Config.Weapons[weaponName].components) do
		if v.name == weaponComponent then
			return v
		end
	end
end

ESX.SecondsToClock = function(seconds)
	seconds = tonumber(seconds) or 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

ESX.DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. ESX.DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

ESX.deepCopy = function(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[ESX.deepCopy(orig_key)] = ESX.deepCopy(orig_value)
		end
		setmetatable(copy, ESX.deepCopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

ESX.getAccountLabel = function(account) return _U("account_"..account) end
ESX.getLocalWeight = function() return Config.defaultWeight, Config.localWeight end

ESX.GetSkill = function(skill)
	if skill then
		return Config.skill[skill]
	else
		return Config.skill
	end
end

ESX.GetSkillLabel = function(skill)
	if Config.skill[skill] then
		return Config.skill[skill].label
	else
		return "UNDEFINED"
	end
end

ESX.GetMaxSkill = function(skill)
	if Config.skill[skill] then
		return Config.skill[skill].skill
	else
		return 0
	end
end