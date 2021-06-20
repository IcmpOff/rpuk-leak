Citizen.CreateThread(function()
	for index, data in pairs(Config.StashHouses) do
		if Config.debug_mode then
			local blip = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, data.range)
			SetBlipHighDetail(blip, true)
			SetBlipColour(blip, 1)
			SetBlipAlpha (blip, 128)
		end
	end
	while Config.debug_mode do
		Citizen.Wait(0)
		debug_text("~b~Debug Data~s~\nGang Rank: " .. ESX.Player.GetGangRank() .. "\nGang ID: " .. ESX.Player.GetGangId() .. "\nTurf Controlled By: " .. turf_data.controlled_by .. "\nTurf Reputation: " .. turf_data.reputation)	
	end
end)

function debug_text(text)
	SetTextFont(0)
	SetTextScale(0.0, 0.55)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.80, 0.7)
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

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}
  
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end
  
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
  
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
  
function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function GetAllPeds()
    local peds = {}
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) then
            table.insert(peds, ped)
        end
    end
    return peds
end

function hasPermission(permission_string)
	local result = nil
	ESX.TriggerServerCallback('rpuk_gangs:hasPermission', function(cb_result)
		result = cb_result
	end, permission_string)
	while result == nil do
		Citizen.Wait(100)
	end
	return result
end

function check_actions()
	local ped = GetPlayerPed(player)
	local anim_data = {}
	surrender = IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) -- Surrender Standing Up Anim
	restrained = IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) -- Restrain Anim
	arrested = IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3)
	ziptied = IsEntityPlayingAnim(ped, "anim@move_m@prisoner_cuffed", "idle", 3) -- Ziptie Anim
	sedated = IsEntityPlayingAnim(ped, "dead", "dead_a", 3) -- Sedate Anim
	dead = IsEntityPlayingAnim(ped, "misslamar1dead_body", "dead_idle", 3) -- Dead Anim
	for k, v in pairs (anim_data) do 
		if v then
			return true
		end
	end
	return false
end

function playAnim(animDict, animName, duration)
	if animDict and animName and duration then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
		TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
		RemoveAnimDict(animDict)
	end
end