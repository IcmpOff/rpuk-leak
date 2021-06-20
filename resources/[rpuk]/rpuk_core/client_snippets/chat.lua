local counter = 0

RegisterNetEvent('esx_rpchat:Counter')
AddEventHandler('esx_rpchat:Counter', function()
	counter = counter + 1
	if counter == 2 then
		TriggerServerEvent('esx_rpchat:CounterLimit')
	end
end)

TriggerEvent('chat:addTemplate', 'ooc', '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"> <b>OOC | {0} <span style="font-size:75%;">({1})</b>:</span> {2}</div>')