local ds_hooks = {
	["lostmc_bike_sale"] = "https://discordapp.com/api/webhooks/745702788452974725/LmALV4FPJWf-k66GRTRicawfsSIFA-GS-FFTCTtor24D8jZVso-4WdNcHBuYNvqkCKUt",
	["police_weapons_stats"] = "https://discordapp.com/api/webhooks/757999302596362271/9GciKlsKQO8I1446wSDhW8DzKIkfRRxCg7kYQ9NDQrAMxzOfCV_5bn4UmL7Kx5l72Mnu",
	["judge_warrant_alert"] = "https://discordapp.com/api/webhooks/765922551502340116/34XzvNtWG3xwj-Khg6TXol7b4cGD2umwf0yJng9n9AqTAsxop-6TWLPrj6AiNfpHuu3v",
	["warrant_alert_police"] = "https://discordapp.com/api/webhooks/733116192830652477/Cllx_iU-zkclwacvsAw0uGuvVpReYSGLwj_7SdCC9p2bsVwG1mHkRPzgpL0ETRwBONzC",
	["warrant_alert_nca"] = "https://discordapp.com/api/webhooks/744215680504561664/PWtzfn5TtVs_65QuJLxd2qV1EQqifUn7kCemic5deXDKJNURUUtLSoWmDFCpyB8AR3n1",
	-- phone line hooks
	['ambulance'] = nil,
	['taxi'] = nil,
	['police'] = nil,
	['mechanic'] = nil,
	['gruppe6'] = "https://discord.com/api/webhooks/780572307575144508/rYo3EP4IQRYD6yd7sKTniUcAs8X3DoJxSVA6lkPIjt9FW7gzKSqZhzFvVoN2S0tLIjn6",
	['weazel'] = "https://discord.com/api/webhooks/780571595235655740/nsLufE5ev-HM4Di80wLGMT86Ha7bbl4lAQVz0WG645QrYv4wm_TX50srTImM7YeKcgTk",
	['court'] = "https://discord.com/api/webhooks/800071022685585451/2eb4MvXhYfKIy8AV6oy7tKBJvbzOI56B3DGAnG2QaO5F_Oxe-8HvIsYEq61kGNLeZMl0",
	['iopc'] = "https://discord.com/api/webhooks/760276598778757202/lKXBvFGSsYZAkh3pIEQIERsKbFlInIWNXCYh10t-ETYdG6aiW8D2esrIqqSXctH42n5k",
}

RegisterNetEvent('rpuk:disc_post')
AddEventHandler('rpuk:disc_post', function(src, hook, header, content)
	if src and ds_hooks[hook] and header and content then
		local hookContent = ""
		local embeds = {
			{
				["title"] = header,
				["description"] = content,
				["color"] = 15258703,
				["thumbnail"] = {
					["url"] = "https://i.imgur.com/ZPs8c4V.png",
				},
				["footer"] = {
					["text"] = "Roleplay.co.uk | Stealthee 2020",
				},
			}
		}
		PerformHttpRequest(ds_hooks[hook], function(err, text, headers) end, 'POST', json.encode({content = hookContent, embeds = embeds}), { ['Content-Type'] = 'application/json' })	
	end
end)

--TriggerEvent('rpuk:disc_post', 0, tostring(job), "New Phone Message", tostring(message))