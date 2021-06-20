Citizen.CreateThread(function()
	Citizen.Wait(5000) -- possible "Area" missing fix
	AddTextEntry("BLIP_PROPCAT", "<C>Job Related</C>") -- Category 10
	AddTextEntry("BLIP_APARTCAT", "<C>Dealership</C>") -- Category 11

	for k,v in ipairs(Config.Blips) do
		Citizen.Wait(1)
		local blip = AddBlipForCoord(v.coords)
		SetBlipSprite (blip, v.id)

		SetBlipScale(blip, v.scale or 0.7)
		SetBlipColour (blip, v.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.linkName or v.text)
		EndTextCommandSetBlipName(blip)

		if v.category then SetBlipCategory(blip, v.category) end

		if v.blipDetail then
			if not HasStreamedTextureDictLoaded("blip_textures") then
				RequestStreamedTextureDict("blip_textures")
				while not HasStreamedTextureDictLoaded("blip_textures") do Citizen.Wait(100) end
			end

			local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(v.coords.x, v.coords.y, v.coords.z))

			SetBlipInfoTitle(blip, v.title or v.text, false)

			if v.imgName then SetBlipInfoImage(blip, "blip_textures", v.imgName) end

			AddBlipInfoHeader(blip, "Area", streetName)

			if v.jType then AddBlipInfoText(blip, "Job Type", v.jType) end
			if v.owner then AddBlipInfoText(blip, "Owned By", v.owner) end

			AddBlipInfoHeader(blip, "")
			AddBlipInfoText(blip, v.description)

			if v.description2 then AddBlipInfoText(blip, v.description2) end
		end
	end
end)
