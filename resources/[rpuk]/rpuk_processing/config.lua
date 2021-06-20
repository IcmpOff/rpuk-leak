Config = {}

Config.DrawDistance = 20.0

-- Batched = true, means the processing will take count x timer.cancel()
-- Batched = false means timer is fixed

Config.ProcessingZone = {
	{
		UID = "process_wood",
		Prompt = "Press ~INPUT_CONTEXT~ to Start Cutting Wood\n[~g~Legal~s~]",
		Marker = vector3(-553.74, 5324.40, 72.60),
		MarkerSettings = {r = 200, g = 200, b = 200, a = 100, type = 1, x = 3.0, y = 3.0, z = 0.6},
		Timer = 2, -- Seconds
		Batch = true,
		Input = { ["wood"] = 1},
		Output = { ["cutted_wood"] = 1 }
	},
}