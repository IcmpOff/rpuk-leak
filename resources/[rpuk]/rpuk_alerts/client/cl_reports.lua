VespucciPD = CircleZone:Create(vector3(-1067.899, -858.626, 3.868), 200.0, {
	useZ=true,
	debugPoly=false
})

MissionRow = CircleZone:Create(vector3(449.642, -985.641, 29.690), 60.0, {
	useZ=true,
	debugPoly=false
})

LegionSquare = CircleZone:Create(vector3(198.381, -920.297, 29.693), 200.0, {
	useZ=true,
	debugPoly=false
})

PillboxHospital = CircleZone:Create(vector3(300.201, -585.012, 42.284), 100.0, {
	useZ=true,
	debugPoly=false
})

CityHall = CircleZone:Create(vector3(-545.079, -204.129, 37.221), 200.0, {
	useZ=true,
	debugPoly=false
})

LSMDCenter = CircleZone:Create(vector3(307.556, -1378.160, 30.827), 120.0, {
	useZ=true,
	debugPoly=false
})

SandyShores = CircleZone:Create(vector3(1846.349, 3674.830, 32.723), 75.0, {
	useZ=true,
	debugPoly=false
})

LSAirport = CircleZone:Create(vector3(-1043.878, -2919.831, 12.953), 200.0, {
	useZ=true,
	debugPoly=false
})

local isCounting = false
local bulletCount = 0

function startCounter()
	Citizen.CreateThreadNow(function()
		local time = 0
		while time < 10 and isCounting do
			Citizen.Wait(1000)
			time = time+1
		end
		bulletCount = 0
		isCounting = false
	end)
end

function GetClosestNpc(x, y, z, r)
	local coords = vector3(x, y, z)
	local ped, pedDist = ESX.Game.GetClosestPed(coords)
	if pedDist <= r and not IsPedDeadOrDying(ped) then
		local pt = GetPedType(ped)
		if pt ~= 0 and pt ~= 1 and pt ~= 2 and pt ~= 28  then
			return ped, pt
		else
			return false, nil
		end
	else
		return false, nil
	end
end

function weaponCrimeLocationCheck()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local silenced = IsPedCurrentWeaponSilenced(ped)
	local chance = 0
	local job = ESX.Player.GetJobName()
	local authJob = (job == "police" or job == "gruppe6")

	if silenced then chance = chance-20 end
	if VespucciPD:isPointInside(coords) or MissionRow:isPointInside(coords) or LegionSquare:isPointInside(coords) or PillboxHospital:isPointInside(coords) or 
	CityHall:isPointInside(coords) or LSMDCenter:isPointInside(coords) or SandyShores:isPointInside(coords) or LSAirport:isPointInside(coords) then
		chance = chance + 70
	end

	if authJob then chance = 0 bulletCount = 0 isCounting = false end
	return chance
end

function CheckGender()
	local hashSkinMale = GetHashKey("mp_m_freemode_01")
	local hashSkinFemale = GetHashKey("mp_f_freemode_01")
	local PlayerGender = "Unknown"
	local ped = PlayerPedId()

	if GetEntityModel(ped) == hashSkinMale then
		PlayerGender = "IC9 Male"
	elseif GetEntityModel(ped) == hashSkinFemale then
		PlayerGender = "IC9 Female"
	end
	return PlayerGender
end

Citizen.CreateThread(function()
	while true do
		Wait(1)
		local ped = PlayerPedId()
		local pedShooting = IsPedShooting(ped)
		local pedStabbing = IsPedInMeleeCombat(ped)
		if pedShooting then
			if GetSelectedPedWeapon(ped) == `WEAPON_PETROLCAN` or GetSelectedPedWeapon(ped) == `WEAPON_SNOWBALL` or GetSelectedPedWeapon(ped) == `WEAPON_STUNGUN` then return end
			if not isCounting then
				isCounting = true
				startCounter()
			end
			bulletCount = bulletCount+1
			if bulletCount >= 5 then
				if 100 * math.random() < weaponCrimeLocationCheck() then
					print("SENDING")
					TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "shooting", gender = CheckGender() })
					bulletCount = 0
					isCounting = false
				end
			end
		end
	end
end)