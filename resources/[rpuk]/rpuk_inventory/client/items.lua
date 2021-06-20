local DrunkTick = 0 -- handles drunk state
RegisterNetEvent('rpuk_consume:useItem')
AddEventHandler('rpuk_consume:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'bandage' then
		local playerPed = PlayerPedId()
		TriggerEvent("mythic_progbar:client:progress", {
			name = "heal",
			duration = 25000,
			label = "Applying bandage",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "amb@world_human_clipboard@male@idle_a",
				anim = "idle_c",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_ld_health_pack",
			}
		  }, function(status)
			if not status then
				SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'You have used a bandage' })
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'wine' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 5000,
			label = "Drinking Wine",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_drink_redwine",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 1
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'beer' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 5000,
			label = "Drinking Beer",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_pint_glass_01",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 1
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'tequila' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 2000,
			label = "Taking Shot",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_shot_glass",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 2
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'whisky' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 6000,
			label = "Drinking whisky",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_drink_whisky",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 2
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'vladickas' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 6000,
			label = "Drinking Vladickas",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_tall_glass",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 2
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'oldFashioned' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 6000,
			label = "Drinking Cocktail",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cocktail_glass",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 1
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'appletini' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 6000,
			label = "Drinking Cocktail",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cocktail_glass",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 1
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'tequilaSunrise' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 6000,
			label = "Drinking Cocktail",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cocktail_glass",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 1
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'spikedMichelada' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 6000,
			label = "Drinking Cocktail",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cocktail_glass",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 1
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'vodka' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "drink",
			duration = 6000,
			label = "Drinking Vodka",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
				closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_tall_glass",
			}
		  }, function(status)
			if not status then
				local newHealth = math.min(GetEntityMaxHealth(PlayerPedId()) , math.floor(GetEntityHealth(PlayerPedId()) + GetEntityMaxHealth(PlayerPedId())/6))
				SetEntityHealth(PlayerPedId(), newHealth)
				DrunkTick = DrunkTick + 1
				Drunk(DrunkTick, false)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
				Wait(10000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'marijuana' then

	elseif itemName == 'meth' then
		local od_chance = math.random (100)
		if od_chance < 20 then -- bad batch chance
			Wait(2000)
			SetEntityHealth(PlayerPedId(), 100)
			Wait(20000)
		else
			AddArmourToPed(PlayerPedId(), 10)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			ResetPlayerStamina(PlayerId())
			Wait(0)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
			Wait(5000)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		end
	elseif itemName == 'cocaine' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "coke",
			duration = 10000,
			label = "Snorting a line",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = false,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
				closeInv = true,
			},
			animation = {
				animDict = "anim@amb@nightclub@peds@",
				anim = "missfbi3_party_snort_coke_b_male3",
				flags = 49,
				task = nil,
			}
		  }, function(status)
			if not status then
				local od_chance = math.random (100)
				local ped = PlayerPedId()
				local playerID = PlayerId()
				if od_chance < 5 then -- bad batch chance
					SetEntityHealth(ped, 120)
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'That shit aint right.' })
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Wooooooooooo, What a feeling!' })
					AddArmourToPed(ped, 10)
					SetRunSprintMultiplierForPlayer(playerID, 1.0)
					ResetPlayerStamina(playerID)
					Wait(0)
					SetRunSprintMultiplierForPlayer(playerID, 1.2)
					Wait(5000)
					SetRunSprintMultiplierForPlayer(playerID, 1.0)
				end
			else
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'repairkit' then
		local ped = PlayerPedId()
		local vehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(ped))

		if distance < 6 and IsPedOnFoot(ped) then
			if ESX.Game.RequestNetworkControlOfEntity(vehicle, true) then
				if not (GetEntityModel(vehicle) == -1049610950 or GetEntityModel(vehicle) == 1013361579) then
					if GetVehicleDoorAngleRatio(vehicle, 4) > 0 then
						SetVehicleDoorShut(vehicle, 4, false)
					else
						SetVehicleDoorOpen(vehicle, 4, false)
					end
				end
				TriggerEvent("mythic_progbar:client:progress", {
					name = "Repairing",
					duration = 25000,
					label = "Repairing Vehicle",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
						closeInv = true,
					},
					animation = {
						animDict = "mini@repair",
						anim = "fixing_a_player",
						flags = 49,
						task = nil,
					}
				}, function(status)
					if not status then
						if IsPedOnFoot(ped) then
							if DoesEntityExist(vehicle) then
								distance = #(GetEntityCoords(ped) - GetEntityCoords(vehicle))

								if distance < 6 then
									TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have repaired your vehicle' })
									ESX.Game.SetVehicleProperties(vehicle, {
										bodyHealth = 1000,
										engineHealth = 1000,
										petrolTankHealth = 1000
									})

									SetVehicleFixed(vehicle)
									SetVehicleUndriveable(vehicle, false)
									SetVehicleEngineOn(vehicle, true, true)
									SetVehicleDoorShut(vehicle, 4, true)

									if ESX.Player.GetJobName() == "mechanic" then
										if math.random(1, 2) == 1 then
											TriggerServerEvent('removeItem', itemName)
										else
											ESX.ShowNotification('You repaired the vehicle without consuming a repair kit thanks to your mechanic skills!')
										end
									else
										TriggerServerEvent('removeItem', itemName)
									end
								else
									ESX.ShowNotification('Vehicle repair failed, get closer to the vehicle')
								end
							else
								ESX.ShowNotification('That vehicle does not exist anymore')
							end
						else
							TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You need to be outside the vehicle' })
							SetVehicleDoorShut(vehicle, 4, false)
						end
					else
						SetVehicleDoorShut(vehicle, 4, false)
					end
				end)
			else
				ESX.ShowNotification('Requesting network control over the vehicle has failed, make sure no one is in the vehicle.')
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You need to be close to a vehicle.' })
		end
	elseif itemName == 'paracetamol' or itemName == "comp_drug_paracetamol" then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "consumingP",
			duration = 6000,
			label = "Consuming Tablets",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = true,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cs_pills",
			}
		  }, function(status)
			if not status then
				local ped = PlayerPedId()
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You dont look so good bro...' })
				DoScreenFadeOut(5000)
				Citizen.Wait(5000)
				DoScreenFadeIn(5000)
				SetPedToRagdoll(ped, 1500, 1500, 0, 0, 0, 0)
				Citizen.Wait(4000)
				SetPedToRagdoll(ped, 1500, 1500, 0, 0, 0, 0)
				Citizen.Wait(4000)
				SetPedToRagdoll(ped, 1500, 1500, 0, 0, 0, 0)
				Citizen.Wait(4000)
				SetPedToRagdoll(ped, 1500, 1500, 0, 0, 0, 0)
				Citizen.Wait(4000)
				SetPedToRagdoll(ped, 1500, 1500, 0, 0, 0, 0)
				Citizen.Wait(8000)
				DoScreenFadeOut(1000)
				Citizen.Wait(4000)
				DoScreenFadeIn(1000)
				SetPedToRagdoll(ped, 1500, 1500, 0, 0, 0, 0)
				Citizen.Wait(300000)
				TriggerEvent("rpuk_weather:isBlurry", false)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped taking medication' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'asprin' or itemName == "comp_drug_asprin" then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "asprin",
			duration = 6000,
			label = "Consuming Asprin",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = true,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cs_pills",
			}
		  }, function(status)
			if not status then
				local ped = PlayerPedId()
				DoScreenFadeOut(5000)
				Citizen.Wait(5000)
				DoScreenFadeIn(5000)
				Citizen.Wait(2000)
				TriggerEvent("rpuk_weather:isBlurry", false)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped taking medication' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'comp_drug_morphine' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "morphine",
			duration = 6000,
			label = "Consuming Morphine",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = true,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cs_pills",
			}
		  }, function(status)
			if not status then
				local ped = PlayerPedId()
				DoScreenFadeOut(5000)
				Citizen.Wait(5000)
				DoScreenFadeIn(5000)
				Citizen.Wait(2000)
				TriggerEvent("rpuk_weather:isBlurry", false)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped taking medication' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'washkit' then
		local vehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
		if distance < 6.0 then
			if ESX.Game.RequestNetworkControlOfEntity(vehicle, true) then
				TriggerEvent("mythic_progbar:client:progress", {
					name = "clean",
					duration = 5000,
					label = "Cleaning Vehicle",
					useWhileDead = false,
					canCancel = false,
					controlDisables = {
					  disableMovement = true,
					  disableCarMovement = true,
					  disableMouse = false,
					  disableCombat = true,
					  closeInv = true,
					},
					animation = {
					  animDict = "timetable@maid@cleaning_surface@base",
					  anim = "base",
					  flags = 49,
					  task = nil,
					}
				  }, function(status)
					if not status then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have cleaned your vehicle' })
						SetVehicleDirtLevel(vehicle, 0)
					end
				end)
			else
				ESX.ShowNotification('Requesting network control over the vehicle has failed, make sure no one is in the vehicle.')
			end
		else -- clean the player instead xD
			local pPlayer, pDistance = ESX.Game.GetClosestPlayer()
			if pDistance < 1.5 then
				ClearPedBloodDamage(GetPlayerPed(GetPlayerServerId(pPlayer)))
			else -- clean myself
				ClearPedBloodDamage(PlayerPedId())
			end
		end
	end
end)



RegisterNetEvent('rpuk_consume:eat')
AddEventHandler('rpuk_consume:eat', function(itemName,food,drink)
	if itemName == 'smoothie' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "Smoothie",
			duration = 6000,
			label = "Drinking Smoothie",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "v_ret_fh_bscup",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
				TriggerEvent('esx_status:add', 'thirst', drink)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped drinking' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'burger' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "burger",
			duration = 6000,
			label = "Eating Burger",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_inteat@burger",
				anim = "mp_player_int_eat_burger",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cs_burger_01",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped eating' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'taco' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "taco",
			duration = 6000,
			label = "Eating Taco",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_inteat@burger",
				anim = "mp_player_int_eat_burger",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_taco_01",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped eating' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'orange' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "orange",
			duration = 6000,
			label = "Eating Orange",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_inteat@burger",
				anim = "mp_player_int_eat_burger",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "ng_proc_food_ornge1a",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
				TriggerEvent('esx_status:add', 'thirst', drink)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped eating' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'apple' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "apple",
			duration = 6000,
			label = "Eating Apple",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_inteat@burger",
				anim = "mp_player_int_eat_burger",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "ng_proc_food_aple2a",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
				TriggerEvent('esx_status:add', 'thirst', drink)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped eating' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'redgull' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "redgull",
			duration = 6000,
			label = "Drinking Redgull",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_energy_drink",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'thirst', drink)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				ResetPlayerStamina(PlayerId())
				Wait(0)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.29)
				Wait(15000)
				SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped drinking' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'water' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "water",
			duration = 6000,
			label = "Drinking Water",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_ld_flow_bottle",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'thirst', drink)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped drinking' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'breakfast' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "breakfast",
			duration = 6000,
			label = "Eating Full English",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_inteat@burger",
				anim = "mp_player_int_eat_burger",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_cs_plate_01",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
				TriggerEvent('esx_status:add', 'thirst', drink)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped eating' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'bread' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "bread",
			duration = 6000,
			label = "Eating Bread",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_inteat@burger",
				anim = "mp_player_int_eat_burger",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_sandwich_01",
				coords = {x = 0.13, y = 0.05, z = 0.02},
				rotation = {x = -50.0, y = 16.0, z = 60.0},
				bone = 18905
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
				TriggerEvent('esx_status:add', 'thirst', drink)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped eating' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'hallow_sweet_1' or itemName == "christmas_candycane" or itemName == "christmas_chocolate" or itemName == "christmas_gingerbread" then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "hallow_sweet_1",
			duration = 6000,
			label = "Eating Festive Food",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_inteat@burger",
				anim = "mp_player_int_eat_burger",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_choc_meto",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
				TriggerEvent('esx_status:add', 'thirst', drink)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped eating' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	elseif itemName == 'pumpkin_pie' then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "pumpkin_pie",
			duration = 6000,
			label = "Eating Pumpkin Pie",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = false,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_inteat@burger",
				anim = "mp_player_int_eat_burger",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "prop_veg_crop_03_pump",
			}
		  }, function(status)
			if not status then
				TriggerEvent('esx_status:add', 'hunger', food)
				TriggerEvent('esx_status:add', 'thirst', drink)
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped eating' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	end


end)

-- Drug & Drink shit

function Drunk(level, start)
	if level == 0 then
		RequestAnimSet("move_m@drunk@slightlydrunk")
		while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
			Citizen.Wait(0)
		end
	  SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", true)
	elseif level == 1 then
		RequestAnimSet("move_m@drunk@moderatedrunk")
		while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
			Citizen.Wait(0)
		end
		SetPedMovementClipset(PlayerPedId(), "move_m@drunk@moderatedrunk", true)
	elseif level == 2 then
		RequestAnimSet("move_m@drunk@verydrunk")
		while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
			Citizen.Wait(0)
		end
		SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", true)
	end
	SetPedIsDrunk(PlayerPedId(), true)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(180000)
		if DrunkTick > 0 then
			DrunkTick = DrunkTick - 1
			if DrunkTick == 0 then
				Reality()
			end
		end
	end
end)

function Reality()
	DrunkTick = 0
	Wait(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(PlayerPedId(), 0.0)
	SetPedIsDrunk(PlayerPedId(), false)
	SetPedMotionBlur(PlayerPedId(), false)
end

-- ^^ Drug & Drink shit

RegisterNetEvent('rpuk_consume:applyMask')
AddEventHandler('rpuk_consume:applyMask', function(variation, colour)
	ESX.UI.Menu.CloseAll()
	startAnim("missfbi4", "takeoff_mask", 48)
	Citizen.Wait(1000)
	if colour == nil then colour = 0 end
	if GetPedDrawableVariation(PlayerPedId(), 1) == variation then
		SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2) -- Clear if the mask
	else
		SetPedComponentVariation(PlayerPedId(), 1, variation, colour, 2) -- Apply new mask
	end
end)

RegisterNetEvent('rpuk_consume:dyePackExplode')
AddEventHandler('rpuk_consume:dyePackExplode', function()
	startAnim("reaction@shellshock@unarmed", "right_long", 48)
	DoScreenFadeOut(1500)
	Citizen.Wait(1500)
	DoScreenFadeIn(1500)
	TriggerEvent("rpuk_weather:isBlurry", true)
	SetTimecycleModifier("FranklinColorCode")
	SetTimecycleModifierStrength(1.0)
	Citizen.Wait(20000)
	TriggerEvent("rpuk_weather:isBlurry", false)
end)

RegisterNetEvent('rpuk_consume:applyArmor')
AddEventHandler('rpuk_consume:applyArmor', function(amount)
	local playerPed = PlayerPedId()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "armor",
		duration = 15000,
		label = "Equiping Vest",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
			closeInv = true,
		},
		animation = {
		  animDict = "amb@world_human_clipboard@male@idle_a",
		  anim = "idle_c",
		  flags = 49,
		  task = nil,
		},
		prop = {
			model = "prop_bodyarmour_03",
		}
	  }, function(status)
		if not status then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have placed a bulletproof vest on!' })
			AddArmourToPed(playerPed, amount)
		elseif status then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You stopped putting the vest on!' })
			TriggerServerEvent('returnItem', "armor")
		end
	end)
end)

RegisterNetEvent('rpuk_consume:applyScuba')
AddEventHandler('rpuk_consume:applyScuba', function(amount)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "scuba",
		duration = 7000,
		label = "Equiping Scuba",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
			closeInv = true,
		},
		animation = {
			animDict = "amb@world_human_clipboard@male@idle_a",
			anim = "idle_c",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "p_s_scuba_tank_s",
			coords = { x = 0.0, y = 0.12, z = -0.3 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		}
	},function(status)
		if not status then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have placed a air tank on!' })
			TriggerEvent("useOxygenTank")
		elseif status then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You stopped putting the air tank on!' })
			TriggerServerEvent('returnItem', "scuba")
		end
	end)
end)

function startAnim(lib, anim, body)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if vehicle ~= nil and vehicle ~= 0 or handsup == true then
		ESX.ShowNotification("You can't do this right now!")
	 else
		ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 8.0, -1, body, 0.0, false, false, false) end)
	end
end

RegisterNetEvent('rpuk_items:lockpickVehicle')
AddEventHandler('rpuk_items:lockpickVehicle', function(type)
	local playerPed	= PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local item = type
	local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
	local anim = "machinic_loop_mechandplayer"
	local chance

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

		if IsPedInAnyVehicle(playerPed, false) then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You can not lockpick from the inside' })
			return
		end

		local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		local isVehicleLocked = GetVehicleDoorsLockedForPlayer(vehicle, playerPed)

		if isVehicleLocked then
			if type == "advanced_lockpick" then
				chance = 60
			else
				chance = 40
			end

			local lockpick = exports.rpuk_shops:createSafe({math.random(0,99),math.random(0,99)}, animDict, anim)

			if lockpick then
				if ESX.Game.RequestNetworkControlOfEntity(vehicle) then
					if 100 * math.random() < chance then
						SetVehicleAlarm(vehicle, true)
						SetVehicleAlarmTimeLeft(vehicle, 30 * 1000)
						SetVehicleDoorsLocked(vehicle, 0)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'You have broken your lockpick and set off the alarm' })
						TriggerServerEvent('removeItem', item)
					else
						SetVehicleDoorsLocked(vehicle, 0)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)
						ClearPedTasksImmediately(playerPed)
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'You have broken into the vehicle and managed to keep the lockpick' })
					end
				else
					ESX.ShowNotification('Failed to take vehicle network control')
				end
			else
				ClearPedTasksImmediately(playerPed)
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have cancelled lockpicking' })
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Vehicle door is not locked.' })
		end
	end
end)

RegisterNetEvent('rpuk_consume:useDeployable')
AddEventHandler('rpuk_consume:useDeployable', function(data)
	local playerPed = PlayerPedId()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "item_deployable",
		duration = 7000,
		label = "Placing Object",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "amb@medic@standing@tendtodead@idle_a",
			anim = "idle_a",
			flags = 49,
			task = nil,
		},
	}, 
	function(result)
		if not result then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have placed a ' .. data[3] .. ' down.' })
			local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, -0.75)
			local obj = CreateObject(GetHashKey(data[2]), coords.x, coords.y, GetCoordZ(coords.x, coords.y, coords.z),	true, true, true)
			SetEntityHeading(obj, GetEntityHeading(playerPed))
		elseif result then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You stopped placing ' .. data[3] .. ' down.' })
			TriggerServerEvent('returnItem', data[1])
		end
	end)
end)

function GetCoordZ(x, y, initial)
	local groundCheckHeights = {initial+0, initial+1, initial+2, initial+3, initial+4, initial+5, initial+6, initial+7, initial+8, initial+9, initial+10}
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return initial
end

local blindFold = false
local bag

RegisterNetEvent("rpuk_health:registerDeadPlayer")
RegisterNetEvent('playerSpawned')
RegisterNetEvent('rpuk_blindfold:putBlindFoldOn')
RegisterNetEvent('rpuk_blindfold:anim')
RegisterNetEvent('rpuk_blindfold:putBlindFoldOff')
RegisterNetEvent('rpuk_blindfold:bagHead')
RegisterNetEvent('rpuk_blindfold:removeBagHead')

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function anim_state(player)
	local ped = GetPlayerPed(player)
	local anim_data = {}
	anim_data[1] = IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) -- Surrender Standing Up Anim
	anim_data[2] = IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) -- Restrain Anim
	anim_data[3] = IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3)
	anim_data[4] = IsEntityPlayingAnim(ped, "anim@move_m@prisoner_cuffed", "idle", 3) -- Ziptie Anim
	anim_data[5] = IsEntityPlayingAnim(ped, "dead", "dead_a", 3) -- Sedate Anim
	anim_data[6] = IsEntityPlayingAnim(ped, "misslamar1dead_body", "dead_idle", 3) -- Dead Anim
	return anim_data
end

AddEventHandler('rpuk_health:registerDeadPlayer', function()
	DeleteEntity(bag)
	SetEntityAsNoLongerNeeded(bag)
	blindFold = false
end)

AddEventHandler('playerSpawned', function()
	DeleteEntity(bag)
	SetEntityAsNoLongerNeeded(bag)
	blindFold = false
end)

AddEventHandler('rpuk_blindfold:putBlindFoldOn', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance < 2.0 then
		local data = anim_state(closestPlayer)
		if data[2] or data[4] then
			TriggerServerEvent('rpuk_blindfold:placeBlindFoldOnPlayer', GetPlayerServerId(closestPlayer))
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'The person is not handcuffed' })
		end
	end
end)

AddEventHandler('rpuk_blindfold:anim', function()
	local ped = PlayerPedId()
	loadAnimDict("amb@medic@standing@tendtodead@idle_a")
	TaskPlayAnim(ped, 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, 1.0, 1300, 49, 0, 0, 0, 0)
end)

AddEventHandler('rpuk_blindfold:putBlindFoldOff', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance < 2.0 then
		local data = anim_state(closestPlayer)
		if data[2] or data[4] then
			TriggerServerEvent('rpuk_blindfold:placeBlindFoldOffPlayer', GetPlayerServerId(closestPlayer))
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'The person is not handcuffed' })
		end
	end
end)

AddEventHandler('rpuk_blindfold:bagHead', function()
	local playerPed = PlayerPedId()
	bag = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(bag, playerPed, GetPedBoneIndex(playerPed, 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
	SetNuiFocus(false,false)
	blindFold = true
end)

AddEventHandler('rpuk_blindfold:removeBagHead', function()
	DeleteEntity(bag)
	SetEntityAsNoLongerNeeded(bag)
	blindFold = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if blindFold then
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 289, true) -- Disable phone
			DisableControlAction(0, 171, true) -- Wheel
			DisableControlAction(0, 170, true) -- Inventory
			DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 255)
		else
			Citizen.Wait(500)
		end
	end
end)