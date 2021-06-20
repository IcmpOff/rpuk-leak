Config = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM user_groups', {}, function(result)
		for k, v in pairs(result) do
			local groups = json.decode(v.groups)
			for group, active in pairs(groups) do
				if string.find(group, 'staff_level_') or string.find(group, 'dev_level_') and active then
					Config.Priority[v.identifier] = k
					break
				end
			end
		end
	end)
end)

-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = true

-- how much priority power grace time will give
Config.GracePower = 5

-- how long grace time lasts in seconds
Config.GraceTime = 480

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 1000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = true

-- simple localization
Config.Language = {
	joining = "Joining...",
	connecting = "Connecting...",
	idrr = "There was an error",
	err = "There was an error",
	pos = "You are %d/%d in queue \xF0\x9F\x95\x9C%s",
	connectingerr = "Error adding you to connecting list",
	wlonly = "You must be whitelisted to join this server",
	steam = "Steam must be running, start it and restart the game"
}