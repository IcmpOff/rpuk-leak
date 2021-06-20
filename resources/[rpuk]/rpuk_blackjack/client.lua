seatSideAngle = 30
bet = 0
hand = {}
splitHand = {}
--print("Initialising splitHand for first time.")
timeLeft = 0
satDownCallback = nil
standUpCallback = nil
leaveCheckCallback = nil
canSitDownCallback = nil
inZone = false

--[===[
	exports["rpuk_blackjack"]:SetSatDownCallback(function()
		-- Disable hud components?
		-- etc
	end)

	exports["rpuk_blackjack"]:SetStandUpCallback(function()
		-- Enable hud components?
		-- etc
	end)

	exports["rpuk_blackjack"]:SetLeaveCheckCallback(function()
		-- if isCuffed or isBeingCarried or isInJail??? then
		-- return true
		-- else
		-- return false
		-- end
	end)

	exports["rpuk_blackjack"]:SetCanSitDownCallback(function()
		-- if not isCuffed and not isBeingCarried and not isInJail??? then
		-- return true
		-- else
		-- return false
		-- end
	end)
--]===]

function SetSatDownCallback(cb)
	satDownCallback = cb
end

function SetStandUpCallback(cb)
	standUpCallback = cb
end

function SetLeaveCheckCallback(cb)
	leaveCheckCallback = cb
end

function SetCanSitDownCallback(cb)
	canSitDownCallback = cb
end

function Notification(text, color, blink)
	if color then ThefeedNextPostBackgroundColor(color) end
	PlaySoundFrontend(-1, "OTHER_TEXT", "HUD_AWARDS", 0)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandThefeedPostTicker(blink or false, false)
end

function DisplayHelpText(helpText, time)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringWebsite(helpText)
	EndTextCommandDisplayHelp(0, 0, 1, time or -1)
end

function SetSubtitle(subtitle, duration)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringWebsite(subtitle)
	EndTextCommandPrint(duration, true)
	DebugPrint("SUBTITLE: "..subtitle)
end

-- function translateAngle(x1, y1, ang, offset)
	-- x1 = x1 + math.sin(ang) * offset
	-- y1 = y1 + math.cos(ang) * offset
	-- return {x1, y1}
-- end

function findRotation( x1, y1, x2, y2 )
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < -180 and t + 180 or t
end

function cardValue(card)
	local rank = 10
	for i=2,11 do
		if string.find(card, tostring(i)) then
			rank = i
		end
	end
	if string.find(card, 'ACE') then
		rank = 11
	end

	return rank
end

function handValue(hand)
	local tmpValue = 0
	local numAces = 0

	for i,v in pairs(hand) do
		tmpValue = tmpValue + cardValue(v)
	end

	for i,v in pairs(hand) do
		if string.find(v, 'ACE') then numAces = numAces + 1 end
	end

	repeat
		if tmpValue > 21 and numAces > 0 then
			tmpValue = tmpValue - 10
			numAces = numAces - 1
		else
			break
		end
	until numAces == 0

	return tmpValue
end

function CanSplitHand(hand)
	--if hand[1] and hand[2] and #hand == 2 then
	--if hand[1] and hand[2] then
		--if hand[1]:sub(-3) == hand[2]:sub(-3) and #hand == 2 then
			if #hand == 2 and cardValue(hand[1]) == cardValue(hand[2]) then --allow matches on all 10/J/Q/K
				return true
			end
		--end
	--end
	return _DEBUG
end

--[[
	vw_prop_vw_chips_pile_01a.ydr -- $511,000
	vw_prop_vw_chips_pile_02a.ydr -- $3,250,000
	vw_prop_vw_chips_pile_03a.ydr -- $1,990,000
--]]

function getChips(amount)
	if amount < 500000 then
		local props = {}
		local propTypes = {}

		local d = #chipValues

		for i = 1, #chipValues do
			local iter = #props + 1
			while amount >= chipValues[d] do
				local model = chipModels[chipValues[d]]

				if not props[iter] then
					local propType = string.sub(model, 0, string.len(model) - 3)

					if propTypes[propType] then
						iter = propTypes[propType]
					else
						props[iter] = {}
						propTypes[propType] = iter
					end
				end

				props[iter][#props[iter] + 1] = model
				amount = amount - chipValues[d]
			end

			d = d - 1
		end

		return false, props
	elseif amount <= 500000 then
		return true, "vw_prop_vw_chips_pile_01a"
	elseif amount <= 5000000 then
		return true, "vw_prop_vw_chips_pile_03a"
	else
		return true, "vw_prop_vw_chips_pile_02a"
	end
end

function leaveBlackjack()
	leavingBlackjack = true
	renderScaleform = false
	renderTime = false
	renderBet = false
	renderHand = false
	selectedBet = 1
	hand = {}
	splitHand = {}
	SetFollowPedCamViewMode(1)
	--print("destroying splitHand table (leaveBlackjack() func)")
end

function s2m(s)
    if s <= 0 then
        return "00:00"
    else
        local m = string.format("%02.f", math.floor(s/60))
        return m..":"..string.format("%02.f", math.floor(s - m * 60))
    end
end

RegisterCommand("bet", function(source, args, rawCommand)
	if args[1] and _DEBUG == true then
		TriggerServerEvent("BLACKJACK:SetPlayerBet", g_bjtable, closestChair, args[1])
	end
end, false)


spawnedPeds = {}
spawnedObjects = {}
AddEventHandler("onResourceStop", function(r)
	if r == GetCurrentResourceName() then
		for i,v in ipairs(spawnedPeds) do
			DeleteEntity(v)
		end
		for i,v in ipairs(spawnedObjects) do
			DeleteEntity(v)
		end
	end
end)

renderScaleform = false
renderTime = false
renderBet = false
renderHand = false


-- HUD display thread
Citizen.CreateThread(function()

	scaleform = RequestScaleformMovie_2("INSTRUCTIONAL_BUTTONS")

	repeat Wait(0) until HasScaleformMovieLoaded(scaleform)

	while true do Wait(0)
		if renderScaleform == true then
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		end

		local barCount = {1}

		if renderTime == true and timeLeft ~= nil then
			if timeLeft > 0 then
				DrawTimerBar(barCount, "TIME", s2m(timeLeft))
			end
		end

		if renderBet == true then
			DrawTimerBar(barCount, "BET", bet)
		end

		if renderHand == true then
			if #splitHand > 0 then
				--print("HUD loop thinks we have a splitHand > 0")
				DrawTimerBar(barCount, "SPLIT", handValue(splitHand))
			end
			DrawTimerBar(barCount, "HAND", handValue(hand))
		end

		if _DEBUG == true then --PRINT OUT DEBUG OVERLAYS

			--show the split card offset positions and rotations
			for i,p in pairs(cardSplitOffsets) do
				for _,v in pairs(p) do
					for n,m in pairs(tables) do
						local x, y, z = GetObjectOffsetFromCoords(m.coords.x, m.coords.y, m.coords.z, m.coords.w, v)
						local rotz = cardSplitRotationOffsets[i][p]

						--if GetDistanceBetweenCoords(GetGameplayCamCoord(), x, y, z, true) < 5.0 then

							DrawMarker(22, v.x, v.y, chipHeights[1], 0.0, 0.0, 0.0, 0.0, 0.0, rotz, 1.0, 1.0, 1.0, 150, 150, 255, 150, false, false, false, false)
						--end
					end
				end
			end

			for i,p in pairs(chipOffsets) do
				for _,v in pairs(p) do
					for n,m in pairs(tables) do
						local x, y, z = GetObjectOffsetFromCoords(m.coords.x, m.coords.y, m.coords.z, m.coords.w, v)

						if GetDistanceBetweenCoords(GetGameplayCamCoord(), x, y, z, true) < 5.0 then

							DrawMarker(28, v.x, v.y, chipHeights[1], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 150, 150, 255, 150, false, false, false, false)

							SetTextFont(0)
							SetTextScale(0.0, 0.35)
							SetTextColour(255, 255, 255, 255)
							SetTextDropshadow(0, 0, 0, 0, 255)
							SetTextDropShadow()
							SetTextOutline()
							SetTextCentre(1)
							SetTextEntry("STRING")
							SetDrawOrigin(GetObjectOffsetFromCoords(m.coords.x, m.coords.y, m.coords.z, m.coords.w, v.x, v.y, chipHeights[1]))
							AddTextComponentString(tostring(_))
							DrawText(0.0, 0.0)
							ClearDrawOrigin()

						end
					end
				end
			end

			if hand then
				SetTextFont(0)
				SetTextScale(0.0, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextCentre(1)
				SetTextEntry("STRING")
				AddTextComponentString("HAND VALUE: "..handValue(hand))
				DrawText(0.90, 0.15)

				for i,v in ipairs(hand) do
					SetTextFont(0)
					SetTextScale(0.0, 0.35)
					SetTextColour(255, 255, 255, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextCentre(1)
					SetTextEntry("STRING")
					AddTextComponentString(v.." ("..cardValue(v)..")")
					DrawText(0.90, 0.15+(i/40))
				end

				if CanSplitHand(hand) then
					SetTextFont(0)
					SetTextScale(0.0, 0.35)
					SetTextColour(50, 255, 50, 255)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextCentre(1)
					SetTextEntry("STRING")
					AddTextComponentString("CAN SPLIT HAND")
					DrawText(0.90, 0.125)
				end

			end

			for i,v in pairs(spawnedPeds) do
				SetTextFont(0)
				SetTextScale(0.0, 0.25)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				SetTextCentre(1)
				SetDrawOrigin(GetEntityCoords(v))
				AddTextComponentString("i = "..i.. "\nv = " .. spawnedPeds[i])
				DrawText(0.0, 0.0)
				ClearDrawOrigin()
			end
			for i,v in pairs(spawnedObjects) do
				SetTextFont(0)
				SetTextScale(0.0, 0.25)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				SetTextCentre(1)
				SetDrawOrigin(GetEntityCoords(spawnedObjects[i]))
				AddTextComponentString("i = "..i.. "\nv = " .. spawnedObjects[i])
				DrawText(0.0, 0.0)
				ClearDrawOrigin()
			end
		end


	end
end)

function IsSeatOccupied(coords, radius)
	local players = GetActivePlayers()
	local playerId = PlayerId()
	for i = 1, #players do
		if players[i] ~= playerId then
			local ped = GetPlayerPed(players[i])
			if IsEntityAtCoord(ped, coords, radius, radius, radius, 0, 0, 0) then
				return true
			end
		end
	end

	return false
end

dealerHand = {}
dealerHandObjs = {}
dealerHole = {} -- used to preserve hidden holecard
handObjs = {}

function CreatePeds()
	if not HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@dealer") then
		RequestAnimDict("anim_casino_b@amb@casino@games@blackjack@dealer")
		repeat Wait(0) until HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@dealer")
	end

	if not HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@dealer@") then
		RequestAnimDict("anim_casino_b@amb@casino@games@shared@dealer@")
		repeat Wait(0) until HasAnimDictLoaded("anim_casino_b@amb@casino@games@shared@dealer@")
	end

	if not HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@player") then
		RequestAnimDict("anim_casino_b@amb@casino@games@blackjack@player")
		repeat Wait(0) until HasAnimDictLoaded("anim_casino_b@amb@casino@games@blackjack@player")
	end

--[[

	for i,v in pairs(customTables) do
		local model = `vw_prop_casino_blckjack_01`
		if v.highStakes == true then
			model = `vw_prop_casino_blckjack_01b`
		end

		if not HasModelLoaded(model) then
			RequestModel(model)
			repeat Wait(0) until HasModelLoaded(model)
		end

		local tableObj = CreateObjectNoOffset(model, v.coords.x, v.coords.y, v.coords.z, false, false, false)
		SetEntityRotation(tableObj, 0.0, 0.0, v.coords.w, 2, 1)
		SetObjectTextureVariant(tableObj, v.color or 3)
		table.insert(spawnedObjects, tableObj)
	end
--]]
	chips = {}

	hand = {}
	splitHand = {}
	--print("destroying splitHand table (CreatePeds() func)")
	handObjs = {}

	for i,v in pairs(tables) do

		dealerHand[i] = {}
		dealerHandObjs[i] = {}
		dealerHole[i] = nil
		local model = `s_f_y_casino_01`

		chips[i] = {}

		for x=1,4 do
			chips[i][x] = {}
		end
		handObjs[i] = {}

		for x=1,4 do
			handObjs[i][x] = {}
		end

		if not HasModelLoaded(model) then
			RequestModel(model)
			repeat Wait(0) until HasModelLoaded(model)
		end

		local dealer = CreatePed(4, model, v.coords.x, v.coords.y, v.coords.z, v.coords.w, false, true)
		-- local dealer = ClonePed(PlayerPedId(), 0.0, false, false)
		SetEntityCanBeDamaged(dealer, false)
		SetBlockingOfNonTemporaryEvents(dealer, true)
		SetPedCanRagdollFromPlayerImpact(dealer, false)

		-- SetPedVoiceGroup(dealer, `S_F_Y_Casino_01_ASIAN_02`)

		SetDealerVoice(dealer, i)

		-- SetPedDefaultComponentVariation(dealer)

		SetPedResetFlag(dealer, 249, true)
		SetPedConfigFlag(dealer, 185, true)
		SetPedConfigFlag(dealer, 108, true)
		SetPedConfigFlag(dealer, 208, true)

		SetDealerOutfit(dealer, i+6)

		-- NetworkSetEntityInvisibleToNetwork(dealer, true)

		-- N_0x352e2b5cf420bf3b(dealer, true)
		-- N_0x2f3c3d9f50681de4(dealer, true)

		-- SetNetworkIdCanMigrate(PedToNet(dealer), false)

		-- local scene = NetworkCreateSynchronisedScene(v.coords.x, v.coords.y, v.coords.z, vector3(0.0, 0.0, v.coords.w), 2, true, true, 1065353216, 0, 1065353216)
		-- NetworkAddPedToSynchronisedScene(dealer, scene, "anim_casino_b@amb@casino@games@shared@dealer@", "idle", 2.0, -2.0, 13, 16, 1148846080, 0)
		-- NetworkStartSynchronisedScene(scene)

		local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
		TaskSynchronizedScene(dealer, scene, "anim_casino_b@amb@casino@games@shared@dealer@", "idle", 1000.0, -8.0, 4, 1, 1148846080, 0)

		-- TaskLookAtEntity(dealer, PlayerPedId(), -1, 2048, 3)

		-- Wait(1500)

		-- TaskPlayAnim(dealer, anim, "idle", 4.0, -1.0, -1, 0, -1.0, true, true, true)

		spawnedPeds[i] = dealer
	end
end

-- function getCardOffset(seat, cardIndex)
	-- if seat == 1 then
		-- if cardIndex =
	-- end
-- end

RegisterNetEvent("BLACKJACK:SyncTimer")
AddEventHandler("BLACKJACK:SyncTimer", function(_timeLeft)
	timeLeft = _timeLeft
end)

RegisterNetEvent("BLACKJACK:PlayDealerAnim")
AddEventHandler("BLACKJACK:PlayDealerAnim", function(i, animDict, anim)

	--[[
	animDict could be any of:
	(i) anim_casino_b@amb@casino@games@blackjack@dealer@

		female_place_bet_request
		female_deal_card_player_0 .. 5-v.seat
		female_deal_card_self
		female_deal_card_self_second_card
		female_check_and_turn_card
		female_check_card
		female_turn_card
		female_dealer_focus_player_0.. 5-v.seat .._idle_intro
		female_dealer_focus_player_0.. 5-v.seat .._idle
		female_dealer_focus_player_0.. 5-v.seat .._idle_outro
		female_hit_card_player_0 .. 5-v.seat
		female_split_card_player_0 .. 5-v.seat
		female_hit_second_card_player_0 .. 5-v.seat
		female_dealer_focus_player_0.. 5-v.seat .._idle_intro_split
		female_dealer_focus_player_0.. 5-v.seat .._idle_split
		female_dealer_focus_player_0.. 5-v.seat .._idle_outro_split
		female_retrieve_cards_player_0.. 5-v.seat
		female_retrieve_own_cards_and_remove

	(ii) anim_casino_b@amb@casino@games@shared@dealer@

		female_dealer_reaction_impartial_var0..math.random(1,3)
		female_dealer_reaction_good_var0..math.random(1,3)
		female_dealer_reaction_bad_var0..math.random(1,3)


	--]]

	if inZone then

		Citizen.CreateThread(function()

			local v = tables[i]

			if not HasAnimDictLoaded(animDict) then
				RequestAnimDict(animDict)
				repeat Wait(0) until HasAnimDictLoaded(animDict)
			end

			-- if GetEntityModel(spawnedPeds[i]) == `s_f_y_casino_01` then
				-- anim = "female_"..anim
			-- end

			DebugPrint("PLAYING "..anim:upper().." ON DEALER "..i)

			-- if seat == 0 then
				-- local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
				-- TaskSynchronizedScene(spawnedPeds[i], scene, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_deal_card_self", 1000.0, -8.0, 4, 1, 1148846080, 0)
			-- else
				-- local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
				-- TaskSynchronizedScene(spawnedPeds[i], scene, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_deal_card_player_0" .. 5-seat, 1000.0, -8.0, 4, 1, 1148846080, 0)
			-- end

			if anim == "female_turn_card" or anim == "female_check_and_turn_card" or anim == "female_check_card" then

				local cardObj = dealerHandObjs[i][1]
				local cardX,cardY,cardZ = GetEntityCoords(cardObj)
				
				if anim == "female_turn_card" or anim == "female_check_and_turn_card" then --swap joker back to correct card for reveal
					local truecard = dealerHole[i]
					local model = GetHashKey("vw_prop_cas_card_"..truecard)
					local cardP, cardR, cardY, cardRO = GetEntityRotation(cardObj)

					RequestModel(model)
					repeat Wait(0) until HasModelLoaded(model)

					local truecardObj = CreateObjectNoOffset(model, cardX, cardY, cardZ, false, false, false)
					SetEntityRotation(truecardObj, cardP, cardR, cardY, cardRO, true)

					table.insert(spawnedObjects, truecardObj)
					--table.remove(spawnedObjects, cardObj)
					DeleteEntity(cardObj)
					cardObj = truecardObj
					table.insert(dealerHandObjs[i], cardObj)
				end
					
				
				--AttachEntityToEntity(cardObj, spawnedPeds[i], GetPedBoneIndex(spawnedPeds[i],28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)

				local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
				--TaskSynchronizedScene( ped --[[ Ped ]], scene --[[ integer ]], animDictionary --[[ string ]], animationName --[[ string ]], blendInSpeed --[[ number ]], blendOutSpeed --[[ number ]], duration --[[ integer ]], flag --[[ integer ]], playbackRate --[[ number ]], p9 --[[ Any ]])
				TaskSynchronizedScene(spawnedPeds[i], scene, animDict, anim, 1000.0, -8.0, 4, 1, 1148846080, 0)

				PlayFacialAnim(spawnedPeds[i], "female_check_card_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")

				while not HasAnimEventFired(spawnedPeds[i],-1345695206) do
					--DebugPrint("waiting for -1345695206 to fire")
					Wait(0)
				end
				AttachEntityToEntity(cardObj, spawnedPeds[i], GetPedBoneIndex(spawnedPeds[i],28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)

				while not HasAnimEventFired(spawnedPeds[i],585557868) do
					--DebugPrint("waiting for 585557868 to fire")
					Wait(0)
				end
				DetachEntity(cardObj,false,true)

			elseif string.sub(anim, 1, -2) == "female_retrieve_cards_player_0" then

				local chairID = string.sub(anim, -2)

				local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
				TaskSynchronizedScene(spawnedPeds[i], scene, animDict, anim, 1000.0, -8.0, 4, 1, 1148846080, 0)
				PlayFacialAnim(spawnedPeds[i], "female_retrieve_cards_player_0" .. chairID .."_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")

				while not HasAnimEventFired(spawnedPeds[i],-1345695206) do
					--DebugPrint("waiting for -1345695206 to fire")
					Wait(0)
				end
				for k,v in pairs(handObjs[i][5-chairID]) do
					AttachEntityToEntity(v, spawnedPeds[i], GetPedBoneIndex(spawnedPeds[i],28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
				end

				while not HasAnimEventFired(spawnedPeds[i],585557868) do
					--DebugPrint("waiting for 585557868 to fire")
					Wait(0)
				end
				for k,v in pairs(handObjs[i][5-chairID]) do
					DetachEntity(v,false,true)
				end

			elseif anim == "female_retrieve_own_cards_and_remove" then

				local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
				TaskSynchronizedScene(spawnedPeds[i], scene, animDict, anim, 1000.0, -8.0, 4, 1, 1148846080, 0)
				PlayFacialAnim(spawnedPeds[i], "female_retrieve_own_cards_and_remove_facial", "anim_casino_b@amb@casino@games@blackjack@dealer")

				while not HasAnimEventFired(spawnedPeds[i],-1345695206) do
					--DebugPrint("waiting for -1345695206 to fire")
					Wait(0)
				end
				for k,v in pairs(dealerHandObjs[i]) do
					AttachEntityToEntity(v, spawnedPeds[i], GetPedBoneIndex(spawnedPeds[i],28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)
				end

				while not HasAnimEventFired(spawnedPeds[i],585557868) do
					--DebugPrint("waiting for 585557868 to fire")
					Wait(0)
				end
				for k,v in pairs(dealerHandObjs[i]) do
					DetachEntity(v,false,true)
				end

			else

				local scene = CreateSynchronizedScene(v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, v.coords.w, 2)
				--TaskSynchronizedScene( ped --[[ Ped ]], scene --[[ integer ]], animDictionary --[[ string ]], animationName --[[ string ]], blendInSpeed --[[ number ]], blendOutSpeed --[[ number ]], duration --[[ integer ]], flag --[[ integer ]], playbackRate --[[ number ]], p9 --[[ Any ]])
				TaskSynchronizedScene(spawnedPeds[i], scene, animDict, anim, 1000.0, -8.0, 4, 1, 1148846080, 0)

			end

		end)
	end
end)

RegisterNetEvent("BLACKJACK:PlayDealerSpeech")
AddEventHandler("BLACKJACK:PlayDealerSpeech", function(i, speech)
	if inZone then
		Citizen.CreateThread(function()
			DebugPrint("PLAYING SPEECH "..speech:upper().." ON DEALER "..i)
			StopCurrentPlayingAmbientSpeech(spawnedPeds[i])
			PlayAmbientSpeech1(spawnedPeds[i], speech, "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
		end)
	end
end)

RegisterNetEvent("BLACKJACK:DealerTurnOverCard")
AddEventHandler("BLACKJACK:DealerTurnOverCard", function(i)
	if inZone then
		SetEntityRotation(dealerHandObjs[i][1], 0.0, 0.0, tables[i].coords.w + cardRotationOffsetsDealer[1].z)
	end
end)

RegisterNetEvent("BLACKJACK:SplitPlayerHand")
--TriggerClientEvent("BLACKJACK:SplitPlayerHand", -1, index, v.seat, #v.splitHand, v.hand, v.splitHand)
AddEventHandler("BLACKJACK:SplitPlayerHand", function(index, seat, splitHandSize, _hand, _splitHand)

	if inZone then

		if index == g_bjtable and seat == closestChair then
			hand = _hand
			splitHand = _splitHand
			DebugPrint("SplitPlayerHand: Created a new hand and splitHand for player in seat: ".. seat .. " on table: " .. index)
		end

		DebugPrint("splitHandSize = "..splitHandSize)
		DebugPrint("split card coord = "..tostring(GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, cardSplitOffsets[5-seat][1])))

		SetEntityCoordsNoOffset(handObjs[index][seat][#handObjs[index][seat]], GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, cardSplitOffsets[5-seat][1]))
		SetEntityRotation(handObjs[index][seat][#handObjs[index][seat]], 0.0, 0.0, tables[index].coords.w + cardSplitRotationOffsets[5-seat][splitHandSize])

	end
end)

selectedBet = 1

--[[
	--Get chip offsets
	Citizen.CreateThread(function()
		local selectedOffset = { x=0.0, y=0.0, z=0.0 }
		while true do
			Citizen.Wait(0)

			if inZone then

				if selectedTable and selectedChip then
					if IsControlPressed(1, 108) then -- y-selectedOffset.x, selectedOffset.y
						selectedOffset.y = selectedOffset.y - 0.01
					end

					if IsControlPressed(1, 107) then -- y+
						selectedOffset.y = selectedOffset.y + 0.01
					end

					if IsControlPressed(1, 111) then -- x-
						selectedOffset.x = selectedOffset.x - 0.01
					end

					if IsControlPressed(1, 112) then -- x+
						selectedOffset.x = selectedOffset.x + 0.01
					end

					if IsControlPressed(1, 117) then -- rotate left
						selectedOffset.z = selectedOffset.z - 0.1
						if selectedOffset.z < 0 then selectedOffset.z = 360.0 end
					end

					if IsControlPressed(1, 118) then -- rotate right
						selectedOffset.z = selectedOffset.z + 0.1
						if selectedOffset.z > 360 then selectedOffset.z = 0.0 end
					end

					SetEntityCoordsNoOffset(selectedChip, GetObjectOffsetFromCoords(tables[selectedTable].coords.x, tables[selectedTable].coords.y, tables[selectedTable].coords.z, tables[selectedTable].coords.w, selectedOffset.x, selectedOffset.y, chipHeights[1]))
					SetEntityRotation(selectedChip, 0.0, 0.0, tables[selectedTable].coords.w + selectedOffset.z)

					SetTextScale(0.5, 0.5)
					SetTextColour(255,255,255,255)
					SetTextDropShadow(0, 0, 0, 0,255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("~b~"..selectedOffset.x..", "..selectedOffset.y..", "..selectedOffset.z)
					DrawText(0.3,0.8)
				end

			end
		end
	end)
--]]

RegisterNetEvent("BLACKJACK:PlaceBetChip")
AddEventHandler("BLACKJACK:PlaceBetChip", function(index, seat, bet, double, split)

	if inZone then

		Citizen.CreateThread(function()
			local chipPile, props = getChips(bet)

			if chipPile then
				local model = GetHashKey(props)

				DebugPrint(bet)
				DebugPrint(seat)
				DebugPrint(tostring(props))
				DebugPrint(tostring(pileOffsets[seat]))

				RequestModel(model)
				repeat Wait(0) until HasModelLoaded(model)
				local location = 1
				if double == true then location = 2 end

				local chip = CreateObjectNoOffset(model, tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, false, false, false)

				table.insert(spawnedObjects, chip)
				table.insert(chips[index][seat], chip)

				if split == false then
					SetEntityCoordsNoOffset(chip, GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, pileOffsets[seat][location].x, pileOffsets[seat][location].y, chipHeights[1]))
					SetEntityRotation(chip, 0.0, 0.0, tables[index].coords.w + pileRotationOffsets[seat][3 - location].z)
				else
					SetEntityCoordsNoOffset(chip, GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, pileOffsets[seat][2].x, pileOffsets[seat][2].y, chipHeights[1]))
					SetEntityRotation(chip, 0.0, 0.0, tables[index].coords.w + pileRotationOffsets[seat][3 - location].z)
				end

				--Get chip offsets
				--selectedChip = chip
				--selectedTable = index
			else
				local chipXOffset = 0.0
				local chipYOffset = 0.0

				if split or double then
					if seat == 1 then
						chipXOffset = chipXOffset + 0.03
						chipYOffset = chipYOffset + 0.05
					elseif seat == 2 then
						chipXOffset = chipXOffset + 0.05
						chipYOffset = chipYOffset + 0.02
					elseif seat == 3 then
						chipXOffset = chipXOffset + 0.05
						chipYOffset = chipYOffset - 0.02
					elseif seat == 4 then
						chipXOffset = chipXOffset + 0.02
						chipYOffset = chipYOffset - 0.05
					end
				end

				for i = 1, #props do
					local chipGap = 0.0

					for j = 1, #props[i] do
						local model = GetHashKey(props[i][j])

						DebugPrint(bet)
						DebugPrint(seat)
						DebugPrint(tostring(props[i][j]))
						DebugPrint(tostring(chipOffsets[seat]))

						RequestModel(model)
						repeat Wait(0) until HasModelLoaded(model)

						local location = i
						-- if double == true then location = 2 end

						local chip = CreateObjectNoOffset(model, tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, false, false, false)

						table.insert(spawnedObjects, chip)
						table.insert(chips[index][seat], chip)

						-- if split == false and double == false then
							SetEntityCoordsNoOffset(chip, GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, chipOffsets[seat][location].x + chipXOffset, chipOffsets[seat][location].y + chipYOffset, chipHeights[1] + chipGap))
							SetEntityRotation(chip, 0.0, 0.0, tables[index].coords.w + chipRotationOffsets[seat][location].z)
						-- else
							-- SetEntityCoordsNoOffset(chip, GetObjectOffsetFromCoords(tables[index].coords.x, tables[index].coords.y, tables[index].coords.z, tables[index].coords.w, chipSplitOffsets[seat][location].x + chipXOffset, chipSplitOffsets[seat][location].y + chipYOffset, chipHeights[1] + chipGap))
							-- SetEntityRotation(chip, 0.0, 0.0, tables[index].coords.w + chipSplitRotationOffsets[seat][location].z)
						-- end

						chipGap = chipGap + ((chipThickness[model] ~= nil) and chipThickness[model] or 0.0)
					end

					-- Hacky way to setup each seats split chips
				end
			end
		end)

	end
end)

RegisterNetEvent("BLACKJACK:BetReceived")

local upPressed = false
local downPressed = false

RegisterNetEvent("BLACKJACK:RequestBets")
AddEventHandler("BLACKJACK:RequestBets", function(index, _timeLeft)
	timeLeft = _timeLeft
	if leavingBlackjack == true then leaveBlackjack() return end

	Citizen.CreateThread(function()
		scrollerIndex = index
		renderScaleform = true
		renderTime = true
		renderBet = true

		PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
		PopScaleformMovieFunctionVoid()

		BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(80)
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 194, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Exit")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(1)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 201, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Place Bet")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(2)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 204, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Max Bet")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(3)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 208, 0))
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 207, 0))
		ScaleformMovieMethodAddParamPlayerNameString("Adjust Bet")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		EndScaleformMovieMethod()

		if (tables[scrollerIndex].highStakes == true) and selectedBet < highTableLowLimit then
			selectedBet = highTableLowLimit
		end

		while true do Wait(0)
			local tableLimit = (tables[scrollerIndex].highStakes == true) and #bettingNums or lowTableLimit
			local tableMinLimit = (tables[scrollerIndex].highStakes == true) and highTableLowLimit or 1

			--DebugPrint("tableMinLimit: ".. tableMinLimit)

			if IsControlJustPressed(1, 204) then -- TAB / Y
				selectedBet = tableLimit
			elseif IsControlJustPressed(0, 194) then -- BACKSPACE / B
				leavingBlackjack = true
				renderScaleform = false
				renderTime = false
				renderBet = false
				renderHand = false
				selectedBet = 1
				return
			end

			if not upPressed then
				if IsControlJustPressed(1, 208) then -- (PG-UP) RIGHT ARROW / DPAD RIGHT
					upPressed = true
					Citizen.CreateThread(function()
						selectedBet = selectedBet + 1
						if selectedBet > tableLimit then selectedBet = tableMinLimit end
						Citizen.Wait(175)
						while IsControlPressed(1, 208) do
							selectedBet = selectedBet + 1
							if selectedBet > tableLimit then selectedBet = tableMinLimit end
							Citizen.Wait(125)
						end

						upPressed = false
					end)
				end
			end

			if not downPressed then
				if IsControlJustPressed(1, 207) then -- (PG-DN) LEFT ARROW / DPAD LEFT
					downPressed = true
					Citizen.CreateThread(function()
						selectedBet = selectedBet - 1
						if selectedBet < tableMinLimit then selectedBet = tableLimit end
						Citizen.Wait(175)
						while IsControlPressed(1, 207) do
							selectedBet = selectedBet - 1
							if selectedBet < tableMinLimit then selectedBet = tableLimit end
							Citizen.Wait(125)
						end

						downPressed = false
					end)
				end
			end

			bet = bettingNums[selectedBet] or 10000

			if #bettingNums < lowTableLimit and tables[scrollerIndex].highStakes == true then
				bet = bet * 10
			end

			if IsControlJustPressed(1, 201) then -- ENTER / A

				TriggerServerEvent("BLACKJACK:CheckPlayerBet", g_bjtable, bet)

				local betCheckReceived = false
				local canBet = false
				local eventHandler = AddEventHandler("BLACKJACK:BetReceived", function(_canBet)
					betCheckReceived = true
					canBet = _canBet
				end)

				repeat Wait(0) until betCheckReceived == true

				RemoveEventHandler(eventHandler)

				if canBet then
					renderScaleform = false
					renderTime = false
					renderBet = false
					if selectedBet < 27 then
						if leavingBlackjack == true then leaveBlackjack() return end

						local anim = "place_bet_small"

						playerBusy = true
						local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)

						Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

						if leavingBlackjack == true then leaveBlackjack() return end

						TriggerServerEvent("BLACKJACK:SetPlayerBet", g_bjtable, closestChair, bet, selectedBet, false)

						Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

						if leavingBlackjack == true then leaveBlackjack() return end

						playerBusy = false

						local idleVar = "idle_var_0"..math.random(1,5)

						DebugPrint("IDLING POST-BUSY: "..idleVar)

						local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)
					else
						if leavingBlackjack == true then leaveBlackjack() return end

						local anim = "place_bet_large"

						playerBusy = true
						local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)

						Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

						if leavingBlackjack == true then leaveBlackjack() return end

						TriggerServerEvent("BLACKJACK:SetPlayerBet", g_bjtable, closestChair, bet, selectedBet, false)

						Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

						if leavingBlackjack == true then leaveBlackjack() return end

						playerBusy = false

						local idleVar = "idle_var_0"..math.random(1,5)

						DebugPrint("IDLING POST-BUSY: "..idleVar)

						local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
						NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
						NetworkStartSynchronisedScene(scene)
					end
					return
				else
					DisplayHelpText("You don't have enough chips for the bet.", 5000)
				end
			end
		end
		-- TriggerServerEvent("BLACKJACK:SetPlayerBet", g_bjtable, closestChair, bet)
	end)
end)

RegisterNetEvent("BLACKJACK:RequestMove")
AddEventHandler("BLACKJACK:RequestMove", function(_timeLeft)
	Citizen.CreateThread(function()
		timeLeft = _timeLeft
		if leavingBlackjack == true then leaveBlackjack() return end

		renderScaleform = true
		renderTime = true
		renderHand = true

		BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(80)
		EndScaleformMovieMethod()

		-- BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		-- ScaleformMovieMethodAddParamInt(0)
		-- ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 51, 0))
		-- ScaleformMovieMethodAddParamPlayerNameString("Quit")
		-- EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(1)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 203, 0)) --SPACEBAR
		ScaleformMovieMethodAddParamPlayerNameString("Hit")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(2)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 194, 0)) --BACKSPACE
		ScaleformMovieMethodAddParamPlayerNameString("Stand")
		EndScaleformMovieMethod()

		if #hand < 3 and #splitHand == 0 then
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(3)
			ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 192, 0)) --TAB
			ScaleformMovieMethodAddParamPlayerNameString("Double Down")
			EndScaleformMovieMethod()
		end

		if CanSplitHand(hand) == true then
			BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
			ScaleformMovieMethodAddParamInt(4)
			ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 209, 0)) --LEFT SHIFT
			ScaleformMovieMethodAddParamPlayerNameString("Split")
			EndScaleformMovieMethod()
		end

		BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		EndScaleformMovieMethod()

		while true do Wait(0)
			if IsControlJustPressed(1, 203) then --SPACEBAR (HIT)
				if leavingBlackjack == true then DebugPrint("returning") return end

				TriggerServerEvent("BLACKJACK:ReceivedMove", "hit")

				renderScaleform = false
				renderTime = false
				renderHand = false
				local anim = requestCardAnims[math.random(1,#requestCardAnims)]

				playerBusy = true
				local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)
				Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*990))

				if leavingBlackjack == true then leaveBlackjack() return end

				playerBusy = false

				local idleVar = "idle_var_0"..math.random(1,5)

				DebugPrint("IDLING POST-BUSY: "..idleVar)

				local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)

				return
			end
			if IsControlJustPressed(0, 194) then --BACKSPACE (STAND)
				if leavingBlackjack == true then leaveBlackjack() return end

				TriggerServerEvent("BLACKJACK:ReceivedMove", "stand")

				renderScaleform = false
				renderTime = false
				renderHand = false
				local anim = declineCardAnims[math.random(1,#declineCardAnims)]

				playerBusy = true
				local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)
				Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*990))

				if leavingBlackjack == true then leaveBlackjack() return end

				playerBusy = false

				local idleVar = "idle_var_0"..math.random(1,5)

				DebugPrint("IDLING POST-BUSY: "..idleVar)

				local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
				NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
				NetworkStartSynchronisedScene(scene)

				return
			end
			if IsControlJustPressed(1, 192) and #hand == 2 and #splitHand == 0 then --TAB (DOUBLE-DOWN)
				if leavingBlackjack == true then leaveBlackjack() return end

				TriggerServerEvent("BLACKJACK:CheckPlayerBet", g_bjtable, bet)

				local betCheckReceived = false
				local canBet = false
				local eventHandler = AddEventHandler("BLACKJACK:BetReceived", function(_canBet)
					betCheckReceived = true
					canBet = _canBet
				end)

				repeat Wait(0) until betCheckReceived == true

				RemoveEventHandler(eventHandler)

				if canBet then
					if leavingBlackjack == true then leaveBlackjack() return end

					TriggerServerEvent("BLACKJACK:ReceivedMove", "double")

					renderScaleform = false
					renderTime = false
					renderHand = false
					local anim = "place_bet_double_down"

					playerBusy = true
					local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
					NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
					NetworkStartSynchronisedScene(scene)
					Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

					if leavingBlackjack == true then leaveBlackjack() return end

					TriggerServerEvent("BLACKJACK:SetPlayerBet", g_bjtable, closestChair, bet, selectedBet, true)

					Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

					if leavingBlackjack == true then leaveBlackjack() return end

					playerBusy = false

					local idleVar = "idle_var_0"..math.random(1,5)

					DebugPrint("IDLING POST-BUSY: "..idleVar)

					local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
					NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
					NetworkStartSynchronisedScene(scene)

					return
				else
					DisplayHelpText("You don't have enough chips to double down.", 5000)
				end
			end
			if IsControlJustPressed(1, 209) and CanSplitHand(hand) == true then --LEFT SHIFT (SPLIT)
				if leavingBlackjack == true then leaveBlackjack() return end

				TriggerServerEvent("BLACKJACK:CheckPlayerBet", g_bjtable, bet)

				local betCheckReceived = false
				local canBet = false
				local eventHandler = AddEventHandler("BLACKJACK:BetReceived", function(_canBet)
					betCheckReceived = true
					canBet = _canBet
				end)

				repeat Wait(0) until betCheckReceived == true

				RemoveEventHandler(eventHandler)

				if canBet then
					if leavingBlackjack == true then leaveBlackjack() return end

					TriggerServerEvent("BLACKJACK:ReceivedMove", "split")

					renderScaleform = false
					renderTime = false
					renderHand = false
					local anim = "place_bet_small_split"

					if selectedBet > 27 then
						anim = "place_bet_large_split"
					end

					playerBusy = true
					local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, false, 1065353216, 0, 1065353216)
					NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@blackjack@player", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
					NetworkStartSynchronisedScene(scene)
					Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

					if leavingBlackjack == true then leaveBlackjack() return end

					TriggerServerEvent("BLACKJACK:SetPlayerBet", g_bjtable, closestChair, bet, selectedBet, false, true)

					Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@blackjack@player", anim)*500))

					if leavingBlackjack == true then leaveBlackjack() return end

					playerBusy = false

					local idleVar = "idle_var_0"..math.random(1,5)

					DebugPrint("IDLING POST-BUSY: "..idleVar)

					local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
					NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
					NetworkStartSynchronisedScene(scene)

					return
				else
					DisplayHelpText("You don't have enough chips to split.", 5000)
				end
			end

			-- not yet
			-- if IsControlJustPressed(1, 51) then
				-- TriggerServerEvent("BLACKJACK:ReceivedMove", "leave")
				-- leavingBlackjack = true
				-- return
			-- end
		end
	end)
end)

RegisterNetEvent("BLACKJACK:GameEndReaction")
--TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "impartial",      "Blackjack",                      false)
--TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "bad",            "Blackjack",                      false)
--TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, splitMainReaction, tostring(handValue(dealerHand)), true, splitReaction, "good")
AddEventHandler("BLACKJACK:GameEndReaction", function(result, dealerHandValue, split, splitReaction, firstReaction)
	Citizen.CreateThread(function()

		local hideDealerResult = false --used to prevent dealer hand being displayed early

		if split == true then

			if #hand == 2 and handValue(hand) == 21 and firstReaction == "good" then
				reactionMsg = "Left hand has Blackjack!"
			elseif handValue(hand) > 21 and firstReaction ~= "good" then
				reactionMsg = "Left hand went bust."
				hideDealerResult = true
			else
				reactionMsg = "Left hand " .. resultNames[firstReaction] .. " with ".. tostring(handValue(hand)) .. "."
			end

			if #splitHand == 2 and handValue(splitHand) == 21 and splitReaction == "good"then
				reactionMsg = reactionMsg .. "\nRight hand has Blackjack!"
			elseif handValue(splitHand) > 21 and splitReaction ~= "good" then
				reactionMsg = reactionMsg .. "\nRight hand went bust."
				hideDealerResult = true
			else
				reactionMsg = reactionMsg .. "\nRight hand " .. resultNames[splitReaction] .. " with " .. tostring(handValue(splitHand)) .. "."
			end

		else
			if #hand == 2 and handValue(hand) == 21 and result == "good" then
				reactionMsg = "You have Blackjack!"
				hideDealerResult = true
			elseif handValue(hand) > 21 and result ~= "good" then
				reactionMsg = "You went bust."
				hideDealerResult = true
			else
				reactionMsg = "You ".. resultNames[result].. " with " .. tostring(handValue(hand)) .. "."
			end
		end

		if not hideDealerResult then
			if dealerHandValue == "Blackjack" or dealerHandValue <= 21 then
				reactionMsg = reactionMsg .. "\nDealer had " .. tostring(dealerHandValue) .. "."
			else
				reactionMsg = reactionMsg .. "\nDealer bust with " .. tostring(dealerHandValue) .. "."
			end
		end

		DisplayHelpText(reactionMsg, 5000)


		hand = {}
		splitHand = {}
		--print("destroying splitHand table (EventHandler GameEndReaction EH)")
		renderHand = false
		-- handObjs = {}
		-- handObjs[i] = {}

		-- for x=1,4 do
			-- handObjs[i][x] = {}
		-- end
		if leavingBlackjack == true then leaveBlackjack() return end

		local anim = "reaction_"..result.."_var_0"..math.random(1,4)

		DebugPrint("Reacting: "..anim)

		playerBusy = true
		local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, false, false, 1065353216, 0, 1065353216)
		NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", anim, 2.0, -2.0, 13, 16, 1148846080, 0)
		NetworkStartSynchronisedScene(scene)
		Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@shared@player@", anim)*990))

		if leavingBlackjack == true then leaveBlackjack() return end

		playerBusy = false

		idleVar = "idle_var_0"..math.random(1,5)

		local scene = NetworkCreateSynchronisedScene(g_coords, g_rot, 2, true, true, 1065353216, 0, 1065353216)
		NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
		NetworkStartSynchronisedScene(scene)
	end)
end)

RegisterNetEvent("BLACKJACK:RetrieveCards")
AddEventHandler("BLACKJACK:RetrieveCards", function(i, seat)

	if inZone then
		DebugPrint("TABLE "..i..": DELETE SEAT ".. seat .." CARDS")
		-- if g_bjtable == i then
			-- for z,v in pairs(chips[i]) do
				-- if v then
					-- DeleteEntity(v)
				-- end
			-- end
		-- end

		-- DeleteEntity(chips[i][seat])

		while not HasAnimEventFired(spawnedPeds[i],585557868) do
			--DebugPrint("EVENTHANDLER:RetrieveCards: waiting for 585557868 to fire")
			Wait(0)
		end


		if seat == 0 then
			for x,v in pairs(dealerHandObjs[i]) do
				DeleteEntity(v)
				dealerHandObjs[i][x] = nil
			end
		else
			for x,v in pairs(handObjs[i][seat]) do
				DeleteEntity(v)
				-- handObjs[i][seat][x] = nil
				-- table.remove(handObjs[i][seat], i)
			end
			for x,v in pairs(chips[i][5-seat]) do
				DeleteEntity(v)
			end
		end

	end
end)

RegisterNetEvent("BLACKJACK:GiveCard")
--TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.hand+1, card, false, false)
--TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.splitHand+1, card, false, true)
AddEventHandler("BLACKJACK:GiveCard", function(i, seat, handSize, card, flipped, split, doubledown)

	if inZone then

		flipped = flipped or false
		split = split or false
		doubledown = doubledown or false
		
		local model = GetHashKey("vw_prop_cas_card_"..card)


		if i == g_bjtable and seat == closestChair then
			if split == true then
				table.insert(splitHand, card)
				--print("inserted card into splitHand (Eventhandler GiveCard EH)")
			else
				table.insert(hand, card)
			end

			DebugPrint("GOT CARD "..card.." ("..cardValue(card)..")")
			DebugPrint("HAND VALUE "..handValue(hand))
		elseif seat == 0 then
			
			if handSize == 1 then
				--dealer hole-card - substitute joker
				model = GetHashKey("vw_prop_casino_cards_single")
				dealerHole[i] = card
			end
			table.insert(dealerHand[i], card)
		end

		RequestModel(model)
		repeat Wait(0) until HasModelLoaded(model)

		local cardObj = CreateObjectNoOffset(model, tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, false, false, false)

		table.insert(spawnedObjects, cardObj)

		-- if seat == closestChair then
			-- table.insert(handObjs, cardObj)
		-- end

		if seat > 0 then
			table.insert(handObjs[i][seat], cardObj)
		end

		-- SetNetworkIdCanMigrate(ObjToNet(cardObj), false)

		AttachEntityToEntity(cardObj, spawnedPeds[i], GetPedBoneIndex(spawnedPeds[i], 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)

		Wait(500)

		-- AttachEntityToEntity(cardObj, spawnedPeds[i], GetPedBoneIndex(spawnedPeds[i], 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 1, 2, 1)

		Wait(800)

		DetachEntity(cardObj, 0, true)

		if seat == 0 then
			table.insert(dealerHandObjs[i], cardObj)

			SetEntityCoordsNoOffset(cardObj, GetObjectOffsetFromCoords(tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, tables[i].coords.w, cardOffsetsDealer[handSize]))

			if flipped == true then
				SetEntityRotation(cardObj, 180.0, 0.0, tables[i].coords.w + cardRotationOffsetsDealer[handSize].z)
			else
				SetEntityRotation(cardObj, 0.0, 0.0, tables[i].coords.w + cardRotationOffsetsDealer[handSize].z)
			end
		else
			if split == true then
				SetEntityCoordsNoOffset(cardObj, GetObjectOffsetFromCoords(tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, tables[i].coords.w, cardSplitOffsets[5-seat][handSize]))
				SetEntityRotation(cardObj, 0.0, 0.0, tables[i].coords.w + cardSplitRotationOffsets[5-seat][handSize])
			elseif doubledown == true then
				SetEntityCoordsNoOffset(cardObj, GetObjectOffsetFromCoords(tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, tables[i].coords.w, cardOffsets[5-seat][handSize]))
				SetEntityRotation(cardObj, 0.0, 0.0, tables[i].coords.w + cardRotationOffsets[5-seat][handSize] + 90)
			else
				SetEntityCoordsNoOffset(cardObj, GetObjectOffsetFromCoords(tables[i].coords.x, tables[i].coords.y, tables[i].coords.z, tables[i].coords.w, cardOffsets[5-seat][handSize]))
				SetEntityRotation(cardObj, 0.0, 0.0, tables[i].coords.w + cardRotationOffsets[5-seat][handSize])
			end
		end

		-- DebugPrint(cardOffsets[5-seat][handSize])
	end
end)

--Using the RPUK_Zones to trigger in radius check rpuk_zones (client.lua/229-245)
AddEventHandler('rpuk_blackjack:InZoneRange', function(boolValue)
	inZone = boolValue
end)

function ProcessTables()  --RUNS ONCE from resource start, but hangs around till player dead
	RequestAnimDict("anim_casino_b@amb@casino@games@shared@player@")

	while true do Wait(0)

		if inZone then

			local playerPed = PlayerPedId()

			if not IsEntityDead(playerPed) and not IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) then --Player Alive?
				for i,v in pairs(tables) do       --iterate all tables
					local cord = v.coords
					local highStakes = v.highStakes

					if GetDistanceBetweenCoords(cord.x, cord.y, cord.z, GetEntityCoords(PlayerPedId()), true) < 3.0 then --player near tables

						-- local pCoords = vector3(cord.x, cord.y, cord.z)
						local pCoords = GetEntityCoords(PlayerPedId())
						local tableObj = GetClosestObjectOfType(pCoords, 1.0, `vw_prop_casino_blckjack_01`, false, false, false)
						-- highStakes = false

						if GetEntityCoords(tableObj) == vector3(0.0, 0.0, 0.0) then
							tableObj = GetClosestObjectOfType(pCoords, 1.0, `vw_prop_casino_blckjack_01b`, false, false, false)
							-- highStakes = true
						end

						if GetEntityCoords(tableObj) ~= vector3(0.0, 0.0, 0.0) then --we have a valid BJ table, find the nearest chair (bit hacky tbh)
							closestChair = 1
							local coords = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..closestChair))
							local rot = GetWorldRotationOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..closestChair))
							dist = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), true) --why not set dist to 10 and just do loop below?

							for i=1,4 do
								local coords = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..i))
								if GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), true) < dist then
									dist = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), true) --gurgle... sucky... wasted repeat
									closestChair = i
								end
							end

							local coords = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..closestChair)) --oof, we already had this!
							local rot = GetWorldRotationOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Chair_Base_0"..closestChair))

							g_coords = coords --ok, so we got there in the end. Coords and Rotation of closest chair
							g_rot = rot

							local angle = rot.z-findRotation(coords.x, coords.y, pCoords.x, pCoords.y)+90.0

							local seatAnim = "sit_enter_"

							if angle > 0 then seatAnim = "sit_enter_left" end
							if angle < 0 then seatAnim = "sit_enter_right" end
							if angle > seatSideAngle or angle < -seatSideAngle then seatAnim = seatAnim .. "_side" end

							local canSit = true

							if canSitDownCallback ~= nil then
								canSit = canSitDownCallback()
							end

							if GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), true) < 1.5 and not IsSeatOccupied(coords, 0.5) and canSit then
								if highStakes then
									DisplayHelpText("Press ~INPUT_CONTEXT~ to play High-Limit Blackjack.")
								else
									DisplayHelpText("Press ~INPUT_CONTEXT~ to play Blackjack.")
								end

								if _DEBUG == true then
									SetTextFont(0)
									SetTextScale(0.0, 0.45)
									SetTextColour(255, 255, 255, 255)
									SetTextDropshadow(0, 0, 0, 0, 255)
									SetTextDropShadow()
									SetTextOutline()
									SetTextEntry("STRING")
									SetTextCentre(1)
									SetDrawOrigin(cord.x, cord.y, cord.z)
									AddTextComponentString("table = "..i)
									DrawText(0.0, 0.0)
									ClearDrawOrigin()
								end

								if IsControlJustPressed(1, 51) then --pressed E to sit and join the table
									if satDownCallback ~= nil then
										satDownCallback()
									end

									DebugPrint("SeatAnim = ".. seatAnim)

									local initPos = GetAnimInitialOffsetPosition("anim_casino_b@amb@casino@games@shared@player@", seatAnim, coords, rot, 0.01, 2)
									local initRot = GetAnimInitialOffsetRotation("anim_casino_b@amb@casino@games@shared@player@", seatAnim, coords, rot, 0.01, 2)

									TaskGoStraightToCoord(PlayerPedId(), initPos, 1.0, 5000, initRot.z, 0.01)
									repeat
										Wait(0)
										--DebugPrint("first TaskGoStraightToCoord loop")
									until GetScriptTaskStatus(PlayerPedId(), 2106541073) == 7
									Wait(50)

									SetPedCurrentWeaponVisible(PlayerPedId(), 0, true, 0, 0)

									local scene = NetworkCreateSynchronisedScene(coords, rot, 2, true, true, 1065353216, 0, 1065353216)
									NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", seatAnim, 2.0, -2.0, 13, 16, 1148846080, 0)
									NetworkStartSynchronisedScene(scene)

									local scene = NetworkConvertSynchronisedSceneToSynchronizedScene(scene)
									repeat
										Wait(0)
										--DebugPrint("second GetSynchronizedScenePhase loop")
									until GetSynchronizedScenePhase(scene) >= 0.99 or HasAnimEventFired(PlayerPedId(), 2038294702) or HasAnimEventFired(PlayerPedId(), -1424880317)

									Wait(1000) --player should be sitting down now.

									idleVar = "idle_cardgames"

									scene = NetworkCreateSynchronisedScene(coords, rot, 2, true, true, 1065353216, 0, 1065353216)
									NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", "idle_cardgames", 2.0, -2.0, 13, 16, 1148846080, 0)
									NetworkStartSynchronisedScene(scene)

									repeat Wait(0) until IsEntityPlayingAnim(PlayerPedId(), "anim_casino_b@amb@casino@games@shared@player@", "idle_cardgames", 3) == 1

									g_bjtable = i

									leavingBlackjack = false

									TriggerServerEvent("BLACKJACK:PlayerSatDown", i, closestChair)

									local endTime = GetGameTimer() + math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@shared@player@", idleVar)*990)

									Citizen.CreateThread(function() -- Disable pause while playing blackjack
										local startCount = false
										local maxWait = 0
										while true do
											Citizen.Wait(0)
											SetPauseMenuActive(false)

											if leavingBlackjack == true and startCount == false then
												startCount = true
												maxWait = GetGameTimer()+3000 -- Make it so it enables 3 seconds after hitting the leave button so the pause menu doesn't show up when trying to leave
											end

											if startCount == true and maxWait < GetGameTimer() then
												SetPauseMenuActive(true)
												break
											end
										end
										SetPauseMenuActive(true)
									end)


									--second stage inner loop - runs while player is sat down at the table until leaving/left/dead
									while true do
										Wait(0)
										if GetGameTimer() >= endTime then
											if playerBusy == true then
												while playerBusy == true do
													Wait(0)

													local playerPed = PlayerPedId()

													if IsEntityDead(playerPed) or IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) then
														TriggerServerEvent("BLACKJACK:PlayerRemove", i)
														ClearPedTasks(playerPed)
														leaveBlackjack()
														break
													elseif leaveCheckCallback ~= nil then
														if leaveCheckCallback() then
															TriggerServerEvent("BLACKJACK:PlayerRemove", i)
															ClearPedTasks(playerPed)
															leaveBlackjack()
															break
														end
													end
												end
											end

											if leavingBlackjack == false then
												idleVar = "idle_var_0"..math.random(1,5)

												local scene = NetworkCreateSynchronisedScene(coords, rot, 2, true, true, 1065353216, 0, 1065353216)
												NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", idleVar, 2.0, -2.0, 13, 16, 1148846080, 0)
												NetworkStartSynchronisedScene(scene)
												endTime = GetGameTimer() + math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@shared@player@", idleVar)*990)
												-- DebugPrint("idling again")
											end
										end
										if GetFollowPedCamViewMode() ~= 4 then
											SetFollowPedCamViewMode(4)
										end
										-- DisplayHelpText("Press ~INPUT_CONTEXT~ to leave Blackjack.")
										-- if IsControlJustPressed(1, 51) then
										if leavingBlackjack == true then
											if standUpCallback ~= nil then
												standUpCallback()
											end

											local scene = NetworkCreateSynchronisedScene(coords, rot, 2, false, false, 1065353216, 0, 1065353216)
											NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "anim_casino_b@amb@casino@games@shared@player@", "sit_exit_left", 2.0, -2.0, 13, 16, 1148846080, 0)
											NetworkStartSynchronisedScene(scene)
											TriggerServerEvent("BLACKJACK:PlayerSatUp", i)
											Wait(math.floor(GetAnimDuration("anim_casino_b@amb@casino@games@shared@player@", "sit_exit_left")*800))
											ClearPedTasks(PlayerPedId())
											break
										else
											local playerPed = PlayerPedId()

											if IsEntityDead(playerPed) or IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) then
												TriggerServerEvent("BLACKJACK:PlayerRemove", i)
												ClearPedTasks(playerPed)
												leaveBlackjack()
												if standUpCallback ~= nil then
													standUpCallback()
												end
												break
											elseif leaveCheckCallback ~= nil then
												if leaveCheckCallback() then
													TriggerServerEvent("BLACKJACK:PlayerRemove", i)
													ClearPedTasks(playerPed)
													leaveBlackjack()
													if standUpCallback ~= nil then
														standUpCallback()
													end
													break
												end
											end
										end

										-- if IsEntityPlayingAnim(PlayerPedId(), "anim_casino_b@amb@casino@games@shared@player@", idleVar, 3) ~= 1 then break end
									end
								end
							end
						end
					end
				end
			end

		end
	end
end

Citizen.CreateThread(function()

	if IsModelInCdimage(`vw_prop_casino_blckjack_01`) and IsModelInCdimage(`s_f_y_casino_01`) and IsModelInCdimage(`vw_prop_chip_10dollar_x1`) then
		Citizen.CreateThread(ProcessTables)
		Citizen.CreateThread(CreatePeds)
	else
		ThefeedSetAnimpostfxColor(255, 0, 0, 255)
		Notification("This server is missing objects required for rpuk_blackjack!", nil, true)
	end
end)

exports("SetSatDownCallback", SetSatDownCallback)
exports("SetStandUpCallback", SetStandUpCallback)
exports("SetLeaveCheckCallback", SetLeaveCheckCallback)
exports("SetCanSitDownCallback", SetCanSitDownCallback)