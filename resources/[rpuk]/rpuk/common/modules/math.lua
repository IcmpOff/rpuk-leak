ESX.Math = {}

math.round = function(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

ESX.Math.Round = math.round
ESX.Round = math.round

-- credit http://richard.warburton.it
ESX.Math.GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. _U('locale_digit_grouping_symbol')):reverse())..right
end

ESX.Math.FormatCoordsTable = function(coords, _type)
	if _type == 'table' then
		local _coords = {x = math.round(coords.x, 1), y = math.round(coords.y, 1), z = math.round(coords.z, 1)}
		if type(coords) == 'table' then _coords.heading = math.round(coords.heading or 0.0, 1) end
		return _coords
	elseif _type == 'vector3' then
		return vector3(math.round(coords.x, 1), math.round(coords.y, 1), math.round(coords.z, 1))
	end
end

ESX.Math.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end