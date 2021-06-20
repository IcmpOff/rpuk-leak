function inPolyZone(polyName)
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	for k,v in pairs(PolyZones) do
		if k == polyName then
			if v:isPointInside(pedCoords) then
				return true
			end
		end
	end
end

PolyZones = {
	Pillbox = CircleZone:Create(vector3(318.41, -582.14, 28.88), 88.5, {
		useZ=true,
		-- debugPoly=true
	}),

	Prison = CircleZone:Create(vector3(1691.07, 2604.95, 45.56), 240.0, {
		name="Prison",
		useZ=false,
		debugPoly=false
	}),

	cleaningPoints2 = BoxZone:Create(vector3(1632.84, 2548.99, 45.56), 5, 11.0, {
		name="more tables",
		heading=45
	}),

	cleaningPoints = PolyZone:Create({
		vector2(1774.4240722656, 2586.90625),
		vector2(1783.5411376953, 2587.6252441406),
		vector2(1784.5772705078, 2575.9541015625),
		vector2(1774.4639892578, 2576.3024902344)
		}, {
		name="cleaning",
		--minZ = 45.797950744629,
		--maxZ = 45.797958374023
		debugPoly = false
	}),

	sink = BoxZone:Create(vector3(1775.69, 2598.61, 45.8), 5, 1.4, {
		name="sink",
		heading=0,
		--debugPoly=true,
		minZ=43.0,
		maxZ=47.0
	}),

	stock = BoxZone:Create(vector3(1772.6, 2620.22, 50.55), 5, 15.0, {
		name="stock",
		heading=0,
		--debugPoly=true,
		minZ=47.35,
		maxZ=52.15
	}),

	searchPoint = BoxZone:Create(vector3(1768.35, 2571.73, 50.55), 2, 1.2, {
		name="searchp",
		heading=90,
		--debugPoly=true,
		minZ=47.55,
		maxZ=51.55
	}),

	searchPoint2 = BoxZone:Create(vector3(1765.91, 2589.25, 45.8), 2, 1.6, {
		name="container1",
		heading=40,
		--debugPoly=true,
		minZ=42.4,
		maxZ=46.4
	}),

	searchPoint3 = BoxZone:Create(vector3(1762.19, 2591.73, 45.8), 2, 2.2, {
		name="container2",
		heading=180,
		--debugPoly=true,
		minZ=42.6,
		maxZ=46.6
	}),

	phoneBooth = BoxZone:Create(vector3(1779.63, 2572.44, 45.8), 7.6, 2.0, {
		name="phonebooth",
		heading=90,
		--debugPoly=true,
		minZ=42.6,
		maxZ=46.6
	}),

	computer = CircleZone:Create(vector3(1779.3, 2591.63, 50.55), 4.5, {
		name="computer",
		useZ=true,
		--debugPoly=true
	}),

	clothes = BoxZone:Create(vector3(1833.62, 2584.58, 45.95), 1.4, 6.6, {
		name="clothes",
		heading=0,
		--debugPoly=true,
		minZ=43.15,
		maxZ=47.15
	}),

	collection = BoxZone:Create(vector3(1838.5, 2590.57, 45.95), 2.8, 1.4, {
		name="prison collection",
		heading=0,
		--debugPoly=true,
		minZ=43.35,
		maxZ=47.35
	}),

	DogZoneV = PolyZone:Create({
		vector2(-1052.4744873047, -834.19958496094),
		vector2(-1043.6459960938, -826.77435302734),
		vector2(-1039.0267333984, -831.61383056641),
		vector2(-1045.8342285156, -838.95098876953)
	}, {
		--minZ = 10.841857910156,
		--maxZ = 10.886842727661
	}),

	DogZoneMRPD = BoxZone:Create(vector3(463.31, -1017.05, 28.1), 8.8, 6.0, {
		heading=0,
		--debugPoly=true,
		minZ=25.9,
		maxZ=29.9
	})

}