local cam = -1							-- Camera control
local heading = 332.219879				-- Heading coord
local zoom = "visage"					-- Define which tab is shown first (Default: Head)
local isCameraActive
local PrevHat,PrevGlasses, PrevEars, PrevGender, PrevMask
local face

local HasAlreadyEnteredMarker = false
local LastPad = nil
local LastAction = nil
local LastPadData = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = nil

------------------------------------------------------------------
--                          NUI
------------------------------------------------------------------

RegisterNUICallback('updateSkin', function(data)
	local playerPed = PlayerPedId()
	v = data.value
	-- Face
	dad = tonumber(data.dad)
	mum = tonumber(data.mum)
	gender = tonumber(data.gender)
	dadmumpercent = tonumber(data.dadmumpercent)
	skin = tonumber(data.skin)
	eyecolor = tonumber(data.eyecolor)
	acne = tonumber(data.acne)
	skinproblem = tonumber(data.skinproblem)
	freckle = tonumber(data.freckle)
	wrinkle = tonumber(data.wrinkle)
	wrinkleopacity = tonumber(data.wrinkleopacity)
	hair = tonumber(data.hair)
	haircolor = tonumber(data.haircolor)
	eyebrow = tonumber(data.eyebrow)
	eyebrowopacity = tonumber(data.eyebrowopacity)
	beard = tonumber(data.beard)
	beardopacity = tonumber(data.beardopacity)
	beardcolor = tonumber(data.beardcolor)

	--Clothes
	hats = tonumber(data.hats)
	hats_texture = tonumber(data.hats_texture)
	glasses = tonumber(data.glasses)
	glasses_texture = tonumber(data.glasses_texture)
	mask = tonumber(data.mask)
	mask_texture = tonumber(data.mask_texture)
	ears = tonumber(data.ears)
	ears_texture = tonumber(data.ears_texture)
	tops = tonumber(data.tops)
	pants = tonumber(data.pants)
	shoes = tonumber(data.shoes)
	watches = tonumber(data.watches)

	if(v == true) then
		local ped = PlayerPedId()
		local torso = GetPedDrawableVariation(ped, 3)
		local torsotext = GetPedTextureVariation(ped, 3)
		local leg = GetPedDrawableVariation(ped, 4)
		local legtext = GetPedTextureVariation(ped, 4)
		local shoes = GetPedDrawableVariation(ped, 6)
		local shoestext = GetPedTextureVariation(ped, 6)
		local accessory = GetPedDrawableVariation(ped, 7)
		local accessorytext = GetPedTextureVariation(ped, 7)
		local undershirt = GetPedDrawableVariation(ped, 8)
		local undershirttext = GetPedTextureVariation(ped, 8)
		local torso2 = GetPedDrawableVariation(ped, 11)
		local torso2text = GetPedTextureVariation(ped, 11)
		local prop_hat = GetPedPropIndex(ped, 0)
		local prop_hat_text = GetPedPropTextureIndex(ped, 0)
		local prop_glasses = GetPedPropIndex(ped, 1)
		local prop_glasses_text = GetPedPropTextureIndex(ped, 1)
		local prop_earrings = GetPedPropIndex(ped, 2)
		local prop_earrings_text = GetPedPropTextureIndex(ped, 2)
		local prop_watches = GetPedPropIndex(ped, 6)
		local prop_watches_text = GetPedPropTextureIndex(ped, 6)


		TriggerEvent('rpuk_skin:save')
		CloseSkinCreator()
	else

	TriggerEvent('skinchanger:getSkin', function(OldComponentsLoader)
		TriggerEvent('skinchanger:change', 'sex', OldComponentsLoader.sex)
		gender = OldComponentsLoader.sex
	end)
		-- Clothes variations
		if PrevHat ~= hats then
			PrevHat = hats
			hats_texture = 0
			local maxHat
			if hats == 0 then
				maxHat = 0
			else
				maxHat = GetNumberOfPedPropTextureVariations (PlayerPedId(), 0, hats) - 1
			end
			SendNUIMessage({
				type = "updateMaxVal",
				classname = "helmet_2",
				defaultVal = 0,
				maxVal = maxHat
			})
		end

		if hats == 0 then
			ClearPedProp(PlayerPedId(), 0)
		else
			SetPedPropIndex(PlayerPedId(), 0, hats, hats_texture, 2)
		end

		if PrevGlasses ~= glasses then
			PrevGlasses = glasses
			glasses_texture = 0
			local maxGlasses
			if glasses == 0 then maxGlasses = 0
			else maxGlasses = GetNumberOfPedPropTextureVariations	(PlayerPedId(), 1, glasses - 1)
			end
			SendNUIMessage({
				type = "updateMaxVal",
				classname = "glasses_2",
				defaultVal = 0,
				maxVal = maxGlasses
			})
		end

		if glasses == 0 then
			ClearPedProp(PlayerPedId(), 1)
		else
			SetPedPropIndex(PlayerPedId(), 1, glasses, glasses_texture, 2)--Glasses
		end

		if PrevMask ~= mask then
			PrevMask = mask
			mask_texture = 0
			local maxGlasses
			if mask == 0 then maxGlasses = 0
			else maxGlasses = GetNumberOfPedDrawableVariations(PlayerPedId(), 1, mask)
			end
			SendNUIMessage({
				type = "updateMaxVal",
				classname = "mask_2",
				defaultVal = 0,
				maxVal = 12
			})
		end

		if mask == 0 then
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
		else
			SetPedComponentVariation(PlayerPedId(), 1, mask, mask_texture, 2)
		end

		if PrevEars ~= ears then
			PrevEars = ears
			ears_texture = 0
			local maxEars
			if ears == 0 then maxEars = 0
			else maxEars = GetNumberOfPedPropTextureVariations	(PlayerPedId(), 1, ears - 1)
			end
			SendNUIMessage({
				type = "updateMaxVal",
				classname = "ears_2",
				defaultVal = 0,
				maxVal = maxEars
			})
		end
		if ears == 0 then		ClearPedProp(PlayerPedId(), 2)
		else
			SetPedPropIndex(PlayerPedId(), 2, ears, ears_texture, 2)
		end

		if gender == 0 then
			if tops == 0 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 2) 	-- Torso 2
			elseif tops == 1 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 0, 1, 2) 	-- Torso 2
			elseif tops == 2 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 0, 7, 2) 	-- Torso 2
			elseif tops == 3 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 2, 9, 2) 	-- Torso 2
			elseif tops == 4 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 3, 11, 2) 	-- Torso 2
			elseif tops == 5 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 3, 15, 2) 	-- Torso 2
			elseif tops == 6 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 4, 0, 2) 	-- Torso 2
			elseif tops == 7 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 4, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 4, 0, 2) 	-- Torso 2
			elseif tops == 8 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 26, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 4, 0, 2) 	-- Torso 2
			elseif tops == 9 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 5, 0, 2) 	-- Torso 2
			elseif tops == 10 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 2, 4, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 6, 11, 2) 	-- Torso 2
			elseif tops == 11 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 2, 4, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 6, 0, 2) 	-- Torso 2
			elseif tops == 12 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 2, 4, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 6, 3, 2) 	-- Torso 2
			elseif tops == 13 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 7, 4, 2) 	-- Torso 2
			elseif tops == 14 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 7, 10, 2) 	-- Torso 2
			elseif tops == 15 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 7, 12, 2) 	-- Torso 2
			elseif tops == 16 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 7, 13, 2) 	-- Torso 2
			elseif tops == 17 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 9, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 9, 0, 2) 	-- Torso 2
			elseif tops == 18 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
			elseif tops == 19 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 12, 2, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
			elseif tops == 20 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 18, 0, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
			elseif tops == 21 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 11, 2, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso 2
			elseif tops == 22 then
				SetPedComponentVariation(PlayerPedId(), 3, 12, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 12, 10, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 12, 10, 2) 	-- Torso 2
			elseif tops == 23 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 13, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 13, 0, 2) 	-- Torso 2
			elseif tops == 24 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 14, 0, 2) 	-- Torso 2
			elseif tops == 25 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 14, 1, 2) 	-- Torso 2
			elseif tops == 26 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 16, 0, 2) 	-- Torso 2
			elseif tops == 27 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 16, 1, 2) 	-- Torso 2
			elseif tops == 28 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 16, 2, 2) 	-- Torso 2
			elseif tops == 29 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 17, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 17, 0, 2) 	-- Torso 2
			elseif tops == 30 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 17, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 17, 1, 2) 	-- Torso 2
			elseif tops == 31 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 17, 4, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 17, 4, 2) 	-- Torso 2
			elseif tops == 32 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 27, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 26, 0, 2) 	-- Torso 2
			elseif tops == 33 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 27, 5, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 26, 5, 2) 	-- Torso 2
			elseif tops == 34 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 27, 6, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 26, 6, 2) 	-- Torso 2
			elseif tops == 35 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 63, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 31, 0, 2) 	-- Torso 2
			elseif tops == 36 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 57, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 36, 4, 2) 	-- Torso 2
			elseif tops == 37 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 57, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 36, 5, 2) 	-- Torso 2
			elseif tops == 38 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 37, 0, 2) 	-- Torso 2
			elseif tops == 39 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 37, 1, 2) 	-- Torso 2
			elseif tops == 40 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 24, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 37, 2, 2) 	-- Torso 2
			elseif tops == 41 then
				SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 38, 0, 2) 	-- Torso 2
			elseif tops == 42 then
				SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 38, 3, 2) 	-- Torso 2
			elseif tops == 43 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 39, 0, 2) 	-- Torso 2
			elseif tops == 44 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 39, 1, 2) 	-- Torso 2
			elseif tops == 45 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 41, 0, 2) 	-- Torso 2
			elseif tops == 46 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 42, 0, 2) 	-- Torso 2
			elseif tops == 47 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 50, 0, 2) 	-- Torso 2
			elseif tops == 48 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 51, 0, 2) 	-- Torso 2
			elseif tops == 49 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 51, 1, 2) 	-- Torso 2
			elseif tops == 50 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 57, 0, 2) 	-- Torso 2
			elseif tops == 51 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 70, 0, 2) 	-- Torso 2
			elseif tops == 52 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 70, 1, 2) 	-- Torso 2
			elseif tops == 53 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 70, 7, 2) 	-- Torso 2
			elseif tops == 54 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 3, 1, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 72, 1, 2) 	-- Torso 2
			elseif tops == 55 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 87, 0, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 74, 0, 2) 	-- Torso 2
			elseif tops == 56 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 12, 2, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 28, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 77, 0, 2) 	-- Torso 2
			elseif tops == 57 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 79, 0, 2) 	-- Torso 2
			elseif tops == 58 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 80, 0, 2) 	-- Torso 2
			elseif tops == 59 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 80, 1, 2) 	-- Torso 2
			elseif tops == 60 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 82, 5, 2) 	-- Torso 2
			elseif tops == 61 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 82, 8, 2) 	-- Torso 2
			elseif tops == 62 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 82, 9, 2) 	-- Torso 2
			elseif tops == 63 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 86, 0, 2) 	-- Torso 2
			elseif tops == 64 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 86, 2, 2) 	-- Torso 2
			elseif tops == 65 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 86, 4, 2) 	-- Torso 2
			elseif tops == 66 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 67 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 68 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 69 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 2, 2) 	-- Torso 2
			elseif tops == 70 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 4, 2) 	-- Torso 2
			elseif tops == 71 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 8, 2) 	-- Torso 2
			elseif tops == 72 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 89, 0, 2) 	-- Torso 2
			elseif tops == 73 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 95, 0, 2) 	-- Torso 2
			elseif tops == 74 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 31, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 99, 1, 2) 	-- Torso 2
			elseif tops == 75 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 31, 13, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 99, 3, 2) 	-- Torso 2
			elseif tops == 76 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 31, 13, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 101, 0, 2) 	-- Torso 2
			elseif tops == 77 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 105, 0, 2) 	-- Torso 2
			elseif tops == 78 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 106, 0, 2) 	-- Torso 2
			elseif tops == 79 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 73, 2, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 109, 0, 2) 	-- Torso 2
			elseif tops == 80 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 111, 0, 2) 	-- Torso 2
			elseif tops == 81 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 111, 3, 2) 	-- Torso 2
			elseif tops == 82 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 113, 0, 2) 	-- Torso 2
			elseif tops == 83 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 126, 5, 2) 	-- Torso 2
			elseif tops == 84 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 126, 9, 2) 	-- Torso 2
			elseif tops == 85 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 126, 10, 2) 	-- Torso 2
			elseif tops == 86 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 126, 14, 2) 	-- Torso 2
			elseif tops == 87 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 88 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 134, 0, 2) 	-- Torso 2
			elseif tops == 89 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 134, 1, 2) 	-- Torso 2
			elseif tops == 90 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 0, 2) 	-- Torso 2
			elseif tops == 91 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 92 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 93 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 94 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 6, 2) 	-- Torso 2
			elseif tops == 95 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 8, 2) 	-- Torso 2
			elseif tops == 96 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 9, 2) 	-- Torso 2
			elseif tops == 97 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 146, 0, 2) 	-- Torso 2
			elseif tops == 98 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 16, 2, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 166, 0, 2) 	-- Torso 2
			elseif tops == 99 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 167, 0, 2) 	-- Torso 2
			elseif tops == 100 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 167, 4, 2) 	-- Torso 2
			elseif tops == 101 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 167, 6, 2) 	-- Torso 2
			elseif tops == 102 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 167, 12, 2) 	-- Torso 2
			elseif tops == 103 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 169, 0, 2) 	-- Torso 2
			elseif tops == 104 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 172, 0, 2) 	-- Torso 2
			elseif tops == 105 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 173, 0, 2) 	-- Torso 2
			elseif tops == 106 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 41, 2, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 185, 0, 2) 	-- Torso 2
			elseif tops == 107 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 202, 0, 2) 	-- Torso 2
			elseif tops == 108 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 203, 10, 2) 	-- Torso 2
			elseif tops == 109 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 203, 16, 2) 	-- Torso 2
			elseif tops == 110 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 203, 25, 2) 	-- Torso 2
			elseif tops == 111 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 205, 0, 2) 	-- Torso 2
			elseif tops == 112 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 226, 0, 2) 	-- Torso 2
			elseif tops == 113 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 257, 0, 2) 	-- Torso 2
			elseif tops == 114 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 257, 9, 2) 	-- Torso 2
			elseif tops == 115 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 257, 17, 2) 	-- Torso 2
			elseif tops == 116 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 259, 9, 2) 	-- Torso 2
			elseif tops == 117 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 269, 2, 2) 	-- Torso 2
			elseif tops == 118 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 282, 6, 2) 	-- Torso 2
			elseif tops == 119 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 0, 7, 2) 	-- Torso
			elseif tops == 120 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 0, 7, 2) 	-- Torso
			elseif tops == 121 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 4, 0, 2) 	-- Torso
			elseif tops == 122 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 11, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 6, 1, 2) 	-- Torso
			elseif tops == 123 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 6, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 7, 5, 2) 	-- Torso
			elseif tops == 124 then
				SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 8, 5, 2) 	-- Torso
			elseif tops == 125 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 3, 1, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 10, 0, 2) 	-- Torso
			elseif tops == 126 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 14, 0, 2) 	-- Torso
			elseif tops == 127 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 9, 3, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 20, 0, 2) 	-- Torso
			elseif tops == 128 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 6, 12, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 21, 0, 2) 	-- Torso
			elseif tops == 129 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 74, 5, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 28, 0, 2) 	-- Torso
				--SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				--SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				--SetPedComponentVariation(PlayerPedId(), 8, 96, 6, 2) 		-- t-shirt
				--SetPedComponentVariation(PlayerPedId(), 11, 23, 2, 2) 	-- Torso
			elseif tops == 130 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 74, 5, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 28, 0, 2) 	-- Torso
			elseif tops == 131 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 29, 12, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 38, 0, 2) 	-- Torso
			elseif tops == 132 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 101, 5, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 62, 0, 2) 	-- Torso
			elseif tops == 133 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 77, 2, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 69, 0, 2) 	-- Torso
			elseif tops == 134 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 25, 3, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 4, 0, 2) 	-- Torso
			elseif tops == 135 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 32, 2, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 6, 3, 2) 	-- Torso
			elseif tops == 136 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 17, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 59, 2, 2) 	-- Torso
			elseif tops == 137 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 61, 1, 2) 	-- Torso
			elseif tops == 138 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 28, 2, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 62, 0, 2) 	-- Torso
			elseif tops == 139 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 63, 0, 2) 	-- Torso
			elseif tops == 140 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 70, 0, 2) 	-- Torso
			elseif tops == 141 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 26, 3, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 72, 2, 2) 	-- Torso
			elseif tops == 142 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 74, 1, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 76, 3, 2) 	-- Torso
			elseif tops == 143 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 78, 1, 2) 	-- Torso
			elseif tops == 144 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 78, 9, 2) 	-- Torso
			elseif tops == 145 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 82, 15, 2) 	-- Torso
			elseif tops == 146 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 22, 2, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 120, 4, 2) 	-- Torso
			elseif tops == 147 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 28, 2, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 122, 5, 2) 	-- Torso
			elseif tops == 148 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 153, 2, 2) 	-- Torso
			elseif tops == 149 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 27, 2, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 157, 2, 2) 	-- Torso
			elseif tops == 150 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 135, 12, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 166, 1, 2) 	-- Torso
			elseif tops == 151 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 64, 4, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 167, 0, 2) 	-- Torso
			elseif tops == 152 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 111, 4, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 173, 0, 2) 	-- Torso
			elseif tops == 153 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 111, 4, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 191, 16, 2) 	-- Torso
			elseif tops == 154 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 193, 11, 2) 	-- Torso
			elseif tops == 155 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 197, 5, 2) 	-- Torso
			elseif tops == 156 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 200, 7, 2) 	-- Torso
			elseif tops == 157 then
				--[[lost mc
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 245, 2, 2) 	-- Torso
				]]
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 256, 1, 2) 	-- Torso
			elseif tops == 158 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 256, 1, 2) 	-- Torso
			elseif tops == 159 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 265, 11, 2) 	-- Torso
			elseif tops == 160 then
				SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 38, 3, 2) 	-- Torso 2
			elseif tops == 161 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 39, 0, 2) 	-- Torso 2
			elseif tops == 162 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 39, 1, 2) 	-- Torso 2
			elseif tops == 163 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 41, 0, 2) 	-- Torso 2
			elseif tops == 164 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 42, 0, 2) 	-- Torso 2
			elseif tops == 165 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 50, 0, 2) 	-- Torso 2
			elseif tops == 166 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 50, 3, 2) 	-- Torso 2
			elseif tops == 167 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 50, 4, 2) 	-- Torso 2
			elseif tops == 168 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 57, 0, 2) 	-- Torso 2
			elseif tops == 169 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 70, 0, 2) 	-- Torso 2
			elseif tops == 170 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 70, 1, 2) 	-- Torso 2
			elseif tops == 171 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 70, 7, 2) 	-- Torso 2
			elseif tops == 172 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 3, 1, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 72, 1, 2) 	-- Torso 2
			elseif tops == 173 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 87, 0, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 74, 0, 2) 	-- Torso 2
			elseif tops == 174 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 12, 2, 2) 	-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 28, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 77, 0, 2) 	-- Torso 2
			elseif tops == 175 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 79, 0, 2) 	-- Torso 2
			elseif tops == 176 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 80, 0, 2) 	-- Torso 2
			elseif tops == 177 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 80, 1, 2) 	-- Torso 2
			elseif tops == 178 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 82, 5, 2) 	-- Torso 2
			elseif tops == 179 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 82, 8, 2) 	-- Torso 2
			elseif tops == 180 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 82, 9, 2) 	-- Torso 2
			elseif tops == 181 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 86, 0, 2) 	-- Torso 2
			elseif tops == 182 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 86, 2, 2) 	-- Torso 2
			elseif tops == 183 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 86, 4, 2) 	-- Torso 2
			elseif tops == 184 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 11, 2) 	-- Torso 2
			elseif tops == 185 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 0, 2) 	-- Torso 2
			elseif tops == 186 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 1, 2) 	-- Torso 2
			elseif tops == 187 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 2, 2) 	-- Torso 2
			elseif tops == 188 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 4, 2) 	-- Torso 2
			elseif tops == 189 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 87, 8, 2) 	-- Torso 2
			elseif tops == 190 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 89, 0, 2) 	-- Torso 2
			elseif tops == 191 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 95, 0, 2) 	-- Torso 2
			elseif tops == 192 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 31, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 99, 1, 2) 	-- Torso 2
			elseif tops == 193 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 31, 13, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 99, 3, 2) 	-- Torso 2
			elseif tops == 194 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 31, 13, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 101, 0, 2) 	-- Torso 2
			elseif tops == 195 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 105, 0, 2) 	-- Torso 2
			elseif tops == 196 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 106, 0, 2) 	-- Torso 2
			elseif tops == 197 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 73, 2, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 109, 0, 2) 	-- Torso 2
			elseif tops == 198 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 111, 0, 2) 	-- Torso 2
			elseif tops == 199 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 111, 3, 2) 	-- Torso 2
			elseif tops == 200 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 113, 0, 2) 	-- Torso 2
			elseif tops == 201 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 126, 5, 2) 	-- Torso 2
			elseif tops == 202 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 126, 9, 2) 	-- Torso 2
			elseif tops == 203 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 126, 10, 2) 	-- Torso 2
			elseif tops == 204 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 126, 14, 2) 	-- Torso 2
			elseif tops == 205 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 206 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 134, 0, 2) 	-- Torso 2
			elseif tops == 207 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 134, 1, 2) 	-- Torso 2
			elseif tops == 208 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 0, 2) 	-- Torso 2
			elseif tops == 209 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 2, 2) 	-- Torso 2
			elseif tops == 210 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 4, 2) 	-- Torso 2
			elseif tops == 211 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 5, 2) 	-- Torso 2
			elseif tops == 212 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 6, 2) 	-- Torso 2
			elseif tops == 213 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 8, 2) 	-- Torso 2
			elseif tops == 214 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 143, 9, 2) 	-- Torso 2
			elseif tops == 215 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 146, 0, 2) 	-- Torso 2
			elseif tops == 216 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 16, 2, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 166, 0, 2) 	-- Torso 2
			elseif tops == 217 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 167, 0, 2) 	-- Torso 2
			elseif tops == 218 then
				SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(PlayerPedId(), 11, 167, 4, 2) 	-- Torso 2
			end

			if pants == 0 then 		SetPedComponentVariation(PlayerPedId(), 4, 61, 4, 2)
			elseif pants == 1 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 0, 2)
			elseif pants == 2 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 2, 2)
			elseif pants == 3 then	SetPedComponentVariation(PlayerPedId(), 4, 1, 12, 2)
			elseif pants == 4 then	SetPedComponentVariation(PlayerPedId(), 4, 2, 11, 2)
			elseif pants == 5 then	SetPedComponentVariation(PlayerPedId(), 4, 3, 0, 2)
			elseif pants == 6 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 0, 2)
			elseif pants == 7 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 1, 2)
			elseif pants == 8 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 4, 2)
			elseif pants == 9 then	SetPedComponentVariation(PlayerPedId(), 4, 5, 0, 2)
			elseif pants == 10 then	SetPedComponentVariation(PlayerPedId(), 4, 5, 2, 2)
			elseif pants == 11 then	SetPedComponentVariation(PlayerPedId(), 4, 7, 0, 2)
			elseif pants == 12 then	SetPedComponentVariation(PlayerPedId(), 4, 7, 1, 2)
			elseif pants == 13 then	SetPedComponentVariation(PlayerPedId(), 4, 9, 0, 2)
			elseif pants == 14 then	SetPedComponentVariation(PlayerPedId(), 4, 9, 1, 2)
			elseif pants == 15 then	SetPedComponentVariation(PlayerPedId(), 4, 10, 0, 2)
			elseif pants == 16 then	SetPedComponentVariation(PlayerPedId(), 4, 10, 2, 2)
			elseif pants == 17 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 0, 2)
			elseif pants == 18 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 5, 2)
			elseif pants == 19 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 7, 2)
			elseif pants == 20 then	SetPedComponentVariation(PlayerPedId(), 4, 14, 0, 2)
			elseif pants == 21 then	SetPedComponentVariation(PlayerPedId(), 4, 14, 1, 2)
			elseif pants == 22 then	SetPedComponentVariation(PlayerPedId(), 4, 14, 3, 2)
			elseif pants == 23 then	SetPedComponentVariation(PlayerPedId(), 4, 15, 0, 2)
			elseif pants == 24 then	SetPedComponentVariation(PlayerPedId(), 4, 20, 0, 2)
			elseif pants == 25 then	SetPedComponentVariation(PlayerPedId(), 4, 24, 0, 2)
			elseif pants == 26 then	SetPedComponentVariation(PlayerPedId(), 4, 24, 1, 2)
			elseif pants == 27 then	SetPedComponentVariation(PlayerPedId(), 4, 24, 5, 2)
			elseif pants == 28 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 0, 2)
			elseif pants == 29 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 4, 2)
			elseif pants == 30 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 5, 2)
			elseif pants == 31 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 6, 2)
			elseif pants == 32 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 0, 2)
			elseif pants == 33 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 3, 2)
			elseif pants == 34 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 8, 2)
			elseif pants == 35 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 14, 2)
			elseif pants == 36 then	SetPedComponentVariation(PlayerPedId(), 4, 42, 0, 2)
			elseif pants == 37 then	SetPedComponentVariation(PlayerPedId(), 4, 42, 1, 2)
			elseif pants == 38 then	SetPedComponentVariation(PlayerPedId(), 4, 48, 0, 2)
			elseif pants == 39 then	SetPedComponentVariation(PlayerPedId(), 4, 48, 1, 2)
			elseif pants == 40 then	SetPedComponentVariation(PlayerPedId(), 4, 49, 0, 2)
			elseif pants == 41 then	SetPedComponentVariation(PlayerPedId(), 4, 49, 1, 2)
			elseif pants == 42 then	SetPedComponentVariation(PlayerPedId(), 4, 54, 1, 2)
			elseif pants == 43 then	SetPedComponentVariation(PlayerPedId(), 4, 55, 0, 2)
			elseif pants == 44 then	SetPedComponentVariation(PlayerPedId(), 4, 60, 2, 2)
			elseif pants == 45 then	SetPedComponentVariation(PlayerPedId(), 4, 60, 9, 2)
			elseif pants == 46 then	SetPedComponentVariation(PlayerPedId(), 4, 71, 0, 2)
			elseif pants == 47 then	SetPedComponentVariation(PlayerPedId(), 4, 75, 2, 2)
			elseif pants == 48 then	SetPedComponentVariation(PlayerPedId(), 4, 76, 2, 2)
			elseif pants == 49 then	SetPedComponentVariation(PlayerPedId(), 4, 78, 0, 2)
			elseif pants == 50 then	SetPedComponentVariation(PlayerPedId(), 4, 78, 2, 2)
			elseif pants == 51 then	SetPedComponentVariation(PlayerPedId(), 4, 78, 4, 2)
			elseif pants == 52 then	SetPedComponentVariation(PlayerPedId(), 4, 82, 0, 2)
			elseif pants == 53 then	SetPedComponentVariation(PlayerPedId(), 4, 82, 2, 2)
			elseif pants == 54 then	SetPedComponentVariation(PlayerPedId(), 4, 82, 3, 2)
			elseif pants == 55 then	SetPedComponentVariation(PlayerPedId(), 4, 86, 9, 2)
			elseif pants == 56 then	SetPedComponentVariation(PlayerPedId(), 4, 88, 9, 2)
			elseif pants == 57 then	SetPedComponentVariation(PlayerPedId(), 4, 100, 9, 2)
			elseif pants == 58 then	SetPedComponentVariation(PlayerPedId(), 4, 58, 1, 2)
			elseif pants == 59 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
			elseif pants == 60 then	SetPedComponentVariation(PlayerPedId(), 4, 60, 1, 2)
			elseif pants == 61 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
			elseif pants == 62 then	SetPedComponentVariation(PlayerPedId(), 4, 62, 1, 2)
			elseif pants == 63 then	SetPedComponentVariation(PlayerPedId(), 4, 63, 1, 2)
			elseif pants == 64 then	SetPedComponentVariation(PlayerPedId(), 4, 64, 1, 2)
			elseif pants == 65 then	SetPedComponentVariation(PlayerPedId(), 4, 65, 1, 2)
			elseif pants == 66 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
			elseif pants == 67 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
			elseif pants == 68 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
			elseif pants == 69 then	SetPedComponentVariation(PlayerPedId(), 4, 69, 1, 2)
			elseif pants == 70 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
			end

			if shoes == 0 then 	SetPedComponentVariation(PlayerPedId(), 6, 34, 0, 2)
			elseif shoes == 1 then	SetPedComponentVariation(PlayerPedId(), 6, 0, 10, 2)
			elseif shoes == 2 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 0, 2)
			elseif shoes == 3 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 1, 2)
			elseif shoes == 4 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 3, 2)
			elseif shoes == 5 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 0, 2)
			elseif shoes == 6 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 6, 2)
			elseif shoes == 7 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 14, 2)
			elseif shoes == 8 then	SetPedComponentVariation(PlayerPedId(), 6, 48, 0, 2)
			elseif shoes == 9 then	SetPedComponentVariation(PlayerPedId(), 6, 48, 1, 2)
			elseif shoes == 10 then SetPedComponentVariation(PlayerPedId(), 6, 49, 0, 2)
			elseif shoes == 11 then SetPedComponentVariation(PlayerPedId(), 6, 49, 1, 2)
			elseif shoes == 12 then SetPedComponentVariation(PlayerPedId(), 6, 5, 0, 2)
			elseif shoes == 13 then SetPedComponentVariation(PlayerPedId(), 6, 6, 0, 2)
			elseif shoes == 14 then SetPedComponentVariation(PlayerPedId(), 6, 7, 0, 2)
			elseif shoes == 15 then SetPedComponentVariation(PlayerPedId(), 6, 7, 9, 2)
			elseif shoes == 16 then SetPedComponentVariation(PlayerPedId(), 6, 7, 13, 2)
			elseif shoes == 17 then SetPedComponentVariation(PlayerPedId(), 6, 9, 3, 2)
			elseif shoes == 18 then SetPedComponentVariation(PlayerPedId(), 6, 9, 6, 2)
			elseif shoes == 19 then SetPedComponentVariation(PlayerPedId(), 6, 9, 7, 2)
			elseif shoes == 20 then SetPedComponentVariation(PlayerPedId(), 6, 10, 0, 2)
			elseif shoes == 21 then SetPedComponentVariation(PlayerPedId(), 6, 12, 0, 2)
			elseif shoes == 22 then SetPedComponentVariation(PlayerPedId(), 6, 12, 2, 2)
			elseif shoes == 23 then SetPedComponentVariation(PlayerPedId(), 6, 12, 13, 2)
			elseif shoes == 24 then SetPedComponentVariation(PlayerPedId(), 6, 15, 0, 2)
			elseif shoes == 25 then SetPedComponentVariation(PlayerPedId(), 6, 15, 1, 2)
			elseif shoes == 26 then SetPedComponentVariation(PlayerPedId(), 6, 16, 0, 2)
			elseif shoes == 27 then SetPedComponentVariation(PlayerPedId(), 6, 20, 0, 2)
			elseif shoes == 28 then SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)
			elseif shoes == 29 then SetPedComponentVariation(PlayerPedId(), 6, 27, 0, 2)
			elseif shoes == 30 then SetPedComponentVariation(PlayerPedId(), 6, 28, 0, 2)
			elseif shoes == 31 then SetPedComponentVariation(PlayerPedId(), 6, 28, 1, 2)
			elseif shoes == 32 then SetPedComponentVariation(PlayerPedId(), 6, 28, 3, 2)
			elseif shoes == 33 then SetPedComponentVariation(PlayerPedId(), 6, 28, 2, 2)
			elseif shoes == 34 then SetPedComponentVariation(PlayerPedId(), 6, 31, 2, 2)
			elseif shoes == 35 then SetPedComponentVariation(PlayerPedId(), 6, 31, 4, 2)
			elseif shoes == 36 then SetPedComponentVariation(PlayerPedId(), 6, 36, 0, 2)
			elseif shoes == 37 then SetPedComponentVariation(PlayerPedId(), 6, 36, 3, 2)
			elseif shoes == 38 then SetPedComponentVariation(PlayerPedId(), 6, 42, 0, 2)
			elseif shoes == 39 then SetPedComponentVariation(PlayerPedId(), 6, 42, 1, 2)
			elseif shoes == 40 then SetPedComponentVariation(PlayerPedId(), 6, 42, 7, 2)
			elseif shoes == 41 then SetPedComponentVariation(PlayerPedId(), 6, 57, 0, 2)
			elseif shoes == 42 then SetPedComponentVariation(PlayerPedId(), 6, 57, 3, 2)
			elseif shoes == 43 then SetPedComponentVariation(PlayerPedId(), 6, 57, 8, 2)
			elseif shoes == 44 then SetPedComponentVariation(PlayerPedId(), 6, 57, 9, 2)
			elseif shoes == 45 then SetPedComponentVariation(PlayerPedId(), 6, 57, 10, 2)
			elseif shoes == 46 then SetPedComponentVariation(PlayerPedId(), 6, 57, 11, 2)
			elseif shoes == 47 then SetPedComponentVariation(PlayerPedId(), 6, 75, 4, 2)
			elseif shoes == 48 then SetPedComponentVariation(PlayerPedId(), 6, 75, 7, 2)
			elseif shoes == 49 then SetPedComponentVariation(PlayerPedId(), 6, 75, 8, 2)
			elseif shoes == 50 then SetPedComponentVariation(PlayerPedId(), 6, 77, 0, 2)
		end
	else
	if tops == 0 then
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 2) 	-- Torso 2
	elseif tops == 1 then
		SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 0, 1, 2) 	-- Torso 2
	elseif tops == 2 then
		SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 0, 7, 2) 	-- Torso 2
	elseif tops == 3 then
		SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 2, 9, 2) 	-- Torso 2
	elseif tops == 4 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 3, 11, 2) 	-- Torso 2
	elseif tops == 5 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 3, 10, 2) 	-- Torso 2
	elseif tops == 6 then
		SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 6, 0, 2) 	-- Torso 2
	elseif tops == 7 then
		SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 16, 1, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 7, 0, 2) 	-- Torso 2
	elseif tops == 8 then
		SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 26, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 8, 0, 2) 	-- Torso 2
	elseif tops == 9 then
		SetPedComponentVariation(PlayerPedId(), 3, 9, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 6, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 9, 0, 2) 	-- Torso 2
	elseif tops == 10 then
		SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 4, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 10, 11, 2) 	-- Torso 2
	elseif tops == 11 then
		SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 4, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 11, 0, 2) 	-- Torso 2
	elseif tops == 12 then
		SetPedComponentVariation(PlayerPedId(), 3, 12, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 12, 4, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 12, 0, 2) 	-- Torso 2
	elseif tops == 13 then
		SetPedComponentVariation(PlayerPedId(), 3, 58, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 13, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 13, 0, 2) 	-- Torso 2
	elseif tops == 14 then
		SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 14, 0, 2) 	-- Torso 2
	elseif tops == 15 then
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 15, 0, 2) 	-- Torso 2
	elseif tops == 16 then
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 16, 0, 2) 	-- Torso 2
	elseif tops == 17 then
		SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 9, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 17, 0, 2) 	-- Torso 2
	elseif tops == 18 then
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 9, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 18, 0, 2) 	-- Torso 2
	elseif tops == 19 then
		SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 19, 0, 2) 	-- Torso 2
	elseif tops == 20 then
		SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 20, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 20, 0, 2) 	-- Torso 2
	elseif tops == 21 then
		SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 10, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 21, 0, 2) 	-- Torso 2
	elseif tops == 22 then
		SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 22, 0, 2) 	-- Torso 2
	elseif tops == 23 then
		SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 23, 0, 2) 	-- Torso 2
	elseif tops == 24 then
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 24, 0, 2) 	-- Torso 2
	elseif tops == 25 then
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 25, 1, 2) 	-- Torso 2
	elseif tops == 26 then
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 26, 0, 2) 	-- Torso 2
	elseif tops == 27 then
		SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 27, 1, 2) 	-- Torso 2
	elseif tops == 28 then
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 28, 2, 2) 	-- Torso 2
	elseif tops == 29 then
		SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 31, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 191, 0, 2) 	-- Torso 2
	elseif tops == 30 then
		SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 17, 1, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 30, 1, 2) 	-- Torso 2
	elseif tops == 31 then
		SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 17, 4, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 31, 4, 2) 	-- Torso 2
	elseif tops == 32 then
		SetPedComponentVariation(PlayerPedId(), 3, 12, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 27, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 32, 0, 2) 	-- Torso 2
	elseif tops == 33 then
		SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 27, 5, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 33, 0, 2) 	-- Torso 2
	elseif tops == 34 then
		SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 0, 6, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 34, 0, 2) 	-- Torso 2
	elseif tops == 35 then
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 63, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 35, 0, 2) 	-- Torso 2
	elseif tops == 36 then
		SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 57, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 36, 0, 2) 	-- Torso 2
	elseif tops == 37 then
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 37, 0, 2) 	-- Torso 2
	elseif tops == 38 then
		SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 38, 0, 2) 	-- Torso 2
	elseif tops == 39 then -- America top
		SetPedComponentVariation(PlayerPedId(), 3, 7, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 39, 0, 2) 	-- Torso 2
	elseif tops == 40 then
		SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 40, 0, 2) 	-- Torso 2
	elseif tops == 41 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 41, 0, 2) 	-- Torso 2
	elseif tops == 42 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 42, 0, 2) 	-- Torso 2
	elseif tops == 43 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 43, 1, 2) 	-- Torso 2
	elseif tops == 44 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 44, 1, 2) 	-- Torso 2
	elseif tops == 45 then
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 45, 0, 2) 	-- Torso 2
	elseif tops == 46 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 46, 0, 2) 	-- Torso 2
	elseif tops == 47 then
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 47, 0, 2) 	-- Torso 2
	elseif tops == 48 then
		SetPedComponentVariation(PlayerPedId(), 3, 7, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 273, 0, 2) 	-- Torso 2
	elseif tops == 49 then
		SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 49, 0, 2) 	-- Torso 2
	elseif tops == 50 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 50, 0, 2) 	-- Torso 2
	elseif tops == 51 then
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 72, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 51, 0, 2) 	-- Torso 2
	elseif tops == 52 then
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 50, 1, 2) 	-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 72, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 52, 1, 2) 	-- Torso 2
	elseif tops == 53 then
		SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 1, 2) 	-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 1, 2, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 53, 0, 2) 	-- Torso 2
	elseif tops == 54 then
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 3, 1, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 54, 1, 2) 	-- Torso 2
	elseif tops == 55 then
		SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 	-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 5, 0, 2) 		-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 55, 0, 2) 	-- Torso 2
	elseif tops == 56 then
		SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 2, 2) 	-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 56, 0, 2) 	-- Torso 2
	elseif tops == 57 then
		SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 78, 2, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 57, 0, 2) 	-- Torso 2
	elseif tops == 58 then
		SetPedComponentVariation(PlayerPedId(), 3, 7, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 58, 0, 2) 	-- Torso 2
	elseif tops == 59 then
		SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 192, 0, 2) 	-- Torso 2
	elseif tops == 60 then
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)		-- Torso
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
		SetPedComponentVariation(PlayerPedId(), 8, 16, 0, 2) 	-- Undershirt
		SetPedComponentVariation(PlayerPedId(), 11, 206, 0, 2) 	-- Torso 2
elseif tops == 60 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 158, 3, 2) 	-- Torso
			elseif tops == 61 then
				SetPedComponentVariation(PlayerPedId(), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 184, 0, 2) 	-- Torso
			elseif tops == 62 then
				SetPedComponentVariation(PlayerPedId(), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 184, 1, 2) 	-- Torso
			elseif tops == 63 then
				SetPedComponentVariation(PlayerPedId(), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 26, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 187, 0, 2) 	-- Torso
			elseif tops == 64 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 195, 17, 2) 	-- Torso
			elseif tops == 65 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 195, 13, 2) 	-- Torso
			elseif tops == 66 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 195, 15, 2) 	-- Torso
			elseif tops == 67 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 195, 6, 2) 	-- Torso
			elseif tops == 68 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 195, 5, 2) 	-- Torso
			elseif tops == 69 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 202, 1, 2) 	-- Torso
			elseif tops == 70 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 202, 2, 2) 	-- Torso
			elseif tops == 71 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 202, 8, 2) 	-- Torso
			elseif tops == 72 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 208, 12, 2) 	-- Torso
			elseif tops == 73 then
				SetPedComponentVariation(PlayerPedId(), 3, 11, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 209, 12, 2) 	-- Torso
			elseif tops == 74 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 234, 0, 2) 	-- Torso
			elseif tops == 75 then
				SetPedComponentVariation(PlayerPedId(), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 234, 2, 2) 	-- Torso
			elseif tops == 76 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 236, 0, 2) 	-- Torso
			elseif tops == 77 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 16, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 240, 3, 2) 	-- Torso
			elseif tops == 78 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 244, 7, 2) 	-- Torso
			elseif tops == 79 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 247, 0, 2) 	-- Torso
			elseif tops == 80 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 247, 4, 2) 	-- Torso
			elseif tops == 81 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 247, 6, 2) 	-- Torso
			elseif tops == 82 then
				SetPedComponentVariation(PlayerPedId(), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 247, 24, 2) 	-- Torso
			elseif tops == 83 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 244, 8, 2) 	-- Torso
			elseif tops == 84 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 88, 1, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 255, 24, 2) 	-- Torso
			elseif tops == 85 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 89, 1, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 255, 16, 2) 	-- Torso
			elseif tops == 86 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 256, 25, 2) 	-- Torso
			elseif tops == 87 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 244, 11, 2) 	-- Torso
			elseif tops == 88 then
				SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 244, 12, 2) 	-- Torso
			elseif tops == 89 then
				SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 273, 2, 2) 	-- Torso
			elseif tops == 90 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 279, 7, 2) 	-- Torso
			elseif tops == 91 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 279, 5, 2) 	-- Torso
			elseif tops == 92 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 279, 2, 2) 	-- Torso
			elseif tops == 93 then
				SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 283, 10, 2) 	-- Torso
			elseif tops == 94 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 286, 11, 2) 	-- Torso
			elseif tops == 95 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 286, 2, 2) 	-- Torso
			elseif tops == 96 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 265, 4, 2) 	-- Torso
			elseif tops == 97 then
				SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 265, 6, 2) 	-- Torso
			elseif tops == 98 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 30, 1, 2) 	-- Torso
			elseif tops == 99 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 37, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 52, 2, 2) 	-- Torso
			elseif tops == 100 then
				SetPedComponentVariation(PlayerPedId(), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(PlayerPedId(), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(PlayerPedId(), 11, 54, 2, 2) 	-- Torso


	end

	if pants == 0 then 		SetPedComponentVariation(PlayerPedId(), 4, 15, 0, 2)
	elseif pants == 1 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 0, 2)
	elseif pants == 2 then	SetPedComponentVariation(PlayerPedId(), 4, 2, 0, 2)
	elseif pants == 3 then	SetPedComponentVariation(PlayerPedId(), 4, 3, 0, 2)
	elseif pants == 4 then	SetPedComponentVariation(PlayerPedId(), 4, 4, 0, 2)
	elseif pants == 5 then	SetPedComponentVariation(PlayerPedId(), 4, 110, 0, 2)
	elseif pants == 6 then	SetPedComponentVariation(PlayerPedId(), 4, 6, 0, 2)
	elseif pants == 7 then	SetPedComponentVariation(PlayerPedId(), 4, 7, 0, 2)
	elseif pants == 8 then	SetPedComponentVariation(PlayerPedId(), 4, 8, 0, 2)
	elseif pants == 9 then	SetPedComponentVariation(PlayerPedId(), 4, 9, 0, 2)
	elseif pants == 10 then	SetPedComponentVariation(PlayerPedId(), 4, 10, 0, 2)
	elseif pants == 11 then	SetPedComponentVariation(PlayerPedId(), 4, 11, 0, 2)
	elseif pants == 12 then	SetPedComponentVariation(PlayerPedId(), 4, 12, 0, 2)
	elseif pants == 13 then	SetPedComponentVariation(PlayerPedId(), 4, 58, 0, 2)
	elseif pants == 14 then	SetPedComponentVariation(PlayerPedId(), 4, 14, 0, 2)
	elseif pants == 15 then	SetPedComponentVariation(PlayerPedId(), 4, 1, 0, 2)
	elseif pants == 16 then	SetPedComponentVariation(PlayerPedId(), 4, 16, 0, 2)
	elseif pants == 17 then	SetPedComponentVariation(PlayerPedId(), 4, 17, 0, 2)
	elseif pants == 18 then	SetPedComponentVariation(PlayerPedId(), 4, 64, 0, 2)
	elseif pants == 19 then	SetPedComponentVariation(PlayerPedId(), 4, 19, 7, 2)
	elseif pants == 20 then	SetPedComponentVariation(PlayerPedId(), 4, 106, 0, 2)
	elseif pants == 21 then	SetPedComponentVariation(PlayerPedId(), 4, 66, 0, 2)
	elseif pants == 22 then	SetPedComponentVariation(PlayerPedId(), 4, 67, 0, 2)
	elseif pants == 23 then	SetPedComponentVariation(PlayerPedId(), 4, 23, 0, 2)
	elseif pants == 24 then	SetPedComponentVariation(PlayerPedId(), 4, 24, 0, 2)
	elseif pants == 25 then	SetPedComponentVariation(PlayerPedId(), 4, 68, 0, 2)
	elseif pants == 26 then	SetPedComponentVariation(PlayerPedId(), 4, 26, 0, 2)
	elseif pants == 27 then	SetPedComponentVariation(PlayerPedId(), 4, 27, 0, 2)
	elseif pants == 28 then	SetPedComponentVariation(PlayerPedId(), 4, 28, 0, 2)
	elseif pants == 29 then	SetPedComponentVariation(PlayerPedId(), 4, 29, 0, 2)
	elseif pants == 30 then	SetPedComponentVariation(PlayerPedId(), 4, 30, 0, 2)
	elseif pants == 31 then	SetPedComponentVariation(PlayerPedId(), 4, 31, 0, 2)
	elseif pants == 32 then	SetPedComponentVariation(PlayerPedId(), 4, 107, 0, 2)
	elseif pants == 33 then	SetPedComponentVariation(PlayerPedId(), 4, 33, 0, 2)
	elseif pants == 34 then	SetPedComponentVariation(PlayerPedId(), 4, 34, 0, 2)
	elseif pants == 35 then	SetPedComponentVariation(PlayerPedId(), 4, 35, 0, 2)
	elseif pants == 36 then	SetPedComponentVariation(PlayerPedId(), 4, 36, 0, 2)
	elseif pants == 37 then	SetPedComponentVariation(PlayerPedId(), 4, 37, 0, 2)
	elseif pants == 38 then	SetPedComponentVariation(PlayerPedId(), 4, 99, 0, 2)
	elseif pants == 39 then	SetPedComponentVariation(PlayerPedId(), 4, 76, 0, 2)
	elseif pants == 40 then	SetPedComponentVariation(PlayerPedId(), 4, 77, 0, 2)
	elseif pants == 41 then	SetPedComponentVariation(PlayerPedId(), 4, 41, 0, 2)
	elseif pants == 42 then	SetPedComponentVariation(PlayerPedId(), 4, 42, 0, 2)
	elseif pants == 43 then	SetPedComponentVariation(PlayerPedId(), 4, 43, 0, 2)
	elseif pants == 44 then	SetPedComponentVariation(PlayerPedId(), 4, 44, 0, 2)
	elseif pants == 45 then	SetPedComponentVariation(PlayerPedId(), 4, 45, 0, 2)
	elseif pants == 46 then	SetPedComponentVariation(PlayerPedId(), 4, 82, 0, 2)
	elseif pants == 47 then	SetPedComponentVariation(PlayerPedId(), 4, 47, 0, 2)
	elseif pants == 48 then	SetPedComponentVariation(PlayerPedId(), 4, 48, 0, 2)
	elseif pants == 49 then	SetPedComponentVariation(PlayerPedId(), 4, 49, 0, 2)
	elseif pants == 50 then	SetPedComponentVariation(PlayerPedId(), 4, 50, 0, 2)
	elseif pants == 51 then	SetPedComponentVariation(PlayerPedId(), 4, 51, 0, 2)
	elseif pants == 52 then	SetPedComponentVariation(PlayerPedId(), 4, 52, 0, 2)
	elseif pants == 53 then	SetPedComponentVariation(PlayerPedId(), 4, 53, 0, 2)
	elseif pants == 54 then	SetPedComponentVariation(PlayerPedId(), 4, 54, 0, 2)
	elseif pants == 55 then	SetPedComponentVariation(PlayerPedId(), 4, 55, 0, 2)
	elseif pants == 56 then	SetPedComponentVariation(PlayerPedId(), 4, 87, 0, 2)
	elseif pants == 57 then	SetPedComponentVariation(PlayerPedId(), 4, 88, 0, 2)
	elseif pants == 58 then	SetPedComponentVariation(PlayerPedId(), 4, 58, 1, 2)
	elseif pants == 59 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
	elseif pants == 60 then	SetPedComponentVariation(PlayerPedId(), 4, 60, 1, 2)
	elseif pants == 61 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
	elseif pants == 62 then	SetPedComponentVariation(PlayerPedId(), 4, 62, 1, 2)
	elseif pants == 63 then	SetPedComponentVariation(PlayerPedId(), 4, 63, 1, 2)
	elseif pants == 64 then	SetPedComponentVariation(PlayerPedId(), 4, 64, 1, 2)
	elseif pants == 65 then	SetPedComponentVariation(PlayerPedId(), 4, 65, 1, 2)
	elseif pants == 66 then	SetPedComponentVariation(PlayerPedId(), 4, 66, 1, 2)
	elseif pants == 67 then	SetPedComponentVariation(PlayerPedId(), 4, 67, 1, 2)
	elseif pants == 68 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
	elseif pants == 69 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
	elseif pants == 70 then	SetPedComponentVariation(PlayerPedId(), 4, 0, 1, 2)
	end

	if shoes == 0 then 	SetPedComponentVariation(PlayerPedId(), 6, 0, 0, 2)
	elseif shoes == 1 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 0, 2)
	elseif shoes == 2 then	SetPedComponentVariation(PlayerPedId(), 6, 2, 0, 2)
	elseif shoes == 3 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 0, 2)
	elseif shoes == 4 then	SetPedComponentVariation(PlayerPedId(), 6, 4, 0, 2)
	elseif shoes == 5 then	SetPedComponentVariation(PlayerPedId(), 6, 5, 0, 2)
	elseif shoes == 6 then	SetPedComponentVariation(PlayerPedId(), 6, 6, 0, 2)
	elseif shoes == 7 then	SetPedComponentVariation(PlayerPedId(), 6, 7, 0, 2)
	elseif shoes == 8 then	SetPedComponentVariation(PlayerPedId(), 6, 8, 0, 2)
	elseif shoes == 9 then	SetPedComponentVariation(PlayerPedId(), 6, 9, 0, 2)
	elseif shoes == 10 then SetPedComponentVariation(PlayerPedId(), 6, 10, 0, 2)
	elseif shoes == 11 then SetPedComponentVariation(PlayerPedId(), 6, 11, 0, 2)
	elseif shoes == 12 then SetPedComponentVariation(PlayerPedId(), 6, 51, 0, 2)
	elseif shoes == 13 then SetPedComponentVariation(PlayerPedId(), 6, 13, 0, 2)
	elseif shoes == 14 then SetPedComponentVariation(PlayerPedId(), 6, 14, 0, 2)
	elseif shoes == 15 then SetPedComponentVariation(PlayerPedId(), 6, 15, 0, 2)
	elseif shoes == 16 then SetPedComponentVariation(PlayerPedId(), 6, 16, 0, 2)
	elseif shoes == 17 then SetPedComponentVariation(PlayerPedId(), 6, 17, 0, 2)
	elseif shoes == 18 then SetPedComponentVariation(PlayerPedId(), 6, 18, 0, 2)
	elseif shoes == 19 then SetPedComponentVariation(PlayerPedId(), 6, 19, 0, 2)
	elseif shoes == 20 then SetPedComponentVariation(PlayerPedId(), 6, 20, 0, 2)
	elseif shoes == 21 then SetPedComponentVariation(PlayerPedId(), 6, 21, 0, 2)
	elseif shoes == 22 then SetPedComponentVariation(PlayerPedId(), 6, 22, 0, 2)
	elseif shoes == 23 then SetPedComponentVariation(PlayerPedId(), 6, 23, 0, 2)
	elseif shoes == 24 then SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)
	elseif shoes == 25 then SetPedComponentVariation(PlayerPedId(), 6, 25, 0, 2)
	elseif shoes == 26 then SetPedComponentVariation(PlayerPedId(), 6, 26, 0, 2)
	elseif shoes == 27 then SetPedComponentVariation(PlayerPedId(), 6, 27, 0, 2)
	elseif shoes == 28 then SetPedComponentVariation(PlayerPedId(), 6, 28, 0, 2)
	elseif shoes == 29 then SetPedComponentVariation(PlayerPedId(), 6, 29, 0, 2)
	elseif shoes == 30 then SetPedComponentVariation(PlayerPedId(), 6, 30, 0, 2)
	elseif shoes == 31 then SetPedComponentVariation(PlayerPedId(), 6, 31, 0, 2)
	elseif shoes == 32 then SetPedComponentVariation(PlayerPedId(), 6, 32, 0, 2)
	elseif shoes == 33 then SetPedComponentVariation(PlayerPedId(), 6, 33, 0, 2)
	elseif shoes == 34 then SetPedComponentVariation(PlayerPedId(), 6, 52, 0, 2)
	elseif shoes == 35 then SetPedComponentVariation(PlayerPedId(), 6, 35, 0, 2)
	elseif shoes == 36 then SetPedComponentVariation(PlayerPedId(), 6, 36, 0, 2)
	elseif shoes == 37 then SetPedComponentVariation(PlayerPedId(), 6, 37, 0, 2)
	elseif shoes == 38 then SetPedComponentVariation(PlayerPedId(), 6, 38, 0, 2)
	elseif shoes == 39 then SetPedComponentVariation(PlayerPedId(), 6, 39, 0, 2)
	elseif shoes == 40 then SetPedComponentVariation(PlayerPedId(), 6, 52, 0, 2)
	elseif shoes == 41 then SetPedComponentVariation(PlayerPedId(), 6, 53, 0, 2)
	elseif shoes == 42 then SetPedComponentVariation(PlayerPedId(), 6, 42, 0, 2)
	elseif shoes == 43 then SetPedComponentVariation(PlayerPedId(), 6, 43, 0, 2)
	elseif shoes == 44 then SetPedComponentVariation(PlayerPedId(), 6, 44, 0, 2)
	elseif shoes == 45 then SetPedComponentVariation(PlayerPedId(), 6, 45, 0, 2)
	elseif shoes == 46 then SetPedComponentVariation(PlayerPedId(), 6, 46, 0, 2)
	elseif shoes == 47 then SetPedComponentVariation(PlayerPedId(), 6, 47, 0, 2)
	elseif shoes == 48 then SetPedComponentVariation(PlayerPedId(), 6, 48, 0, 2)
	elseif shoes == 49 then SetPedComponentVariation(PlayerPedId(), 6, 49, 0, 2)
	elseif shoes == 50 then SetPedComponentVariation(PlayerPedId(), 6, 50, 0, 2)
	end
	end

		-- Keep these 4 variations together.
		-- It avoids empty arms or noisy clothes superposition

		if watches == 0 then		ClearPedProp(PlayerPedId(), 6)
		elseif watches == 1 then	SetPedPropIndex(PlayerPedId(), 6, 1-1, 1-1, 2)
		elseif watches == 2 then	SetPedPropIndex(PlayerPedId(), 6, 2-1, 1-1, 2)
		elseif watches == 3 then	SetPedPropIndex(PlayerPedId(), 6, 4-1, 1-1, 2)
		elseif watches == 4 then	SetPedPropIndex(PlayerPedId(), 6, 4-1, 3-1, 2)
		elseif watches == 5 then	SetPedPropIndex(PlayerPedId(), 6, 5-1, 1-1, 2)
		elseif watches == 6 then	SetPedPropIndex(PlayerPedId(), 6, 9-1, 1-1, 2)
		elseif watches == 7 then	SetPedPropIndex(PlayerPedId(), 6, 11-1, 1-1, 2)
		end
	end
end)

-- Character rotation
RegisterNUICallback('rotateleftheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = heading+tonumber(data.value)
end)

RegisterNUICallback('rotaterightheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = heading-tonumber(data.value)
end)

-- Close all
RegisterNUICallback('closeall', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = heading-tonumber(data.value)
	CloseSkinCreator()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

-- Define which part of the body must be zoomed
RegisterNUICallback('zoom', function(data)
	zoom = data.zoom
end)

function CloseSkinCreator()
	local ped = PlayerPedId()
	ShowSkinCreator(false)
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil

	-- Player
	SetPlayerInvincible(ped, false)
end

function ShowSkinCreator(enable)
local elements    = {}
	TriggerEvent('skinchanger:getData', function(components, maxVals)
		local _components = {}

		for i=1, #components, 1 do
			_components[i] = components[i]
		end

		-- Insert elements
		for i=1, #_components, 1 do
			local value       = _components[i].value
			local componentId = _components[i].componentId

			if componentId == 0 then
				value = GetPedPropIndex(playerPed,  _components[i].componentId)
			end

			local data = {
				label     = _components[i].label,
				name      = _components[i].name,
				value     = value,
				min       = _components[i].min,
			}

			for k,v in pairs(maxVals) do
				if k == _components[i].name then
					data.max = v
					break
				end
			end

			table.insert(elements, data)
		end
	end)
	isCameraActive = true
	SetNuiFocus(enable, enable)
	SendNUIMessage({
		openSkinCreator = enable,
	})

	for index, data in ipairs(elements) do
		local name, Valmax

		for key, value in pairs(data) do
			if key == 'name' then
				name = value
			end
			if key == 'max' then
				Valmax = value
			end
		end

		SendNUIMessage({
			type = "updateMaxVal",
			classname = name,
			defaultVal = 0,
			maxVal = Valmax
		})
	end
end

-- Disable Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isCameraActive == true then
			local ped = PlayerPedId()

			-- Camera
			RenderScriptCams(false, false, 0, 1, 0)
			DestroyCam(cam, false)
			if(not DoesCamExist(cam)) then
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
				SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
				SetCamRot(cam, 0.0, 0.0, 0.0)
				SetCamActive(cam,  true)
				RenderScriptCams(true,  false,  0,  true,  true)
				SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
			end
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			if zoom == "visage" or zoom == "pilosite" then
				SetCamCoord(cam, x+0.3, y+2.0, z+0.0)
				SetCamRot(cam, 0.0, 0.0, 150.0)
			elseif zoom == "vetements" then
				SetCamCoord(cam, x+0.3, y+2.0, z+0.0)
				SetCamRot(cam, 0.0, 0.0, 170.0)
			end
			SetEntityHeading(PlayerPedId(), heading)
		else
			Citizen.Wait(500)
		end
	end

end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
	cb(lastSkinOld)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
	lastSkinOld = skin
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu')
AddEventHandler('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
	ShowSkinCreator(true)
end)

RegisterNetEvent('rpuk_clothes:hasEnteredMarker')
AddEventHandler('rpuk_clothes:hasEnteredMarker', function(currentPad, padData)
	CurrentAction = 'pad.' .. string.lower(currentPad)
	CurrentActionMsg = padData.Text
	CurrentActionData = { padData = padData }
end)

RegisterNetEvent('rpuk_clothes:hasExitedMarker')
AddEventHandler('rpuk_clothes:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()

	CurrentAction = nil
end)

-- Draw marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true

		for pad, padData in ipairs(Config.Pads) do
			if GetDistanceBetweenCoords(coords, padData.Marker, true) < Config.DrawDistance then
				DrawMarker(padData.MarkerSettings.type, padData.Marker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, padData.MarkerSettings.x, padData.MarkerSettings.y, padData.MarkerSettings.z, padData.MarkerSettings.r, padData.MarkerSettings.g, padData.MarkerSettings.b, padData.MarkerSettings.a, false, true, 2, false, false, false, false)
				canSleep = false
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords, isInMarker, currentPad, currentAction, currentPadData = GetEntityCoords(playerPed), false, nil, nil, nil

		for pad, padData in ipairs(Config.Pads) do
			if GetDistanceBetweenCoords(coords, padData.Marker, true) < padData.MarkerSettings.x then
				isInMarker, currentPad, currentAction, currentPadData = true, pad, 'pad.' .. string.lower(pad), padData
			end
		end

		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastPad ~= currentPad or LastAction ~= currentAction)) then
			if (LastPad ~= nil and LastAction ~= nil) and (LastPad ~= currentPad or LastAction ~= currentAction) then
				TriggerEvent('rpuk_clothes:hasExitedMarker', LastPad, LastAction)

				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastPad, LastAction, LastPadData = currentPad, currentAction, currentPadData

			TriggerEvent('rpuk_clothes:hasEnteredMarker', currentPad, currentPadData)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false

			TriggerEvent('rpuk_clothes:hasExitedMarker', LastPad, LastAction)
		end

		if not HasAlreadyEnteredMarker then
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('rpuk_clothes:PropertyClothesAccess')
AddEventHandler('rpuk_clothes:PropertyClothesAccess', function()
	TriggerEvent('esx_skin:openSaveableRestrictedMenu', source)
end)

function OpenGateWay()
  local price = 250
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_clothes',
    {
      title = "Clothing",
	  css =  'rpuk',
align    = 'top-left',
      elements = {
        { label = "Purchase Clothing" .. ' (<span style="color:green;">£' .. price .. '<span style="color:#FFFFFF;">)', value = 'yes' },
        { label = "Exit", value = 'no' },
      }
    },
    function (data, menu)
      if data.current.value == 'yes' then
		TriggerServerEvent("rpuk_core:SavePlayer")
		Citizen.Wait(500)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
		Citizen.Wait(1000)
        TriggerServerEvent('rpuk_clothes:buyclothes', price)
      end
      menu.close()
    end,
    function (data, menu)
      menu.close()
    end
  )
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then

			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				OpenGateWay()
			end
		else
			Citizen.Wait(500)
		end
	end
end)
