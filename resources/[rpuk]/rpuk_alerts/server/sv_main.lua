local alertTypes = {
	["dispatch"] = {
		type = "police",
		data = {["code"] = 'GRADE 2', ["name"] = 'Civilian Dispatch', ["icon"] = "fas fa-headset"},
		length = 16000,
		jobs = {"police"},
	},
	["bank"] = {
		type = "police",
		data = {["code"] = 'GRADE 1', ["name"] = 'Property Alarm', ["icon"] = "fa-shopping-basket"},
		length = 6000,
		jobs = {"police"},
	},
	["shop"] = {
		type = "police",
		data = {["code"] = 'GRADE 1', ["name"] = 'Shop Alarm', ["icon"] = "fa-shopping-basket"},
		length = 6000,
		jobs = {"police"},
	},
	["panic"] = {
		type = "panic",
		data = {["code"] = 'GRADE 1', ["name"] = 'PANIC ALARM', ["icon"] = "fa-bell"},
		length = 12000,
		jobs = {"police", "gruppe6"},
	},
	["fts"] = {
		type = "police",
		data = {["code"] = 'GRADE 2', ["name"] = 'Vehicle Failed To Stop', ["icon"] = "fa-car"},
		length = 6000,
		jobs = {"police"},
	},
	["speeding"] = {
		type = "police",
		data = {["code"] = 'GRADE 2', ["name"] = 'Vehicle Seen Speeding', ["icon"] = "fa-car"},
		length = 6000,
		jobs = {"police"},
	},
	["caughtVehicle"] = {
		type = "police",
		data = {["code"] = 'GRADE 2', ["name"] = 'Vehicle Has Been Seen With Outstanding Warrant', ["icon"] = "fa-car"},
		length = 6000,
		jobs = {"police"},
	},
	["speedcameraoffline"] = {
		type = "police",
		data = {["code"] = 'GRADE 1', ["name"] = 'Speed Camera Has Been Disabled', ["icon"] = "fa-car"},
		length = 6000,
		jobs = {"police"},
	},
	["prisonerescape"] = {
		type = "police",
		data = {["code"] = 'GRADE 1', ["name"] = 'Prisoner Missing', ["icon"] = "fa-border-none"},
		length = 6000,
		jobs = {"police", "gruppe6"},
	},
	["patient"] = {
		type = "ambulance",
		data = {["code"] = 'CAT 2', ["name"] = 'Person Injured', ["icon"] = "fa-ambulance"},
		length = 6000,
		jobs = {"ambulance"},
	},
	["powerstationtransformer"] = {
		type = "police",
		data = {["code"] = 'GRADE 1', ["name"] = 'Reports of a explosion', ["icon"] = "fas fa-bolt"},
		length = 6000,
		jobs = {"police", "ambulance"},
	},
	["disturbance"] = {
		type = "police",
		data = {["code"] = 'GRADE 2', ["name"] = 'Reports of a disturbance', ["icon"] = "fas fa-door-closed"},
		length = 8000,
		jobs = {"police", "gruppe6"},
	},
	["powerGrid"] = {
		type = "police",
		data = {["code"] = 'GRADE 2', ["name"] = 'Reports of trespassing', ["icon"] = "fas fa-bolt"},
		length = 8000,
		jobs = {"police", "gruppe6"},
	},
	["lockdownOn"] = {
		type = "police",
		data = {["code"] = 'GRADE 1', ["name"] = 'Prison Lockdown Protocol Has Been Initiated', ["icon"] = "fas fa-lock-open"},
		length = 8000,
		jobs = {"police", "gruppe6"},
	},
	["lockdownOff"] = {
		type = "police",
		data = {["code"] = 'NO GRADE', ["name"] = 'Prison Lockdown Protocol Has Been Concluded', ["icon"] = "fas fa-lock-closed"},
		length = 8000,
		jobs = {"police", "gruppe6"},
	},
	["drugsale"] = {
		type = "police",
		data = {["code"] = 'GRADE 3', ["name"] = 'Reports of Drugs Dealers', ["icon"] = "fas fa-cannabis"},
		length = 8000,
		jobs = {"police"},
	},
	["collection"] = {
		type = "police",
		data = {["code"] = 'GRADE 1', ["name"] = 'Collection is Ready', ["icon"] = "fas fa-pound-sign"},
		length = 8000,
		jobs = {"gruppe6"},
	},
	["shooting"] = {
		type = "police",
		data = {["code"] = 'GRADE 3', ["name"] = 'Reports Of Firearm Discharge', ["icon"] = "fas fa-headset"},
		length = 8000,
		jobs = {"police"},
	},
	["stabbing"] = {
		type = "police",
		data = {["code"] = 'GRADE 3', ["name"] = 'Reports Of A Physical Altercation', ["icon"] = "fas fa-headset"},
		length = 8000,
		jobs = {"police"},
	},
	["patientInBed"] = {
		type = "ambulance",
		data = {["code"] = 'CAT 2', ["name"] = 'Patient Has Requested Support At Hospital', ["icon"] = "fa-ambulance"},
		length = 8000,
		jobs = {"ambulance"},
	},
	["gpAppointment"] = {
		type = "ambulance",
		data = {["code"] = 'CAT 1', ["name"] = 'Patient Has Made A GP Appointment', ["icon"] = "fa-ambulance"},
		length = 8000,
		jobs = {"ambulance"},
	}
}
----Different types:
--police
--ambulance
--panic

RegisterNetEvent('rpuk_alerts:sNotification')
AddEventHandler('rpuk_alerts:sNotification', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not data.coords then
		data.coords = GetEntityCoords(GetPlayerPed(source))
	end

	if alertTypes[data.notiftype] then
		if type(data.coords) == "vector3" then
			local alertType = alertTypes[data.notiftype].type
			local temp = alertTypes[data.notiftype].data
			temp["coords"] = data.coords
			if data.plate then temp["veh-reg"] = data.plate end
			if data.model then temp["veh-model"] = data.model end
			if data.officerName then temp["officer-name"] = xPlayer.firstname .. " " .. xPlayer.lastname end
			if data.frequency then temp["radio-freq"] = data.frequency end
			if data.extraNotes then temp["extra-notes"] = data.extraNotes end
			if data.dispatch then temp["dispatch"] = data.dispatch end
			if data.gender then temp["gender"] = data.gender end
			local length = alertTypes[data.notiftype].length
			local jobs = alertTypes[data.notiftype].jobs
			TriggerClientEvent('rpuk_alerts:RecieveAlert', -1, alertType, temp, length, jobs)
		else
			print("RPUK ALERTS: WRONG DATA TYPE FROM SOURCE " .. source)
		end
	end
end)
