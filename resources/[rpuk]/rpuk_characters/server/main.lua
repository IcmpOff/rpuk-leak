local takenBuckets = {}
function getBucketId(playerId)
	local bucketId = nil
	for i=1,63 do
		if not takenBuckets[i] then
			bucketId = i
			break
		end
	end
	if bucketId == nil then
		return false
	else
		table.insert(takenBuckets, bucketId)
		SetPlayerRoutingBucket(playerId, bucketId)
		return true
	end
end

AddEventHandler('playerDropped', function (reason) --If disconenct whilst in bucket make it available again
	local pBuck = GetPlayerRoutingBucket(source)
	if (pBuck > 0) then
		takenBuckets[pBuck] = nil
	end
end)


ESX.RegisterServerCallback('rpuk_characters:fetchCharacters', function(playerId, cb)
	local result = getBucketId(playerId)
	if result == false then
		print("-----ERROR------ NO ROUTING BUCKETS LEFT, RESULTING TO LEAVING PLAYER IN 0")
	end
	MySQL.Async.fetchAll([===[
		SELECT
			rpuk_charid, character_index, health, armour, accounts, job, firstname, lastname, skin, jailed, dead
		FROM users
		WHERE
			identifier = @identifier AND state = 0
	]===], {
		['@identifier'] = GetPlayerIdentifiers(playerId)[1]
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('rpuk_characters:deleteCharacter', function(playerId, cb, playerCharacterIndex)
	local playerIdentifier = GetPlayerIdentifiers(playerId)[1]

	if playerCharacterIndex and type(playerCharacterIndex) == 'number' then
		MySQL.Async.execute([===[
			UPDATE users
			SET
				state = 1, character_index = -1
			WHERE
				identifier = @identifier AND character_index = @character_index AND state = 0
		]===], {
			['@identifier'] = playerIdentifier,
			['@character_index'] = playerCharacterIndex,
		}, function(rowsChanged)
			cb(rowsChanged)
		end)
	else
		TriggerEvent('rpuk_anticheat:ban', playerId, {
			reason = 'SQL injection attempt',
			period = '0',
			from = 'RPUK Anticheat'
		})

		cb(0)
	end
end)

ESX.RegisterServerCallback('rpuk_characters:choosenCharacter', function(playerId, cb, characterIndex, doesCharacterExist, firstName, lastName, age, height, gender, updateNames)
	local curBucket = GetPlayerRoutingBucket(playerId)
	takenBuckets[curBucket] = nil
	SetPlayerRoutingBucket(playerId, 0)

	local playerIdentifier = GetPlayerIdentifiers(playerId)[1]

	if updateNames then
		MySQL.Sync.execute([===[
			UPDATE users
			SET
				firstname = @firstname, lastname = @lastname
			WHERE
				identifier = @identifier AND character_index = @character_index
		]===], {
			['@identifier'] = playerIdentifier,
			['@character_index'] = characterIndex,
			['@firstname'] = firstName,
			['@lastname'] = lastName
		})
	end

	if doesCharacterExist then
		MySQL.Async.fetchAll([===[
			SELECT
				position, job, skin, jailed, dead, health, armour
			FROM users
			WHERE
				identifier = @identifier AND character_index = @character_index
		]===], {
			['@identifier'] = playerIdentifier,
			['@character_index'] = characterIndex
		}, function(result)
			TriggerEvent('esx:onPlayerJoined', playerId, characterIndex)
			cb(result[1].position, result[1].job, result[1].skin, result[1].jailed, result[1].dead, result[1].health, result[1].armour)
		end)
	else
		MySQL.Async.execute([===[
			INSERT INTO users
				(identifier, character_index, accounts, firstname, lastname, dateofbirth, height, sex, phone_number)
			VALUES
				(@identifier, @character_index, @accounts, @firstname, @lastname, @dateofbirth, @height, @sex, @phone_number)
		]===], {
			['@identifier'] = playerIdentifier,
			['@character_index'] = characterIndex,
			['@accounts'] = Config.StartingAccountMoney,
			['@firstname'] = firstName,
			['@lastname'] = lastName,
			['@dateofbirth'] = age,
			['@height'] = height,
			['@sex'] = (gender == 'male' and 'm') or 'f',
			['@phone_number'] = generatePhoneNumber()
		}, function(rowsChanged)
			TriggerEvent('esx:onPlayerJoined', playerId, characterIndex)
			cb(nil, 'unemployed', nil, false, false, 200, 0)
		end)
	end
end)

--- Generate number (string now) with format XXX-XXXX
function generatePhoneNumber()
	while true do
		Citizen.Wait(100)
		local prefix, suffix = math.random(0, 999), math.random(0, 9999)
		local formattedNumber = ('%s-%s'):format(prefix, suffix)

		if isPhoneNumberAvailable(formattedNumber) then
			return formattedNumber
		end
	end
end

function isPhoneNumberAvailable(phoneNumber)
	local fetched = MySQL.Sync.fetchScalar('SELECT 1 FROM users WHERE phone_number = @phone_number', {
		['@phone_number'] = phoneNumber
	})

	return fetched == nil
end