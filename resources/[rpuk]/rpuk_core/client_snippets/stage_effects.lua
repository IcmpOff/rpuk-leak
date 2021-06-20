local stageEffects = {
	smoke = {
		vector3(686.25, 577.74, 129.46),
	},
	ufll = {
		fxasset = "core",
		fxname = "proj_molotov_flame",
		scale = 30.0,
		locations = {
			{location = vector3(671.49, 574.97, 129.61), handle = nil},
		},
	},
	uflr = {
		fxasset = "core",
		fxname = "proj_molotov_flame",
		scale = 30.0,
		locations = {
			{location = vector3(677.98, 572.60, 129.61), handle = nil},
		},
	},
	ufc = {
		fxasset = "core",
		fxname = "proj_molotov_flame",
		scale = 30.0,
		locations = {
			{location = vector3(682.55, 567.12, 129.61), handle = nil},
		},
	},
	ufrl = {
		fxasset = "core",
		fxname = "proj_molotov_flame",
		scale = 30.0,
		locations = {
			{location = vector3(689.67, 568.37, 129.61), handle = nil},
		},
	},
	ufrr = {
		fxasset = "core",
		fxname = "proj_molotov_flame",
		scale = 30.0,
		locations = {
			{location = vector3(694.60, 566.56, 129.61), handle = nil},
		},
	},
	lowerfire = {
		fxasset = "core",
		fxname = "proj_molotov_flame",
		scale = 25.0,
		locations = {
			{location = vector3(243.66296386719, 189.85040283203, 104.15505981445), handle = nil},
			{location = vector3(233.81665039063, 170.02490234375, 104.1873626709), handle = nil},

		},
	},
	fireworks = {
		fxasset = "scr_indep_fireworks",
		fxname = "scr_indep_firework_trailburst",
		scale = 1.0,
		locations = {
			{location = vector3(681.62, 565.19, 128.05), handle = nil},
		},
	},
}

local show = {
	{
		type = {"lowerfire"},
		hold = 2000,
		endwait = 0,
	},
	--[[{
		type = {"ufc", "uflr", "ufrl"},
		hold = 2000,
		endwait = 0,
	},
	{
		type = {"ufc", "uflr", "ufrl", "ufll", "ufrr"},
		hold = 2000,
		endwait = 0,
	},
	{
		type = {"ufc", "uflr", "ufrl", "ufll", "ufrr", "lowerfire"},
		hold = 2000,
		endwait = 0,
	},]]
}

effects = false
RegisterCommand('rpuk_stage_effects', function(source, args)
	TriggerServerEvent("rpuk_stage:effectsServer", not effects)
end, false)

RegisterNetEvent("rpuk_stage:effectsClient")
AddEventHandler("rpuk_stage:effectsClient", function(toggle)
	print(toggle)
	effects = toggle
	if effects then
		UseParticleFxAssetNextCall("core")
		smoke = StartParticleFxLoopedAtCoord("exp_grd_grenade_smoke", 685.16, 574.75, 129.46, 0.0, 0.0, 0.0, tonumber(7 / 2), 0.0, 0.0, 0.0, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if effects then
			for mindex, mdata in pairs (show) do
				for tindex, tdata in pairs(mdata.type) do
					for _, data in pairs(stageEffects[tdata].locations) do
						UseParticleFxAssetNextCall(stageEffects[tdata].fxasset)
						local handle = StartParticleFxLoopedAtCoord(stageEffects[tdata].fxname, data.location, 0.0, 0.0, 0.0, stageEffects[tdata].scale, false, false, false, false)
						data.handle = handle
					end
				end
				Citizen.Wait(mdata.hold)
				for tindex, tdata in pairs(mdata.type) do
					for _, data in pairs(stageEffects[tdata].locations) do
						StopParticleFxLooped(data.handle, 0)
					end
				end
				Citizen.Wait(mdata.endwait)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)