Models.mp_f_freemode_01 = {}

registerModel('mp_f_freemode_01', 'Freemode', 'female')

Models.mp_f_freemode_01.Generic = {
	model = 'mp_f_freemode_01',
	modelHash = GetHashKey('mp_f_freemode_01'),
	gender = 'female',
	label = 'Freemode',
	enableBeard = false
}

-- In the tables you will find below, there's two or three numbers stored
--   - number 1: drawableId
--   - number 2: textureId
--   - number 3: paletteId (only on components)

Models.mp_f_freemode_01.Defaults = {
	Tops = {
		arms = {4, 0, 2}, accessory = {0, 0, 2},
		undershirt = {3, 0, 2}, torso = {5, 0, 2}
	},

	Pants = {legs = {15, 3, 2}},
	Shoes = {shoes = {35, 0, 2}}
}

Models.mp_f_freemode_01.Hairs = {1, 2, 3, 4, 5, 7, 9, 10, 11, 14, 15, 16, 17, 19, 20, 21, 22, 28, 36, 37, 39, 40, 42, 43, 47, 48, 52, 53, 54, 55, 58, 59, 60, 68}

Models.mp_f_freemode_01.Hats = {
	{label = 'Ear Protection Pads', hat = {0, 0}}
}

Models.mp_f_freemode_01.Glasses = {
	{label = 'Aviator Glasses', glasses = {0, 0}}
}

Models.mp_f_freemode_01.Ears = {
	{label = 'Diamond', ears = {0, 0}}
}

Models.mp_f_freemode_01.Tops = {
	{
		label = 'Basic beige t-shirt',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {0, 3, 2}, torso = {0, 0, 2}
	},
	{
		label = 'Red t-shirt',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {0, 0, 2}, torso = {0, 0, 2}
	}
}

Models.mp_f_freemode_01.Pants = {
	{label = 'Black regular jeans', legs = {0, 1, 2}},
	{label = 'Blue jeans shorts', legs = {25, 1, 2}}
}

Models.mp_f_freemode_01.Shoes = {
	{label = 'White sneakers', shoes = {1, 0, 2}}
}

Models.mp_f_freemode_01.Watches = {
	{label = 'Test Watch', watch = {0, 2}}
}
