local sitting, lastPos, currentSitCoords, currentScenario

local chairs = {
	[GetHashKey("prop_bench_01a")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_01b")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_01c")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_04")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_05")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_06")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_08")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_09")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.32, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_10")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_bench_11")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_fib_3b_bench")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_ld_bench01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_wait_bench_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_club_stagechair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("hei_prop_heist_off_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("hei_prop_hei_skid_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_01a")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_01b")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_04a")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_04b")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_05")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_06")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_08")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_09")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chair_10")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_chateau_chair_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_clown_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_cs_office_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_direct_chair_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_direct_chair_02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_gc_chair02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_off_chair_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_off_chair_03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_off_chair_04")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_off_chair_04b")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_off_chair_04_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_off_chair_05")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_old_deck_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_old_wood_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_res_m_l_chair1")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("sm_prop_offchair_smug_02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.09, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_res_m_dinechair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_res_m_armchair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_res_r_sofa")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.7, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_rock_chair_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_skid_chair_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_skid_chair_02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_skid_chair_03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_sol_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_wheelchair_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.05, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_wheelchair_01_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.05, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_armchair_01_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_clb_officechair_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_dinechair_01_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_ilev_p_easychair_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_soloffchair_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_yacht_chair_01_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_club_officechair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_corp_bk_chair3")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_corp_cd_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_corp_offchair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ilev_chair02_ped")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ilev_hd_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ilev_p_easychair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ret_gc_chair03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_ld_farm_chair01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_table_04_chr")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_table_05_chr")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_table_06_chr")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ilev_leath_chr")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_table_01_chr_a")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_table_01_chr_b")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_table_02_chr")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_table_03b_chr")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_table_03_chr")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_torture_ch_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ilev_fh_dineeamesa")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("xm_prop_x17_corp_offchair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("ex_prop_offchair_exec_03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("ex_mp_h_stn_chairstrip_07")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ilev_fh_kitchenstool")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ilev_tort_stool")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("hei_prop_yah_seat_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("hei_prop_yah_seat_02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("hei_prop_yah_seat_03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_waiting_seat_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_yacht_seat_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_yacht_seat_02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_yacht_seat_03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_hobo_seat_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.65, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_rub_couch01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("miss_rub_couch_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_ld_farm_couch01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_ld_farm_couch02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_rub_couch02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_rub_couch03")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_rub_couch04")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_lev_sofa_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_res_sofa_l_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_v_med_p_sofa_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("p_yacht_sofa_01_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ilev_m_sofa")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_res_tre_sofa_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_tre_sofa_mess_a_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_tre_sofa_mess_b_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_tre_sofa_mess_c_s")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_roller_car_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("prop_roller_car_02")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("ex_mp_h_stn_chairarm_24")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[GetHashKey("v_ret_chair")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},	
	[GetHashKey("ba_prop_battle_club_chair_01")] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.001, forwardOffset = 0.0, leftOffset = 0.0},	
	[1339364336] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[1630899471] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[1181479993] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[-1202648266] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.5, forwardOffset = 0.0, leftOffset = 0.0},
	[-606800174] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.52, forwardOffset = 0.0, leftOffset = 0.0},
	[-992710074] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.7, forwardOffset = 0.0, leftOffset = 0.0},
	[-1626066319] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.1, forwardOffset = 0.0, leftOffset = 0.0},
	[-1278649385] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = 0.1, forwardOffset = 0.0, leftOffset = 0.0},
	[558578166] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.0, forwardOffset = 0.0, leftOffset = 0.0},
	[-171943901] = { scenario = 'PROP_HUMAN_SEAT_BENCH', verticalOffset = -0.0, forwardOffset = 0.0, leftOffset = 0.0}
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		local playerPed = PlayerPedId()
		if IsPedOnFoot(playerPed) then
			canSleep = false
			if sitting and not IsPedUsingScenario(playerPed, currentScenario) then
				wakeup()
			end
			if IsControlJustPressed(0, 38) and IsControlPressed(0, 21) and IsInputDisabled(0) then
				if sitting then
					wakeup()
					SetEntityCollision(playerPed, true, true)
				else
					checkChair()
				end
			end
		end
		if canSleep then
			Citizen.Wait(1250)
		end
	end
end)

function wakeup()
	local playerPed = PlayerPedId()
	ClearPedTasks(playerPed)
	sitting = false
	SetEntityCoords(playerPed, lastPos)
	FreezeEntityPosition(playerPed, false)
	SetEntityCollision(playerPed, true, true)
	TriggerServerEvent('esx_sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
end

function checkChair()
	local playerPed = PlayerPedId()
	local pedCoords = GetEntityCoords(playerPed)
	for hash, data in pairs(chairs) do
		local object = GetClosestObjectOfType(pedCoords, 5.0, hash, false, false, false)
		if DoesEntityExist(object) then
			if #(pedCoords - GetEntityCoords(object)) < 1.5 then
				sit(object, hash, data)
			end
		end
	end
end

function sit(object, hash_handle, data)
	local pos = GetEntityCoords(object)
	local objectCoords = pos.x .. pos.y .. pos.z
	local playerPed = PlayerPedId()
	ESX.TriggerServerCallback('esx_sit:getPlace', function(occupied)
		if occupied then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Someone is already sat here.' })
		else
			lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords
			TriggerServerEvent('esx_sit:takePlace', objectCoords)
			currentScenario = data.scenario
			TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object) + 180.0, 0, true, true)
			Citizen.Wait(1000)
			sitting = true
			SetEntityCollision(playerPed, false, false)
		end
	end)
end