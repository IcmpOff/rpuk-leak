local cbUrl

AddEventHandler('rpuk_core:takeImgurScreenshot', function(cb)
	exports['screenshot-basic']:requestScreenshot(function(image)
		SendNUIMessage({type = 'imgur', image = image})
	end)

	while not cbUrl do Citizen.Wait(500) end

	cb(cbUrl)
	cbUrl = nil
end)

RegisterNUICallback('imgurUploaded', function(data, cb)
	cbUrl = data.url
	cb('ok')
end)