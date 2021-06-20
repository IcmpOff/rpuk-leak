local managedObjects = {}

AddEventHandler("rpuk_slots_objmanager:add", function(object)
	table.insert(managedObjects, object)
end)

AddEventHandler("rpuk_slots_objmanager:remove", function(object)
	local idx = tablefind(managedObjects, object)
	if idx == 0 then
		return
	end

	table.remove(managedObjects, idx)
end)

function tablefind(tab,el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end

	return -1
end

AddEventHandler("onClientResourceStop", function(res)
	if (res ~= "rpuk_slots") then return end

	for k, object in pairs(managedObjects) do
		SetEntityAsMissionEntity(object, false, true)
		DeleteObject(object)
	end
end)