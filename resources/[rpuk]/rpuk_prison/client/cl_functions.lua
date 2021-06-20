--- Anti Air (No flyzone)


prisonDrain = CircleZone:Create(vector3(1691.07, 2604.95, 45.56), 240.0, {
	name="Prison Drain Fuel",
	useZ=false,
	--debugPoly=true
})

prisonMessage = CircleZone:Create(vector3(1691.07, 2604.95, 45.56), 750.0, {
	name="Prison Message",
	useZ=false,
	--debugPoly=true
})


airfield = CircleZone:Create(vector3(-2293.62, 3030.35, 32.81), 520.0, {
	useZ=true,
	--debugPoly=true
})

airfieldMessage = CircleZone:Create(vector3(-2261.08, 3013.23, 32.81), 900.0, {
	useZ=false,
	--debugPoly=true
})





-------------------
















cleaningPoints = PolyZone:Create({
	vector2(1774.4240722656, 2586.90625),
	vector2(1783.5411376953, 2587.6252441406),
	vector2(1784.5772705078, 2575.9541015625),
	vector2(1774.4639892578, 2576.3024902344)
	}, {
	name="cleaning",
	--minZ = 45.797950744629,
	--maxZ = 45.797958374023
})

cleaningPoints2 = BoxZone:Create(vector3(1632.84, 2548.99, 45.56), 5, 11.0, {
	name="more tables",
	heading=45,
})

sink = BoxZone:Create(vector3(1775.69, 2598.61, 45.8), 5, 1.4, {
	name="sink",
	heading=0,
	--debugPoly=true,
	minZ=43.0,
	maxZ=47.0
})

stock = BoxZone:Create(vector3(1772.6, 2620.22, 50.55), 5, 15.0, {
	name="stock",
	heading=0,
	--debugPoly=true,
	minZ=47.35,
	maxZ=52.15
})

searchPoint = BoxZone:Create(vector3(1768.35, 2571.73, 50.55), 2, 1.2, {
	name="searchp",
	heading=90,
	--debugPoly=true,
	minZ=47.55,
	maxZ=51.55
})

searchPoint2 = BoxZone:Create(vector3(1765.91, 2589.25, 45.8), 2, 1.6, {
	name="container1",
	heading=40,
	--debugPoly=true,
	minZ=42.4,
	maxZ=46.4
})

searchPoint3 = BoxZone:Create(vector3(1762.19, 2591.73, 45.8), 2, 2.2, {
	name="container2",
	heading=180,
	--debugPoly=true,
	minZ=42.6,
	maxZ=46.6
})

phoneBooth = BoxZone:Create(vector3(1779.63, 2572.44, 45.8), 7.6, 2.0, {
	name="phonebooth",
	heading=90,
	--debugPoly=true,
	minZ=42.6,
	maxZ=46.6
})

computer = CircleZone:Create(vector3(1779.3, 2591.63, 50.55), 4.5, {
	name="computer",
	useZ=true,
	--debugPoly=true
})

clothes = BoxZone:Create(vector3(1833.62, 2584.58, 45.95), 1.4, 6.6, {
	name="clothes",
	heading=0,
	--debugPoly=true,
	minZ=43.15,
	maxZ=47.15
})

collection = BoxZone:Create(vector3(1838.5, 2590.57, 45.95), 2.8, 1.4, {
	name="5",
	heading=0,
	--debugPoly=true,
	minZ=43.35,
	maxZ=47.35
})


function capEachFirst(str)
	str = string.lower(str)
	str = string.gsub(" "..str, "%W%l", string.upper):sub(2)
	return str
end

function LoadAnim(animDict)
	RequestAnimDict(animDict)

	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)

	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end

function LoadScaleform(scaleform)
	local text = RequestScaleformMovie(scaleform)
	if text ~= 0 then
		while not HasScaleformMovieLoaded(text) do
			Citizen.Wait(0)
		end
	end
	return text
end

function CreateNamedRenderTargetForModel(name, model)
	local text = 0
	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0)
	end
	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end
	if IsNamedRendertargetRegistered(name) then
		text = GetNamedRendertargetRenderId(name)
	end
	return text
end

function spawnCamera()
	local camOptions = config.postions.cameraPostion

	camOptions.cameraId = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

	SetCamCoord(camOptions.cameraId, camOptions.x, camOptions.y, camOptions.z)
	SetCamRot(camOptions.cameraId, camOptions.rotationX, camOptions.rotationY, camOptions.rotationZ)

	RenderScriptCams(true, false, 0, true, true)
end


function isInList(val, list)
	for k,v in pairs(list) do
		if val == v then
			return true
		end
	end
	return false
end