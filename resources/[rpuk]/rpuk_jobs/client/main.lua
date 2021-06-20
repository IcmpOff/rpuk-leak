IsDead = false

AddEventHandler('esx:onPlayerDeath', function() IsDead = true end)
AddEventHandler('playerSpawned', function(spawn) IsDead = false end)