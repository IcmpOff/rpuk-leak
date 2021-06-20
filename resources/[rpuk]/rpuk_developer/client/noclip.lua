-- local change_component, change_drawable, change_texture = 1, 0, 0
-- local clothing_components = {
-- 	[1] = "Masks",
-- 	[2] = "Hair Styles",
-- 	[3] = "Torso",
-- 	[4] = "Legs",
-- 	[5] = "Bags",
-- 	[6] = "Shoes",
-- 	[7] = "Accessories",
-- 	[8] = "Undershirts",
-- 	[9] = "Body Armors",
-- 	[10] = "Decals",
-- 	[11] = "Tops",	
-- }
-- config = {
--     controls = {
--         -- [[Controls, list can be found here : https://docs.fivem.net/game-references/controls/]]
--         openKey = 167, -- [[F2]]
--         goUp = 85, -- [[Q]]
--         goDown = 48, -- [[Z]]
--         turnLeft = 34, -- [[A]]
--         turnRight = 35, -- [[D]]
--         goForward = 32,  -- [[W]]
--         goBackward = 33, -- [[S]]
--         changeSpeed = 21, -- [[L-Shift]]
--     },

--     speeds = {
--         -- [[If you wish to change the speeds or labels there are associated with then here is the place.]]
--         { label = "Very Slow", speed = 0},
--         { label = "Slow", speed = 0.5},
--         { label = "Normal", speed = 2},
--         { label = "Fast", speed = 4},
--         { label = "Very Fast", speed = 6},
--         { label = "Extremely Fast", speed = 10},
--         { label = "Extremely Fast v2.0", speed = 20},
--         { label = "Max Speed", speed = 25}
--     },

--     offsets = {
--         y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
--         z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
--         h = 3, -- [[How much you rotate. ]]
--     },

--     -- [[Background colour of the buttons. (It may be the standard black on first opening, just re-opening.)]]
--     bgR = 0, -- [[Red]]
--     bgG = 0, -- [[Green]]
--     bgB = 0, -- [[Blue]]
--     bgA = 80, -- [[Alpha]]
-- }

-- --==--==--==--
-- -- End Of Config
-- --==--==--==--

-- noclipActive = false -- [[Wouldn't touch this.]]

-- index = 1 -- [[Used to determine the index of the speeds table.]]

-- Citizen.CreateThread(function()
-- 	hint = setupHintScale("instructional_buttons")
--     buttons = setupScaleform("instructional_buttons")

--     currentSpeed = config.speeds[index].speed

--     while true do
--         Citizen.Wait(1)

--         if IsControlJustPressed(1, config.controls.openKey) then
--             noclipActive = not noclipActive

--             if IsPedInAnyVehicle(PlayerPedId(), false) then
--                 noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
--             else
--                 noclipEntity = PlayerPedId()
--             end

--             SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
--             FreezeEntityPosition(noclipEntity, noclipActive)
--             SetEntityInvincible(noclipEntity, noclipActive)
--             SetVehicleRadioEnabled(noclipEntity, not noclipActive) -- [[Stop radio from appearing when going upwards.]]
--         end

--         if noclipActive then
--             setupScaleform("instructional_buttons")
-- 			DrawScaleformMovieFullscreen(buttons)

--             local yoff = 0.0
--             local zoff = 0.0

--             if IsControlJustPressed(1, config.controls.changeSpeed) then
--                 if index ~= 8 then
--                     index = index+1
--                     currentSpeed = config.speeds[index].speed
--                 else
--                     currentSpeed = config.speeds[1].speed
--                     index = 1
--                 end
--                 setupScaleform("instructional_buttons")
--             end

-- 			if IsControlPressed(0, config.controls.goForward) then
--                 yoff = config.offsets.y
-- 			end
			
--             if IsControlPressed(0, config.controls.goBackward) then
--                 yoff = -config.offsets.y
-- 			end
			
--             if IsControlPressed(0, config.controls.turnLeft) then
--                 SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)+config.offsets.h)
-- 			end
			
--             if IsControlPressed(0, config.controls.turnRight) then
--                 SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)-config.offsets.h)
-- 			end
			
--             if IsControlPressed(0, config.controls.goUp) then
--                 zoff = config.offsets.z
-- 			end
			
--             if IsControlPressed(0, config.controls.goDown) then
--                 zoff = -config.offsets.z
-- 			end
			
--             local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
--             local heading = GetEntityHeading(noclipEntity)
--             SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
--             SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
--             SetEntityHeading(noclipEntity, heading)
--             SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
--         else
-- 			setupHintScale("instructional_buttons")
-- 			DrawScaleformMovieFullscreen(hint)
--             if IsControlJustReleased(0, 108) then -- numpad 4
--                 if change_component > 10 then
-- 					change_component = 1
-- 				else
-- 					change_component = change_component + 1
-- 				end
-- 			end
--             if IsControlJustReleased(0, 117) then
--                 if change_component < 2 then
-- 					change_component = 11
-- 				else
-- 					change_component = change_component - 1
-- 				end
-- 			end
--             if IsControlJustReleased(0, 111) then -- 8
-- 				change_drawable = change_drawable + 1
-- 				SetPedComponentVariation(PlayerPedId(), change_component, change_drawable, change_texture, 2)
-- 			end
--             if IsControlJustReleased(0, 110) then -- 5
-- 				change_drawable = change_drawable - 1
-- 				SetPedComponentVariation(PlayerPedId(), change_component, change_drawable, change_texture, 2)
-- 			end
--             if IsControlJustReleased(0, 118) then -- 9
-- 				change_texture = change_texture + 1
-- 				SetPedComponentVariation(PlayerPedId(), change_component, change_drawable, change_texture, 2)
-- 			end
--             if IsControlJustReleased(0, 109) then -- 6
-- 				change_texture = change_texture - 1
-- 				SetPedComponentVariation(PlayerPedId(), change_component, change_drawable, change_texture, 2)
-- 			end
--             if IsControlJustReleased(0, 201) then -- enter
-- 				local playerPed = PlayerPedId()
-- 				local msg = ""
-- 				for k, v in pairs(clothing_components) do			
-- 					msg = msg .. "SetPedComponentVariation(playerPed , " .. k .. ", " .. GetPedDrawableVariation(playerPed, k) .. ", " .. GetPedTextureVariation(playerPed, k) .. ") -- " .. v .. "\n"				
-- 				end	
-- 				TriggerEvent('demmycam:remoteCopy', msg)
-- 			end			
-- 		end
--     end
-- end)

-- function ButtonMessage(text)
--     BeginTextCommandScaleformString("STRING")
--     AddTextComponentScaleform(text)
--     EndTextCommandScaleformString()
-- end

-- function Button(ControlButton)
--     N_0xe83a3e3557a56640(ControlButton)
-- end

-- function setupHintScale(scaleform)

--     local scaleform = RequestScaleformMovie(scaleform)

--     while not HasScaleformMovieLoaded(scaleform) do
--         Citizen.Wait(1)
--     end

--     PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
--     PopScaleformMovieFunctionVoid()
    
--     PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
--     PushScaleformMovieFunctionParameterInt(200)
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(5)
--     Button(GetControlInstructionalButton(2, config.controls.openKey, true))
--     ButtonMessage("Noclip")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(4)
--     Button(GetControlInstructionalButton(1, 108, true))
--     Button(GetControlInstructionalButton(1, 117, true))
--     ButtonMessage("Change Component +/- [" .. clothing_components[change_component] .. "]")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(3)
--     Button(GetControlInstructionalButton(1, 111, true))
--     Button(GetControlInstructionalButton(1, 110, true))
--     ButtonMessage("Change Drawable +/- [" .. GetPedDrawableVariation(PlayerPedId(), change_component) .. "]")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(2)
--     Button(GetControlInstructionalButton(1, 118, true))
--     Button(GetControlInstructionalButton(1, 109, true))
--     ButtonMessage("Change Texture +/- [" .. GetPedTextureVariation(PlayerPedId(), change_component) .. "]")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(1)
--     Button(GetControlInstructionalButton(1, 201, true))
--     ButtonMessage("Save Outfit (Copy/Paste)")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
--     PushScaleformMovieFunctionParameterInt(config.bgR)
--     PushScaleformMovieFunctionParameterInt(config.bgG)
--     PushScaleformMovieFunctionParameterInt(config.bgB)
--     PushScaleformMovieFunctionParameterInt(config.bgA)
--     PopScaleformMovieFunctionVoid()

--     return scaleform
-- end

-- function log(msg)
-- 	TriggerServerEvent('esx:clientLog', msg)
-- end

-- function setupScaleform(scaleform)

--     local scaleform = RequestScaleformMovie(scaleform)

--     while not HasScaleformMovieLoaded(scaleform) do
--         Citizen.Wait(1)
--     end

--     PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
--     PopScaleformMovieFunctionVoid()
    
--     PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
--     PushScaleformMovieFunctionParameterInt(200)
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(5)
--     Button(GetControlInstructionalButton(2, config.controls.openKey, true))
--     ButtonMessage("Disable Noclip")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(4)
--     Button(GetControlInstructionalButton(2, config.controls.goUp, true))
--     ButtonMessage("Go Up")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(3)
--     Button(GetControlInstructionalButton(2, config.controls.goDown, true))
--     ButtonMessage("Go Down")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(2)
--     Button(GetControlInstructionalButton(1, config.controls.turnRight, true))
--     Button(GetControlInstructionalButton(1, config.controls.turnLeft, true))
--     ButtonMessage("Turn Left/Right")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(1)
--     Button(GetControlInstructionalButton(1, config.controls.goBackward, true))
--     Button(GetControlInstructionalButton(1, config.controls.goForward, true))
--     ButtonMessage("Go Forwards/Backwards")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
--     PushScaleformMovieFunctionParameterInt(0)
--     Button(GetControlInstructionalButton(2, config.controls.changeSpeed, true))
--     ButtonMessage("Change Speed ("..config.speeds[index].label..")")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
--     PopScaleformMovieFunctionVoid()

--     PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
--     PushScaleformMovieFunctionParameterInt(config.bgR)
--     PushScaleformMovieFunctionParameterInt(config.bgG)
--     PushScaleformMovieFunctionParameterInt(config.bgB)
--     PushScaleformMovieFunctionParameterInt(config.bgA)
--     PopScaleformMovieFunctionVoid()

--     return scaleform
-- end