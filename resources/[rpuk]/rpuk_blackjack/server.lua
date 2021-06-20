ranks = {'02', '03', '04', '05', '06', '07', '08', '09', '10', 'JACK', 'QUEEN', 'KING', 'ACE'}
suits = {'SPD', 'HRT', 'DIA', 'CLUB'}

function shuffle(tbl)
	math.randomseed(os.time())
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

function getDeck()
	local tDeck = {}
	for _,rank in pairs(ranks) do
		for _,suit in pairs(suits) do
			table.insert(tDeck, suit .. "_" .. rank)
		end
	end
	return shuffle(tDeck)
end

function takeCard(tDeck)
	--return table.remove(tDeck, math.random(1,#tDeck)) --naughty! doesn't take from top, and could multi-roll a random
	return table.remove(tDeck, 1) -- this is clean. Takes from top. Don't use this deck for more than a hand or two, though, or it'll run out!
end

function cardValue(card)
	local rank = 10 --everything not number or ace is a 10
	for i=2,10 do
		if string.find(card, tostring(i)) then
			rank = i
		end
	end
	if string.find(card, 'ACE') then
		rank = 11
	end

	return rank
end

function handValue(bjhand)
	local tmpValue = 0
	local numAces = 0

	for i,v in pairs(bjhand) do
		tmpValue = tmpValue + cardValue(v)
	end

	for i,v in pairs(bjhand) do
		if string.find(v, 'ACE') then numAces = numAces + 1 end
	end

	repeat
		if tmpValue > 21 and numAces > 0 then
			tmpValue = tmpValue - 10
			numAces = numAces - 1
		else
			break
		end
	until numAces == 0

	return tmpValue
end

players = {
	-- [1] = { -- table
		-- [1] = { -- player
			-- player = source
			-- seat = 1
			-- hand = {},
			-- splitHand = {}
			-- player_in = true,
			-- bet = 1500,
		-- }
	-- },
	-- [2] = {},
	-- [3] = {},
	-- [4] = {},
}
timeTracker = {}

tableTracker = {
	-- ["2"] = 1,
}

function FindPlayerIdx(tbl, src) --returns the table subscript/key if there is a player in the supplied table with the requested slot/source, else returns nil

	for i = 1, #tbl do
		if tbl[i].player == src then
			return i
		end
	end

	return nil
end

function checkChips(source)
	local tokenCount = 0
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local tokenItem = xPlayer.getInventoryItem('casino_blackjack_chip')
		tokenCount = tokenItem.count
	end

	return tokenCount or 0
end

function takeChips(source, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local tokenItem = xPlayer.getInventoryItem('casino_blackjack_chip')
	local tokenCount = tokenItem.count

	amount = math.tointeger(amount)

	if xPlayer ~= nil and tokenCount >= amount then
		DebugPrint("TAKECHIPS: TAKE FROM PLAYER "..source.." �"..amount)
		xPlayer.removeInventoryItem('casino_blackjack_chip', amount)
	else
		DebugPrint("TAKECHIPS: PLAYER " .. source .. " ABSENT OR HASN'T ENOUGH CHIPS TO TAKE � " .. amount .." FROM")
	end
end

function giveChips(source, amount)
	local xPlayer = ESX.GetPlayerFromId(source)

	amount = math.tointeger(amount)

	if xPlayer ~= nil and amount > 0 then
		xPlayer.addInventoryItem('casino_blackjack_chip', amount)
		TriggerClientEvent('esx:showNotification', source, "Additional:Blackjack Chips: x".. amount)
		DebugPrint("GIVECHIPS: �".. amount .. " TO PLAYER " .. source)
	elseif amount < 0 then
		DebugPrint("GIVECHIPS: PLAYER " .. source .. " CANNOT BE GIVEN �"..amount.." - NEGATIVE AMOUNT!")
	elseif amount == 0 then
		DebugPrint("GIVECHIPS: PLAYER " .. source .. " CANNOT BE GIVEN �"..amount.." - ZERO AMOUNT!")
	else
		DebugPrint("GIVECHIPS: PLAYER " .. source .. " ABSENT! CAN'T GIVE THEM �"..amount.." CHIPS!")
	end
end

function givePlayTokens(source, win)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = 1

	if win == true then
		amount = math.random(5,15)
	end

	if xPlayer ~= nil then
		DebugPrint("GIVEPLAYTOKENS: GIVE PLAYER ".. source .." T" .. amount .. " WIN? "..tostring(win))
		xPlayer.addInventoryItem('casino_playtoken', amount)
		TriggerClientEvent('esx:showNotification', source, "Additional:Casino Play Tokens: x".. amount)
	else
		DebugPrint("GIVEPLAYTOKENS: PLAYER " .. source .. " NO LONGER EXISTS TO PAY TOKENS TO!")
	end

end
--                                                                                             17         24  
--	splitReaction, splitComboReaction, splitMultiplier = calculateSplit(index, v.player, v.splitHand, dealerHand, "win")

function calculateSplit(index, player, splitHand, dealerHand, strMainHandState) --returns splitReaction, splitComboReaction, splitMultiplier

	local splitResult = handValue(splitHand)
	local splitReaction = "impartial"
	local splitMultiplierTable = splitMultipliers[strMainHandState]
	local splitMultiplier = 1
	local splitComboReaction = "impartial"

	if splitResult == 21 and #splitHand == 2 then -- SPLIT NATURAL BLACKJACK
		givePlayTokens(player, true)
		DebugPrint("TABLE "..index..": PLAYER "..player.." SPLIT WON NATURAL")
		splitReaction = "good"
		splitMultiplier = splitMultiplierTable[1]

	elseif splitResult <= 21 and (splitResult > handValue(dealerHand) or handValue(dealerHand) > 21) then -- SPLIT WIN
		givePlayTokens(player, true)
		DebugPrint("TABLE "..index..": PLAYER "..player.." SPLIT WON")
		splitReaction = "good"
		splitMultiplier = splitMultiplierTable[2]

	elseif splitResult <= 21 and splitResult == handValue(dealerHand) then -- SPLIT PUSH
		givePlayTokens(player, false)
		DebugPrint("TABLE "..index..": PLAYER "..player.." SPLIT IS PUSH")
		splitReaction = "impartial"
		splitMultiplier = splitMultiplierTable[3]

	else -- SPLIT LOSE/BUST
		givePlayTokens(player, false)
		DebugPrint("TABLE "..index..": PLAYER "..player.." SPLIT LOST")
		splitReaction = "bad"
		splitMultiplier = splitMultiplierTable[4]

	end

	splitComboReaction = getSplitComboReaction(splitMultiplier)

	return splitReaction, splitComboReaction, splitMultiplier

end

function getSplitComboReaction(multiplier)
	if multiplier > 1 then
		return "good"
	elseif multiplier == 1 then
		return "impartial"
	else
		return "bad"
	end
end


function HaveAllPlayersBetted(bjtable) --returns true if all players at the table have bet more than zero, else false
	for i,v in pairs(bjtable) do
		if v.bet < 1 then
			return false
		end
	end
	return true
end

function ArePlayersStillIn(bjtable) --returns true if any players are still in the game, else false if they're all out
	for i,v in pairs(bjtable) do
		if v.player_in == true then
			return true
		end
	end
	return false
end

function PlayDealerAnim(dealer, animDict, anim)
	TriggerClientEvent("BLACKJACK:PlayDealerAnim", -1, dealer, animDict, anim)
end

function PlayDealerSpeech(dealer, speech)
	TriggerClientEvent("BLACKJACK:PlayDealerSpeech", -1, dealer, speech)
end

function SetPlayerBet(i, seat, bet, betId, double, split)
	split = split or false
	double = double or false


	local num = FindPlayerIdx(players[i], source)

	if num ~= nil then
		if double == false and split == false then
			takeChips(source, bet)

			players[i][num].bet = tonumber(bet)
		end

		TriggerClientEvent("BLACKJACK:PlaceBetChip", -1, i, 5-seat, bet, double, split)
	else
		DebugPrint("SETPLAYERBET: TABLE "..i..": PLAYER "..source.." ATTEMPTED BET BUT NO LONGER TRACKED?")
	end
end

RegisterNetEvent("BLACKJACK:SetPlayerBet")
AddEventHandler('BLACKJACK:SetPlayerBet', SetPlayerBet)

function CheckPlayerBet(i, bet)
	DebugPrint("CHECKPLAYERBET: TABLE "..i..": CHECKING PLAYER "..source.."'s CHIPS")

	local playerChips = 0 -- Get money

	playerChips = checkChips(source)

	local canBet = false

	if playerChips ~= nil then
		if playerChips >= bet then
			canBet = true
		end
	end

	TriggerClientEvent("BLACKJACK:BetReceived", source, canBet)
end

RegisterNetEvent("BLACKJACK:CheckPlayerBet")
AddEventHandler("BLACKJACK:CheckPlayerBet", CheckPlayerBet)

RegisterNetEvent("BLACKJACK:ReceivedMove")


function LogToDB(source, bet, winnings, mainHand, splitHand, dealerHand)

	local xPlayer = ESX.GetPlayerFromId(source)
	local rpuk_charid = xPlayer.rpuk_charid
	
	local splitOutput = nil
	if splitHand ~= nil then
		splitOutput = json.encode(splitHand)
	end

	MySQL.Async.execute('INSERT INTO rpuk_logs_blackjack (rpuk_charid, bet, winnings, mainhand, splithand, dealerhand) VALUES (@rpuk_charid, @bet, @winnings, @mainhand, @splithand, @dealerhand)', {
		['@rpuk_charid'] = rpuk_charid,
		['@bet'] = bet,
		['@winnings'] = winnings,
		['@mainhand'] = json.encode(mainHand),
		['@splithand'] = splitOutput,
		['@dealerhand'] = json.encode(dealerHand)
	}, function ()
		DebugPrint ("INFO: BLACKJACK: LogToDB: rpuk_charid: "..rpuk_charid..", bet: "..bet..", winnings: ".. winnings)
	end)
end


function StartTableThread(i)
	Citizen.CreateThread(function()
		local index = i
		-- DebugPrint(index)
		while true do Wait(0)
			if players[index] and #players[index] ~= 0 then
				DebugPrint("WAITING FOR ALL PLAYERS AT TABLE "..index.." TO PLACE THEIR BETS.")

				-- TODO: DONT FORGET TO REMOVE THIS JESUS CHRIST

				-- local bet = 15000

				-- takeChips(players[index][1].player, bet)
				-- players[index][1].bet = bet

				-- for num,_ in pairs(players[index]) do
					-- TriggerClientEvent("BLACKJACK:RequestBets", players[index][num].player)
				-- end

				PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_place_bet_request")
				PlayDealerSpeech(index, "MINIGAME_DEALER_PLACE_CHIPS")

				repeat
					for i,v in pairs(players[index]) do
						TriggerClientEvent("BLACKJACK:SyncTimer", v.player, bettingTime - timeTracker[index])
					end -- Remove players from round who didn't bet in time
					Wait(1000)
					timeTracker[index] = timeTracker[index] + 1
				until HaveAllPlayersBetted(players[index]) or #players[index] == 0 or timeTracker[index] >= bettingTime

				if #players[index] == 0 then
					DebugPrint("BETTING ENDED AT TABLE "..index..", NO MORE PLAYERS")
					-- break
				else
					for i,v in pairs(players[index]) do
						if v.bet < 1 then
							v.player_in = false
						end
					end -- Remove players from round who didn't bet in time

					if ArePlayersStillIn(players[index]) then -- did everyone just not bet?
						DebugPrint("BETS PLACED AT TABLE "..index..", STARTING GAME")

						PlayDealerSpeech(index, "MINIGAME_DEALER_CLOSED_BETS")

						local currentPlayers = {table.unpack(players[i])}

						--sort the current players to correct table seating order
						table.sort(currentPlayers, function(a,b) return a.seat > b.seat end)

						local deck = getDeck()
						local dealerHand = {}

						local gameRunning = true

						Wait(1500)

						for x=1,2 do

							--players' cards
							for i,v in pairs(currentPlayers) do
								if v.player_in then
									local card = takeCard(deck)
									TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.hand+1, card)
									PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_deal_card_player_0" .. 5-v.seat)
									table.insert(v.hand, card)

									Wait(2000)

									DebugPrint("TABLE "..index..": DEALT PLAYER ".. v.player .." "..card)

									if handValue(v.hand) == 21 then
										PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_BLACKJACK")
									else
										PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.hand))
									end
								end
							end


							--Dealer's cards (first facedown, second up)
							local card = takeCard(deck)
							table.insert(dealerHand, card)

							TriggerClientEvent("BLACKJACK:GiveCard", -1, index, 0, #dealerHand, card, #dealerHand == 1)

							if #dealerHand == 1 then
								PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_deal_card_self")
								DebugPrint("TABLE "..index..": DEALT DEALER [HIDDEN] " .. card)
							else
								PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_deal_card_self_second_card")
								DebugPrint("TABLE "..index..": DEALT DEALER "..card)
							end
							Wait(2000)

							if #dealerHand > 1 then
								PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..cardValue(dealerHand[2]))
							end
						end

						if handValue(dealerHand) == 21 then
							--dealer has a natural
							DebugPrint("TABLE "..index..": DEALER HAS BLACKJACK")
							PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_check_and_turn_card")
							Wait(2000)
							PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_BLACKJACK")
							TriggerClientEvent("BLACKJACK:DealerTurnOverCard", -1, index)

							--check all the players for naturals
							for i,v in pairs(currentPlayers) do
								if handValue(v.hand) == 21 then

									--this player has natural, gets push
									TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "impartial", "Blackjack", false)
									DebugPrint("TABLE "..index..": PLAYER ".. v.player .." HAS BLACKJACK w/PUSH TO DEALER NATURAL")
									giveChips(v.player, v.bet)
									LogToDB(v.player, v.bet, v.bet, v.hand, v.splitHand, dealerHand)
									givePlayTokens(v.player, false)
									v.player_in = false
--									Wait(2000)
--									PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_retrieve_cards_player_0".. 5-v.seat)
--									Wait(500)
--									TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
								else

									--this players loses to dealer's natural blackjack
									TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "bad","Blackjack", false)
									DebugPrint("TABLE "..index..": PLAYER ".. v.player .." HAS LOST TO DEALER NATURAL")
									LogToDB(v.player, v.bet, 0, v.hand, v.splitHand, dealerHand)
									givePlayTokens(v.player, false)
									v.player_in = false
--									Wait(2000)
--									PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_retrieve_cards_player_0".. 5-v.seat)
--									Wait(500)
--									TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
								end
							end

							gameRunning = false

						elseif cardValue(dealerHand[2]) == 10 or cardValue(dealerHand[2]) == 11 then
							DebugPrint("TABLE "..index..": DEALER HAS A 10 OR ACE UP, CHECKING HIDDEN..")
							PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_check_card")
							Wait(2000)

						end

						--dealer does NOT have blackjack, pay the player naturals
						for i,v in pairs(currentPlayers) do
							if handValue(v.hand) == 21 then

								TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "good", handValue(dealerHand), false)
								DebugPrint("TABLE "..index..": PLAYER ".. v.player .." HAS BLACKJACK")
								giveChips(v.player, v.bet*2.5)
								LogToDB(v.player, v.bet, v.bet*2.5, v.hand, v.splitHand, dealerHand)
								givePlayTokens(v.player, true)
								v.player_in = false
--								PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_retrieve_cards_player_0".. 5-v.seat)
--								Wait(500)
--								TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
							end
						end

						--########################
						--MAIN FOLLOWUP DEALS LOOP
						--########################


						if gameRunning == true then --now we're into the follow-up deals, player-by-player then dealer.
							for i,v in pairs(currentPlayers) do
								if v.player_in then
									if tableTracker[tostring(v.player)] == nil then
										DebugPrint("TABLE "..index..": PLAYER ".. v.player .." WAS PUT OUT DUE TO LEAVING")
										v.player_in = false
										TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
									else

										--########################
										--FOCUS ON PLAYER
										--########################

										PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_dealer_focus_player_0".. 5-v.seat .."_idle_intro")
										Wait(1500)
										PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_ANOTHER_CARD")
										while v.player_in == true and #v.hand < 7 do -- (no 5 card limit for RPUK!)

											--##########################
											--MAIN DEAL LOOP STARTS HERE
											--##########################

											timeTracker[index] = 0
											Wait(0)
											PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_dealer_focus_player_0".. 5-v.seat .."_idle")
											DebugPrint("TABLE "..index..": AWAITING MOVE FROM PLAYER ".. v.player )
											TriggerClientEvent("BLACKJACK:RequestMove", v.player, moveTime - timeTracker[index])
											local receivedMove = false
											local move = "stand"
											local eventHandler = AddEventHandler("BLACKJACK:ReceivedMove", function(m)
												if source ~= v.player then return end
												move = m
												receivedMove = true
											end)

											while receivedMove == false and tableTracker[tostring(v.player)] ~= nil and timeTracker[index] < moveTime do

												--########################
												--WAIT FOR PLAYER ACTION
												--########################

												for i,v in pairs(currentPlayers) do
													TriggerClientEvent("BLACKJACK:SyncTimer", v.player, moveTime - timeTracker[index])
												end
												Wait(1000)
												timeTracker[index] = timeTracker[index] + 1
											end
											--repeat Wait(0) until receivedMove == true
											RemoveEventHandler(eventHandler)

											if tableTracker[tostring(v.player)] == nil then
												DebugPrint("TABLE "..index..": PLAYER "..v.player.." WAS PUT OUT DUE TO LEAVING")
												v.player_in = false
												TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
											else

												--########################
												--PLAYER HAS ACTED
												--########################

												if move == "hit" then

													--########################
													--PLAYER HAS HIT
													--########################

													local card = takeCard(deck)
													TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.hand+1, card)
													PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_hit_card_player_0" .. 5-v.seat)
													table.insert(v.hand, card)
													Wait(1500)
													DebugPrint("TABLE "..index..": DEALT PLAYER "..v.player.." "..card)

													if handValue(v.hand) == 21 then

														--###########################
														--(HIT) PLAYER HAS 21
														--###########################

														DebugPrint("TABLE "..index..": PLAYER ".. v.player .." HAS 21")
														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.hand))
														break
													elseif handValue(v.hand) > 21 then

														--########################
														--(HIT) PLAYER HAS BUST
														--########################

														TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "bad", handValue(dealerHand), false)
														givePlayTokens(v.player, false)
														LogToDB(v.player, v.bet, 0, v.hand, v.splitHand, dealerHand)
														DebugPrint("TABLE "..index..": PLAYER ".. v.player .." WENT BUST")
														v.player_in = false
														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_PLAYER_BUST")
--														Wait(2000)
--														PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_retrieve_cards_player_0".. 5-v.seat)
--														Wait(500)
--														TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
													else

														--########################
														--(HIT) PLAYER STILL IN
														--########################

														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.hand))
													end


												elseif move == "double" then

													--########################
													--PLAYER HAS DOUBLED-DOWN
													--########################

													takeChips(v.player, v.bet)
													v.bet = v.bet*2

													-- TriggerClientEvent("BLACKJACK:PlaceBetChip", -1, i, 5-v.seat, betId)

													local card = takeCard(deck)
													TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.hand+1, card, false, false, true)
													PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_hit_card_player_0" .. 5-v.seat)
													table.insert(v.hand, card)
													Wait(1500)
													DebugPrint("TABLE "..index..": DEALT PLAYER ".. v.player .." "..card)

													if handValue(v.hand) == 21 then

														--########################
														--(DD) PLAYER HAS 21
														--########################

														DebugPrint("TABLE "..index..": PLAYER ".. v.player .." HAS 21")
														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.hand))
														break
													elseif handValue(v.hand) > 21 then

														--########################
														--(DD) PLAYER HAS BUST
														--########################

														TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "bad", handValue(dealerHand), false)
														DebugPrint("TABLE "..index..": PLAYER ".. v.player .." WENT BUST")
														givePlayTokens(v.player, false)
														LogToDB(v.player, v.bet, 0, v.hand, v.splitHand, dealerHand)
														v.player_in = false
														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_PLAYER_BUST")
--														Wait(2000)
--														PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_retrieve_cards_player_0".. 5-v.seat)
--														Wait(500)
--														TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
													else

														--########################
														--(DD) PLAYER STILL IN
														--########################

														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.hand))
													end
													break --THIS IS A DOUBLE-DOWN, SO WE'RE DONE NO MATTER WHAT!


												elseif move == "split" then

													--########################
													--PLAYER HAS SPLIT
													--########################

													takeChips(v.player, v.bet)
													v.bet = v.bet*2

													-- TriggerClientEvent("BLACKJACK:PlaceBetChip", -1, i, 5-v.seat, betId)

													PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_split_card_player_0" .. 5-v.seat)

													v.splitHand = {}

													local splitCard = table.remove(v.hand, 2)
													table.insert(v.splitHand, splitCard)

													Wait(500)

													TriggerClientEvent("BLACKJACK:SplitPlayerHand", -1, index, v.seat, #v.splitHand, v.hand, v.splitHand)

													Wait(1000)

													--################################################################
													--SPLIT - 2ND CARD AUTOMATIC DEAL TO FIRST (MAIN) HAND AFTER SPLIT
													--################################################################

													local card = takeCard(deck)
													TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.hand+1, card, false, false)
													PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_hit_card_player_0" .. 5-v.seat)

													table.insert(v.hand, card)
													Wait(1500)
													DebugPrint("TABLE "..index..": DEALT PLAYER ".. v.player .." "..card)

													if handValue(v.hand) == 21 then -- SPLITMODE, MAIN HAND NATURAL

														--###############################################
														--(SPLIT-MAIN-AUTO2) PLAYER HAS NATURAL BLACKJACK
														--###############################################

														DebugPrint("TABLE "..index..": PLAYER ".. v.player .." HAS 21")
														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_BLACKJACK")
														
													else
														--##################################
														--(SPLIT-MAIN-AUTO2) PLAYER STILL IN
														--##################################

														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.hand))
													end

													--##################################################################
													--SPLIT - 2ND CARD AUTOMATIC DEAL TO SECOND (SPLIT) HAND AFTER SPLIT
													--##################################################################

													local card = takeCard(deck)
													TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.splitHand+1, card, false, true)
													PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_hit_second_card_player_0" .. 5-v.seat)

													table.insert(v.splitHand, card)
													Wait(1500)
													DebugPrint("TABLE "..index..": DEALT PLAYER ".. v.player .." "..card)

													if handValue(v.splitHand) == 21 then -- SPLITMODE, SPLIT HAND NATURAL

														--################################################
														--(SPLIT-SPLIT-AUTO2) PLAYER HAS NATURAL BLACKJACK
														--################################################

														DebugPrint("TABLE "..index..": PLAYER ".. v.player .." HAS 21")
														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_BLACKJACK")

													else

														--#########################################
														--(SPLIT-SPLIT-AUTO2) PLAYER STILL IN
														--#########################################

														PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.splitHand))
													end

													--###########################################
													--SPLIT-MAIN HAND FOCUS ON PLAYER
													--###########################################

													PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_ANOTHER_CARD")

													while handValue(v.hand) < 21 and #v.hand < 7 do -- not 5 for RPUK!


														--###########################################
														--SPLIT-MAIN CONTINUING MOVES LOOP
														--###########################################

														Wait(0)
														timeTracker[index] = 0
														PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_dealer_focus_player_0".. 5-v.seat .."_idle")
														DebugPrint("TABLE "..index..": AWAITING MOVE FROM PLAYER ".. v.player )
														TriggerClientEvent("BLACKJACK:RequestMove", v.player, moveTime - timeTracker[index])
														local receivedMove = false
														local move = "stand"
														local eventHandler = AddEventHandler("BLACKJACK:ReceivedMove", function(m)
															if source ~= v.player then return end
															move = m
															receivedMove = true
														end)

														while receivedMove == false and tableTracker[tostring(v.player)] ~= nil and timeTracker[index] < moveTime do

															--#################################
															--SPLIT-MAIN WAIT FOR PLAYER ACTION
															--#################################

															for i,v in pairs(currentPlayers) do
																TriggerClientEvent("BLACKJACK:SyncTimer", v.player, moveTime - timeTracker[index])
															end
															Wait(1000)
															timeTracker[index] = timeTracker[index] + 1
														end

														RemoveEventHandler(eventHandler)

														if tableTracker[tostring(v.player)] == nil then
															DebugPrint("TABLE "..index..": PLAYER "..v.player.." WAS PUT OUT DUE TO LEAVING")
															v.player_in = false
															TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
															break
														else

															--###########################
															--SPLIT-MAIN PLAYER HAS ACTED
															--###########################

															if move == "hit" then --SPLITMODE, MAIN HAND HIT

																--#########################
																--SPLIT-MAIN PLAYER HAS HIT
																--#########################

																local card = takeCard(deck)
																TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.hand+1, card, false, false)
																PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_hit_card_player_0" .. 5-v.seat)
																table.insert(v.hand, card)
																Wait(1500)
																DebugPrint("TABLE "..index..": DEALT PLAYER ".. v.player .." "..card)

																if handValue(v.hand) == 21 then --SPLITMODE, MAIN HAND BLACKJACK NON-NAT AFTER HIT

																	--##############################
																	--(HIT) SPLIT-MAIN PLAYER HAS 21
																	--##############################

																	DebugPrint("TABLE "..index..": PLAYER ".. v.player .." HAS 21")
																	PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.hand))
																	break
																elseif handValue(v.hand) > 21 then --SPLITMODE, MAIN HAND BUST AFTER HIT

																	--################################
																	--(HIT) SPLIT-MAIN PLAYER HAS BUST
																	--################################

																	--TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "bad", handValue(dealerHand), false)
																	--givePlayTokens(v.player, false)
																	DebugPrint("TABLE "..index..": PLAYER ".. v.player .." WENT BUST")
																	PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_PLAYER_BUST")
																else

																	--##############################
																	--(HIT) SPLIT-MAIN PLAYER STILL IN
																	--##############################

																	PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.hand))
																end

															elseif move == "stand" then

																	--##############################
																	--SPLIT-MAIN PLAYER CHOSE STAND
																	--##############################

																break
															end
														end
													end

													--###########################################
													--SPLIT-SPLIT HAND FOCUS ON PLAYER
													--###########################################

													PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_dealer_focus_player_0".. 5-v.seat .."_idle_outro")
													Wait(1500)

													PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_dealer_focus_player_0".. 5-v.seat .."_idle_intro_split")
													Wait(1500)
													PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_ANOTHER_CARD")

													while handValue(v.splitHand) < 21 and #v.splitHand < 7 do -- not 5 for RPUK!

														--###########################################
														--SPLIT-SPLIT HAND CONTINUING MOVES LOOP
														--###########################################

														Wait(0)
														timeTracker[index] = 0
														PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_dealer_focus_player_0".. 5-v.seat .."_idle_split")
														DebugPrint("TABLE "..index..": AWAITING MOVE FROM PLAYER ".. v.player )
														TriggerClientEvent("BLACKJACK:RequestMove", v.player, moveTime - timeTracker[index])
														local receivedMove = false
														local move = "stand"
														local eventHandler = AddEventHandler("BLACKJACK:ReceivedMove", function(m)
															if source ~= v.player then return end
															move = m
															receivedMove = true
														end)

														while receivedMove == false and tableTracker[tostring(v.player)] ~= nil and timeTracker[index] < moveTime do

															--#################################
															--SPLIT-SPLIT WAIT FOR PLAYER ACTION
															--#################################

															for i,v in pairs(currentPlayers) do
																TriggerClientEvent("BLACKJACK:SyncTimer", v.player, moveTime - timeTracker[index])
															end
															Wait(1000)
															timeTracker[index] = timeTracker[index] + 1
														end

														RemoveEventHandler(eventHandler)

														if tableTracker[tostring(v.player)] == nil then
															DebugPrint("TABLE "..index..": PLAYER "..v.player.." WAS PUT OUT DUE TO LEAVING")
															v.player_in = false
															TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
															break
														else

															--###########################
															--SPLIT-SPLIT PLAYER HAS ACTED
															--###########################

															if move == "hit" then --SPLITMODE, SPLIT HAND HIT

															--###########################
															--SPLIT-SPLIT PLAYER HAS HIT
															--###########################

																local card = takeCard(deck)
																TriggerClientEvent("BLACKJACK:GiveCard", -1, index, v.seat, #v.splitHand+1, card, false, true)
																PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_hit_second_card_player_0" .. 5-v.seat)
																table.insert(v.splitHand, card)
																Wait(1500)
																DebugPrint("TABLE "..index..": DEALT PLAYER "..v.player.." "..card)

																if handValue(v.splitHand) == 21 then --SPLITMODE, SPLIT HAND BLACKJACK NON-NAT AFTER HIT

																	--################################
																	--(HIT) SPLIT-SPLIT PLAYER HAS 21
																	--################################

																	DebugPrint("TABLE "..index..": PLAYER "..v.player.." HAS 21")
																	PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.splitHand))
																	break
																elseif handValue(v.splitHand) > 21 then --SPLITMODE, SPLIT HAND BUST AFTER HIT

																	--#################################
																	--(HIT) SPLIT-SPLIT PLAYER HAS BUST
																	--#################################

																	--TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, "bad", handValue(dealerHand), true)
																	--givePlayTokens(v.player, false)
																	DebugPrint("TABLE "..index..": PLAYER "..v.player.." WENT BUST")
																	PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_PLAYER_BUST")
																else

																	--#################################
																	--(HIT) SPLIT-SPLIT PLAYER STILL IN
																	--#################################

																	PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(v.splitHand))
																end
															elseif move == "stand" then
																--#################################
																--SPLIT-SPLIT PLAYER CHOSE STAND
																--#################################
																break
															end
														end
													end

													PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_dealer_focus_player_0".. 5-v.seat .."_idle_outro_split")
													Wait(1500)

													break

												elseif move == "stand" then

													--#################################
													--PLAYER CHOSE STAND
													--#################################

													break
												end
											end
										end

										if not v.splitHand then
											PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_dealer_focus_player_0".. 5-v.seat .."_idle_outro")
											Wait(1500)
										end
									end
								end
							end

							--  Remove offline players from table
							local j = 1

							while j <= #currentPlayers do
								local player = currentPlayers[j]

								if tableTracker[tostring(player.player)] == nil then
									DebugPrint("TABLE "..index..": PLAYER "..player.player.." WAS REMOVED FROM PLAYERS LIST FOR LEAVING")
									table.remove(currentPlayers, j)
								else
									j = j + 1
								end
							end

							if ArePlayersStillIn(currentPlayers) then
								PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_turn_card")
								Wait(1000)
								TriggerClientEvent("BLACKJACK:DealerTurnOverCard", -1, index)
								Wait(1000)
								PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(dealerHand))
							end

							--#################################
							--DEALER FOLLOW-ON DEAL (IF REQUIRED)
							--#################################

							if handValue(dealerHand) < 17 and ArePlayersStillIn(currentPlayers) then
								repeat
									local card = takeCard(deck)
									table.insert(dealerHand, card)

									TriggerClientEvent("BLACKJACK:GiveCard", -1, index, 0, #dealerHand, card, #dealerHand == 1)

									PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_deal_card_self_second_card")
									DebugPrint("TABLE "..index..": DEALT DEALER "..card)
									Wait(2000)
									PlayDealerSpeech(index, "MINIGAME_BJACK_DEALER_"..handValue(dealerHand))
								until handValue(dealerHand) >= 17
							end
						end

						if handValue(dealerHand) > 21 then
							PlayDealerSpeech(index, "MINIGAME_DEALER_BUSTS")
						end

						DebugPrint("TABLE "..index..": DEALER HAS "..handValue(dealerHand))


						--########################
						--END GAME PAYOUT LOOP
						--########################


						for i,v in pairs(currentPlayers) do  -- endgame payout loop
							if v.player_in then

								DebugPrint("TABLE "..index..": PLAYER "..v.player.." HAS "..handValue(v.hand))

								local splitMultiplier = 0
								local splitResult = 0
								local splitReaction = "impartial"
								local mainReaction = "impartial"
								local splitComboReaction = "impartial"

								--CALCULATING FOR MAIN HAND NATURAL BLACKJACK

								if handValue(v.hand) == 21 and #v.hand == 2 then -- MAIN HAND WIN NATURAL

									splitMultiplier = 2.5
									mainReaction = "good"

									if v.splitHand then --CHECK FOR SPLITS
										splitReaction, splitComboReaction, splitMultiplier = calculateSplit(index, v.player, v.splitHand, dealerHand, "natural")
										TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, splitComboReaction, handValue(dealerHand), true, splitReaction, mainReaction)
									else
										TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, mainReaction, handValue(dealerHand), false)
									end

									DebugPrint("TABLE "..index..": PLAYER "..v.player.." MAIN WON NATURAL")
									if splitMultiplier > 0 then giveChips(v.player, v.bet * splitMultiplier) end
									LogToDB(v.player, v.bet, v.bet * splitMultiplier, v.hand, v.splitHand, dealerHand)
									givePlayTokens(v.player, false or mainReaction == "good")

								--CALCULATING FOR MAIN HAND WIN OR DEALER BUST

								elseif handValue(v.hand) <= 21 and (handValue(v.hand) > handValue(dealerHand) or handValue(dealerHand) > 21) then -- MAIN HAND WIN

									splitMultiplier = 2
									mainReaction = "good"

									if v.splitHand then --CHECK FOR SPLITS
										splitReaction, splitComboReaction, splitMultiplier = calculateSplit(index, v.player, v.splitHand, dealerHand, "win")
										TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, splitComboReaction, handValue(dealerHand), true, splitReaction, mainReaction)
									else
										TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, mainReaction, handValue(dealerHand), false)
									end

									DebugPrint("TABLE "..index..": PLAYER "..v.player.." MAIN WON")
									if splitMultiplier > 0 then giveChips(v.player, v.bet * splitMultiplier) end
									LogToDB(v.player, v.bet, v.bet * splitMultiplier, v.hand, v.splitHand, dealerHand)
									givePlayTokens(v.player, false or mainReaction == "good")

								--CALCULATING FOR MAIN HAND PUSH

								elseif handValue(v.hand) <= 21 and handValue(v.hand) == handValue(dealerHand) then -- MAIN HAND PUSH

									splitMultiplier = 1
									mainReaction = "impartial"

									if v.splitHand then --CHECK FOR SPLITS
										splitReaction, splitComboReaction, splitMultiplier = calculateSplit(index, v.player, v.splitHand, dealerHand, "push")
										TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, splitComboReaction, handValue(dealerHand), true, splitReaction, mainReaction)
									else
										TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, mainReaction, handValue(dealerHand), false)
									end
									DebugPrint("TABLE "..index..": PLAYER "..v.player.." MAIN IS PUSH")
									if splitMultiplier > 0 then giveChips(v.player, v.bet * splitMultiplier) end
									LogToDB(v.player, v.bet, v.bet * splitMultiplier, v.hand, v.splitHand, dealerHand)
									givePlayTokens(v.player, false or mainReaction == "good")

								--CALCULATING FOR MAIN HAND LOSE OR BUST

								elseif handValue(v.hand) < handValue(dealerHand) and handValue(dealerHand) <= 21 or handValue(v.hand) > 21 then -- MAIN HAND LOSE/BUST

									splitMultiplier = 0
									mainReaction = "bad"

									if v.splitHand then --CHECK FOR SPLITS
										splitReaction, splitComboReaction, splitMultiplier = calculateSplit(index, v.player, v.splitHand, dealerHand, "lose")
										TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, splitComboReaction, handValue(dealerHand), true, splitReaction, mainReaction)
									else
										TriggerClientEvent("BLACKJACK:GameEndReaction", v.player, mainReaction, handValue(dealerHand), false)
									end

									DebugPrint("TABLE "..index..": PLAYER "..v.player.." MAIN LOST")
									if splitMultiplier > 0 then giveChips(v.player, v.bet * splitMultiplier) end
									LogToDB(v.player, v.bet, v.bet * splitMultiplier, v.hand, v.splitHand, dealerHand)
									givePlayTokens(v.player, false or mainReaction == "good")
								end

							end
						end

						if handValue(dealerHand) >= 17 then
							PlayDealerAnim(index, "anim_casino_b@amb@casino@games@shared@dealer@", "female_dealer_reaction_impartial_var0"..math.random(1,3))
						elseif handValue(dealerHand) > 21 then
							PlayDealerAnim(index, "anim_casino_b@amb@casino@games@shared@dealer@", "female_dealer_reaction_good_var0"..math.random(1,3))
						else
							PlayDealerAnim(index, "anim_casino_b@amb@casino@games@shared@dealer@", "female_dealer_reaction_bad_var0"..math.random(1,3))
						end

						Wait(2500)

						for i,v in pairs(currentPlayers) do
--							if v.player_in then 
								PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_retrieve_cards_player_0".. 5-v.seat)
								Wait(500)
								TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, v.seat)
								Wait(1500)
--							end

							v.bet = 0
							v.player_in = true
							v.hand = {}
							v.splitHand = nil
						end

						PlayDealerAnim(index, "anim_casino_b@amb@casino@games@blackjack@dealer", "female_retrieve_own_cards_and_remove")
						Wait(500)
						TriggerClientEvent("BLACKJACK:RetrieveCards", -1, index, 0)
						Wait(1500)

						timeTracker[index] = 0

						for i,v in pairs(currentPlayers) do
							TriggerClientEvent("BLACKJACK:RequestBets", v.player, index, timeTracker[index])
						end

					else
						for i,v in pairs(players[index]) do
							v.bet = 0
							v.player_in = true
							v.hand = {}
							v.splitHand = nil
						end

						timeTracker[index] = 0
					end
				end
			end
		end
	end)
end

Citizen.CreateThread(function() -- INIT
	for i,_ in pairs(tables) do
		StartTableThread(i)
		players[i] = {}
		timeTracker[i] = 0
	end
end)

function PlayerSatDown(i, seat)
	DebugPrint("PLAYERSATDOWN: PLAYER ".. source .. " SAT DOWN AT TABLE " .. i)

	-- player = source
	-- index = i
	-- chair = seat

	table.insert(players[i], {player = source, seat = seat, hand = {}, player_in = true, bet = 0})
	tableTracker[tostring(source)] = i

	-- PlayDealerSpeech(i, "MINIGAME_DEALER_GREET")

	TriggerClientEvent("BLACKJACK:RequestBets", source, i)

	DebugPrint("PLAYERSATDOWN: NUMBER OF PLAYERS AT TABLE ".. i .. " IS " .. #players[i])

	-- Citizen.CreateThread(function()
		-- local deck = getDeck()

		-- local card1 = takeCard(deck)
		-- TriggerClientEvent("BLACKJACK:GiveCard", player, index, card1)
		-- TriggerClientEvent("BLACKJACK:ANIM:DealCard", -1, index, chair)

		-- Wait(3000)

		-- local card2 = takeCard(deck)
		-- TriggerClientEvent("BLACKJACK:GiveCard", player, index, card2)
		-- TriggerClientEvent("BLACKJACK:ANIM:DealCard", -1, index, chair)
	-- end)

	-- local card1 = takeCard(deck)
	-- local card2 = takeCard(deck)

	-- TriggerEvent('chat', GetPlayerName(source), {0, 0, 0}, "has " .. handValue({card1, card2}) .. " ("..cardValue(card1)..", "..cardValue(card2)..")")
end

RegisterNetEvent("BLACKJACK:PlayerSatDown")
AddEventHandler('BLACKJACK:PlayerSatDown', PlayerSatDown)


function PlayerSatUp(i)
	DebugPrint("PLAYERSATUP: PLAYER " ..source.. " LEFT TABLE "..i)

	local num = FindPlayerIdx(players[i], source)

	if num ~= nil then
		DebugPrint("PLAYERSATUP: PLAYER "..source .. " SUCCESSFULLY REMOVED FROM TABLE "..i)

		table.remove(players[i], num)
		tableTracker[tostring(source)] = nil

		PlayDealerSpeech(i, "MINIGAME_DEALER_LEAVE_NEUTRAL_GAME")
	end
end

RegisterNetEvent("BLACKJACK:PlayerSatUp")
AddEventHandler('BLACKJACK:PlayerSatUp', PlayerSatUp)

function PlayerLeft()
	local playerTbl = tableTracker[tostring(source)]

	if playerTbl ~= nil then
		DebugPrint("PLAYERLEFT: PLAYER "..source .. " LEFT SERVER")

		local num = FindPlayerIdx(players[playerTbl], source)

		if num ~= nil then
			DebugPrint("PLAYERLEFT: PLAYER " ..source.. " REMOVED FROM TABLE FOR LEAVING SERVER")
			table.remove(players[playerTbl], num)
		end

		tableTracker[tostring(source)] = nil
	end
end

AddEventHandler("playerDropped", PlayerLeft)

function PlayerRemove(i)
	DebugPrint("PLAYERREMOVE: PLAYER: " .. source.. " LEFT TABLE "..i)

	local num = FindPlayerIdx(players[i], source)

	if num ~= nil then
		DebugPrint("PLAYERREMOVE: PLAYER: "..source .. " SUCCESSFULLY REMOVED FROM TABLE "..i)

		local playerInfo = players[i][num]

		if playerInfo.player_in then
			if playerInfo.bet > 0 then
				giveChips(source, playerInfo.bet) -- give money back as player was removed before losing or winning?
			end
		end

		table.remove(players[i], num)
		tableTracker[tostring(source)] = nil

		PlayDealerSpeech(i, "MINIGAME_DEALER_LEAVE_NEUTRAL_GAME")
	end
end

RegisterNetEvent("BLACKJACK:PlayerRemove")
AddEventHandler('BLACKJACK:PlayerRemove', PlayerRemove)
