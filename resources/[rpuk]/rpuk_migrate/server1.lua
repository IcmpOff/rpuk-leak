-- Migration used to migrated from vehicle-based markers to person-based markers.
-- RUN SQL first (ensure users has mdt_markers with a default markers object)
RegisterCommand('migrate_markers', function(a,b,c)
	local markersByCharacterId, asyncTask, timeStart, currentlyMigrating = {}, {}, os.clock(), 1

	MySQL.Async.fetchAll('SELECT rpuk_charid, mdt_markers FROM users', {}, function(result)
		for _,v in pairs(result) do

			local markers = json.decode(v.mdt_markers)

			MySQL.Async.fetchAll('SELECT mdt_notes, plate FROM owned_vehicles WHERE rpuk_charid = @owner', {
				['@owner'] = v.rpuk_charid
			}, function(result2)
				if result2 then
					for _, car in pairs(result2) do
						
						for k2,v2 in pairs(json.decode(car.mdt_notes)) do
							if v2 == 1 then
								if k2 == 'Occupants Dangerous' then
									markers.Violent = 1
								else
									markers[k2] = 1
								end
							end
						end
					end
				end
				markersByCharacterId[v.rpuk_charid] = markers
			
				MySQL.Async.execute('UPDATE users SET mdt_markers = @markers WHERE rpuk_charid = @rpuk_charid', {
					['@markers'] = json.encode(markers),
					['@rpuk_charid'] = v.rpuk_charid
				}, function(rowsChanged)
					print(('[rpuk_migrate] [^2INFO^7] migrated markers %s for character %s [%s/%s]'):format(json.encode(markers), v.rpuk_charid, currentlyMigrating, ESX.Table.SizeOf(result)))
					currentlyMigrating = currentlyMigrating + 1
				end)
			end)

			
			
			-- for characterId,newMarkers in pairs(markersByCharacterId) do
			-- 	table.insert(asyncTask, function(cb)
			-- 		MySQL.Async.execute('UPDATE users SET mdt_markers = @markers WHERE rpuk_charid = @rpuk_charid', {
			-- 			['@markers'] = json.encode(newMarkers),
			-- 			['@rpuk_charid'] = characterId
			-- 		}, function(rowsChanged)
			-- 			print(('[rpuk_migrate] [^2INFO^7] migrated markers %s for character %s [%s/%s]'):format(newMarkers, characterId, currentlyMigrating, ESX.Table.SizeOf(markersByCharacterId)))
			-- 			currentlyMigrating = currentlyMigrating + 1
			-- 			cb()
			-- 		end)
			-- 	end)
			-- end
		end



		-- Async.parallelLimit(asyncTask, 8, function(results)
		-- 	print(('[rpuk_migrate] [^2INFO^7] task complete! migrating %s entries took %.0f seconds'):format(ESX.Table.SizeOf(markersByCharacterId), os.clock() - timeStart))
		-- end)
	end)
	
end, true)

