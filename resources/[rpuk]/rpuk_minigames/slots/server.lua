-- Used to map source -> amount to redeem
local redeemTable = {}

-- Generate a result
function GenerateSingleEndResult()
	local value = math.random(0, SLOT_RESULT_CHANCE_SUM)

	local acc = 0
	for i, v in pairs(SLOT_RESULT_CHANCE) do
		acc = acc + v

		if value <= acc then

			return i
		end
	end

	print("somehow reached end of GenerateSingleEndResult, something is wrong!")
end

-- Insert a log into the database for analytic purposes
function InsertGameLog(rpuk_charid, machineTheme, betValue, winningAmount, wheelEndPositions)
	-- Generate string repr
	local wheelEndPositionsStr = {}
	local nameTable = SLOT_RESULT_TO_NAME[machineTheme]
	for i=1,3 do
		local value = wheelEndPositions[i]

		if value % 2 == 0 then
			wheelEndPositionsStr[i] = 'Miss'
		else
			wheelEndPositionsStr[i] = nameTable[SLOT_REELPOS_TO_RESULT[math.floor((value + 1)/2)]]
		end
	end

	-- Insert log
	MySQL.Async.execute('INSERT INTO log_slots (rpuk_charid, machine_theme, bet, winnings, reels, reels_str) VALUES (@rpuk_charid, @machineTheme, @bet, @winnings, @reels, @reelStr)', {
		['@rpuk_charid'] = rpuk_charid,
		['@machineTheme'] = machineTheme,
		['@bet'] = betValue,
		['@winnings'] = winningAmount,
		['@reels'] = json.encode(wheelEndPositions),
		['@reelStr'] = json.encode(wheelEndPositionsStr),
	}, function ()
	end)
end

-- This can be tweaked based off the SLOT_REELPOS_TO_RESULT in consts.lua
-- Odd numbers signify a 'hit', even numbers signify a miss
function GenerateEndPositions()
	local results = { GenerateSingleEndResult(), GenerateSingleEndResult(), GenerateSingleEndResult() }
	local reelPos = {}

	-- Resolve the results to a wheel position of that result
	for i=1,3 do
		local result = results[i]
		local possiblePositions = SLOT_RESULT_TO_REELPOS[result]

		reelPos[i] = ((possiblePositions[math.random(1, #possiblePositions)] - 1) * 2) + 1
	end

	-- 25% chance of miss for each reel
	for i=1,3 do
		if math.random() <= 0.3 then
			reelPos[i] = (math.random(0, 15) * 2) + 2
		end
	end

	return reelPos
end

-- Calculate winnings coefficient given the items on the win line
function CalculateWinningsCoef(win)
	local maxWinningCoef = 0
	for rotate=0,2 do
		local first = win[(rotate % 3) + 1]
		local second = win[((rotate + 1) % 3) + 1]
		local third = win[((rotate + 2) % 3) + 1]

		if first % 2 == 0 then
			first = '_NONE_'
		else
			first = ''..SLOT_REELPOS_TO_RESULT[math.floor((first + 1)/2)]
		end
		if second % 2 == 0 then
			second = '_NONE_'
		else
			second = ''..SLOT_REELPOS_TO_RESULT[math.floor((second + 1)/2)]
		end
		if third % 2 == 0 then
			third = '_NONE_'
		else
			third = ''..SLOT_REELPOS_TO_RESULT[math.floor((third + 1)/2)]
		end

		local firstVal = SLOT_WIN_TABLE[first]
		if firstVal ~= nil then
			local secondVal = firstVal[second]

			if secondVal ~= nil then
				local thirdVal = secondVal[third]

				if thirdVal ~= nil then
					if maxWinningCoef < thirdVal then
						maxWinningCoef = thirdVal
					end
				else
					local default = secondVal['default']
					if default ~= nil then
						if maxWinningCoef < default then
							maxWinningCoef = default
						end
					end
				end
			else
				local default = firstVal['default']
				if default ~= nil then
					if maxWinningCoef < default then
						maxWinningCoef = default
					end
				end
			end
		end
	end

	return maxWinningCoef
end

ESX.RegisterServerCallback('rpuk_slots:spin', function(source, cb, slotThemeId, betMultiplier)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == nil then
		cb(false)
		return
	end

	-- Validate params
	if slotThemeId < 1 or (#SLOT_THEME_TO_BET_VALUE) < slotThemeId then
		cb(false)
		return
	end

	-- Check bet multiplier, preventing sneaky people from passing percentages
	betMultiplier = math.floor(betMultiplier)
	if betMultiplier < 1 or betMultiplier > 5 then
		cb(false)
		return
	end

	-- Calculate the bet amount
	local betBaseValue = SLOT_THEME_TO_BET_VALUE[slotThemeId]
	local betValue = betMultiplier * betBaseValue

	-- Check the player has the required amount of cash
	local cashBalance = xPlayer.getMoney()
	if cashBalance < betValue then
		TriggerClientEvent('esx:showNotification', source, "You don't have enough cash on hand to make a bet of £"..betValue.."!")

		cb(false)
		return
	end

	-- Remove cash
	xPlayer.removeMoney(betValue, ('%s [%s]'):format('Bet Value Pay In', GetCurrentResourceName()))

	-- Generate wheel end positions and calculate the winnings
	local wheelEndPositions = GenerateEndPositions()
	local winningCoef = CalculateWinningsCoef(wheelEndPositions)
	local winningAmount = betValue * winningCoef

	if winningAmount > 0 then
		redeemTable[source] = winningAmount
		print("rpuk_slots: "..GetPlayerName(source).."("..GetPlayerIdentifiers(source)[1]..")".." won "..winningAmount.." from betting "..betValue.." by hitting "..json.encode(wheelEndPositions))
	else
		print("rpuk_slots: "..GetPlayerName(source).."("..GetPlayerIdentifiers(source)[1]..")".." lost "..betValue)
	end

	InsertGameLog(xPlayer.rpuk_charid, slotThemeId, betValue, winningAmount, wheelEndPositions)

	cb(true, wheelEndPositions, winningAmount)
end)

ESX.RegisterServerCallback('rpuk_slots:redeem', function(source, cb)
	if redeemTable[source] == nil then
		cb(false)
		return
	end

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == nil then
		cb(false)
		return
	end

	local value = redeemTable[source]
	redeemTable[source] = nil

	xPlayer.addMoney(value, ('%s [%s]'):format('Casino Slots Payout', GetCurrentResourceName()))

	TriggerClientEvent('esx:showNotification', source, "You won £"..value.."!")

	cb(true)
end)