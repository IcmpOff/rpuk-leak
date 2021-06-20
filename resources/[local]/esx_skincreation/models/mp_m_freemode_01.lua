Models.mp_m_freemode_01 = {}

registerModel('mp_m_freemode_01', 'Freemode', 'male')

Models.mp_m_freemode_01.Generic = {
	model = 'mp_m_freemode_01',
	modelHash = GetHashKey('mp_m_freemode_01'),
	gender = 'male',
	label = 'Freemode',
	enableBeard = true
}

-- In the tables you will find below, there's two or three numbers stored
--   - number 1: drawableId
--   - number 2: textureId
--   - number 3: paletteId (only on components)

Models.mp_m_freemode_01.Defaults = {
	Tops = {
		arms = {15, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {15, 0, 2}
	},

	Pants = {legs = {61, 4, 2}},
	Shoes = {shoes = {34, 0, 2}}
}

Models.mp_m_freemode_01.Hairs = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 18, 19, 20, 21, 22, 30, 31, 32, 33, 34, 35, 37, 38, 39, 40, 41, 42, 43, 45, 46, 47, 48, 49, 51, 54, 57, 66, 67, 68, 69, 72, 73}

Models.mp_m_freemode_01.Hats = {
	{label = 'Black beanie', hat = {2, 0}},
	{label = 'White beanie', hat = {2, 6}},
	{label = 'Fisherman\'s hat', hat = {3, 2}},
	{label = 'LS Cap black', hat = {4, 0}},
	{label = 'LS Cap white', hat = {4, 1}},
	{label = 'Reggae hat', hat = {5, 0}},
	{label = 'White beret', hat = {7, 0}},
	{label = 'Gray beret', hat = {7, 1}},
	{label = 'Black beret', hat = {7, 2}},
	{label = 'Brown beret', hat = {7, 5}},
	{label = 'Cap f°', hat = {10, 5}},
	{label = 'Cap f° (backflip)', hat = {9, 5}},
	{label = 'Stank cap', hat = {10, 7}},
	{label = 'Stank cap (backflip)', hat = {9, 7}},
	{label = 'Gray hat', hat = {12, 0}},
	{label = 'White hat', hat = {12, 1}},
	{label = 'Cowboy hat', hat = {13, 2}},
	{label = 'White bandana', hat = {14, 0}},
	{label = 'Black bandana', hat = {14, 1}},
	{label = 'Black Beats by Dre', hat = {15, 1}},
	{label = 'Red Beats by Dre', hat = {15, 2}},
	{label = 'Explorers\' hat', hat = {20, 5}},
	{label = 'Holiday hat', hat = {21, 0}},
	{label = 'Mafia hat', hat = {25, 1}},
	{label = 'Bowler hat', hat = {26, 0}},
	{label = 'Top hat', hat = {27, 0}},
	{label = 'Wool cap', hat = {34, 0}},
	{label = 'Red broker cap', hat = {55, 0}},
	{label = 'Black broker cap', hat = {55, 1}},
	{label = 'Trickster cap', hat = {55, 2}},
	{label = 'Vapid cap', hat = {76, 19}},
	{label = 'Sand Castle cap', hat = {96, 2}}
}

Models.mp_m_freemode_01.Glasses = {
	{label = 'Large black (sunshades)', glasses = {3, 0}},
	{label = 'Large black', glasses = {3, 9}},
	{label = 'Semie-open (sunshades)', glasses = {4, 4}},
	{label = 'Semie-open black', glasses = {4, 9}},
	{label = 'Aviator (sunshades)', glasses = {5, 0}},
	{label = 'Aviator', glasses = {5, 8}},
	{label = 'Wayfarer (sunshades)', glasses = {7, 0}},
	{label = 'Zoo (sunshades)', glasses = {8, 2}},
	{label = 'Sport (sunshades)', glasses = {9, 0}},
	{label = 'Mountain (sunshades)', glasses = {15, 6}},
	{label = 'Nerd', glasses = {17, 9}},
	{label = 'Ski (sunshades)', glasses = {25, 0}}
}

Models.mp_m_freemode_01.Ears = {
	{label = 'Loop (left)', ears = {3, 0}},
	{label = 'Loop (right)', ears = {4, 0}},
	{label = 'Loop', ears = {5, 0}},
	{label = 'Diamond (right)', ears = {9, 2}},
	{label = 'Diamond (left)', ears = {10, 2}},
	{label = 'Diamond', ears = {11, 2}},
	{label = 'Square (left)', ears = {18, 3}},
	{label = 'Square (right)', ears = {19, 3}},
	{label = 'Square', ears = {20, 3}},
	{label = 'Pike (left)', ears = {27, 0}},
	{label = 'Pike (right)', ears = {28, 0}},
	{label = 'Pike', ears = {29, 0}},
	{label = 'True Diamond (left)', ears = {30, 0}},
	{label = 'True Diamond (right)', ears = {31, 0}},
	{label = 'True Diamond', ears = {32, 0}}
}

Models.mp_m_freemode_01.Tops = {
	{
		label = 'Basic beige T-shirt',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {0, 0, 2}, torso = {0, 0, 2}
	},
	{
		label = 'Basic pink t-shirt',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {0, 0, 2}, torso = {0, 7, 2}
	},
	{
		label = 'Black 3-piece suit',
		arms = {6, 0, 2}, accessory = {0, 0, 2},
		undershirt = {4, 0, 2}, torso = {4, 0, 2}
	},
	{
		label = 'White 3-piece suit',
		arms = {6, 0, 2}, accessory = {0, 0, 2},
		undershirt = {26, 0, 2}, torso = {4, 0, 2}
	},
	{
		label = 'White tank top',
		arms = {5, 0, 2}, accessory = {0, 0, 2},
		undershirt = {5, 0, 2}, torso = {5, 0, 2}
	},
	{
		label = 'Brown leather jacket',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {2, 4, 2}, torso = {6, 11, 2}
	},
	{
		label = 'Black leather jacket',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {2, 4, 2}, torso = {6, 0, 2}
	},
	{
		label = 'Red leather jacket',
		arms = {6, 0, 2}, accessory = {0, 0, 2},
		undershirt = {26, 0, 2}, torso = {4, 0, 2}
	},
	{
		label = 'Suit and white shirt',
		arms = {6, 0, 2}, accessory = {0, 0, 2},
		undershirt = {26, 0, 2}, torso = {4, 0, 2}
	},
	{
		label = 'Bow tie costume',
		arms = {4, 0, 2}, accessory = {11, 2, 2},
		undershirt = {10, 0, 2}, torso = {10, 0, 2}
	},
	{
		label = 'Green check shirt',
		arms = {12, 0, 2}, accessory = {0, 0, 2},
		undershirt = {12, 10, 2}, torso = {12, 10, 2}
	},
	{
		label = 'Shirt with rolled up sleeves',
		arms = {11, 0, 2}, accessory = {0, 0, 2},
		undershirt = {13, 0, 2}, torso = {13, 0, 2}
	},
	{
		label = 'Taupe t-shirt',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {16, 0, 2}
	},
	{
		label = 'Blue t-shirt',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {16, 1, 2}
	},
	{
		label = 'Rose t-shirt',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {16, 2, 2}
	},
	{
		label = 'Navy short sleeve shirt',
		arms = {11, 0, 2}, accessory = {0, 0, 2},
		undershirt = {27, 0, 2}, torso = {26, 0, 2}
	},
	{
		label = 'Shirt with suspenders',
		arms = {11, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {42, 0, 2}
	},
	{
		label = 'Black sweater',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {50, 0, 2}
	},
	{
		label = 'White sweater',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {50, 3, 2}
	},
	{
		label = 'Khaki sweater',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {50, 4, 2}
	},
	{
		label = 'Hoodie',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {57, 0, 2}
	},
	{
		label = 'Long parka and 3-piece suit',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {3, 1, 2}, torso = {72, 1, 2}
	},
	{
		label = 'Wolves red bomber jacket',
		arms = {15, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {79, 0, 2}
	},
	{
		label = 'Bomber Los Santos',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {87, 11, 2}
	},
	{
		label = 'Bomber Double P',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {87, 0, 2}
	},
	{
		label = 'Bomber Magnetics',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {87, 1, 2}
	},
	{
		label = 'Bomber Hinterland',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {87, 2, 2}
	},
	{
		label = 'Bomber Broker',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {87, 4, 2}
	},
	{
		label = 'Bomber Trickster',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {87, 8, 2}
	},
	{
		label = 'Basic black sweater',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {89, 0, 2}
	},
	{
		label = 'Jean shirt',
		arms = {11, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {95, 0, 2}
	},
	{
		label = 'Floral shirt',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {105, 0, 2}
	},
	{
		label = 'Sleeveless cardigan shirt',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {73, 2, 2}, torso = {109, 0, 2}
	},
	{
		label = 'Liberty Polo',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {131, 0, 2}
	},
	{
		label = 'Black Liberty hoodie',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {134, 0, 2}
	},
	{
		label = 'Red Liberty hoodie',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {134, 1, 2}
	},
	{
		label = 'Sleeveless hoodie #1',
		arms = {2, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {202, 0, 2}
	},
	{
		label = 'Sleeveless hoodie #2',
		arms = {2, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {205, 0, 2}
	},
	{
		label = 'Bigness hoodie',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {203, 10, 2}
	},
	{
		label = 'Güffy hoodie',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {203, 16, 2}
	},
	{
		label = 'Manor hoodie',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {203, 25, 2}
	},
	{
		label = 'T-shirt with pocket',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {226, 0, 2}
	},
	{
		label = 'Joker jacket',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {257, 0, 2}
	},
	{
		label = 'Güffy jacket',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {257, 9, 2}
	},
	{
		label = 'Santo Capra jacket',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {257, 17, 2}
	},
	{
		label = 'Perseus sweater',
		arms = {1, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {259, 9, 2}
	},
	{
		label = 'Wigwam jersey',
		arms = {0, 0, 2}, accessory = {0, 0, 2},
		undershirt = {15, 0, 2}, torso = {282, 6, 2}
	}
}

Models.mp_m_freemode_01.Pants = {
	{label = 'Regular jeans', legs = {0, 0, 2}},
	{label = 'Regular jeans faded', legs = {0, 2, 2}},
	{label = 'Regular jeans hanging', legs = {1, 12, 2}},
	{label = 'Sports shorts', legs = {2, 11, 2}},
	{label = 'White jogging pants', legs = {3, 0, 2}},
	{label = 'Black skinny jeans', legs = {4, 0, 2}},
	{label = 'Blue skinny jeans', legs = {4, 1, 2}},
	{label = 'Blue skinny jeans faded', legs = {4, 4, 2}},
	{label = 'White jogging pants', legs = {5, 0, 2}},
	{label = 'Black jogging pants', legs = {5, 2, 2}},
	{label = 'Wide black pants', legs = {7, 0, 2}},
	{label = 'Wide brown pants', legs = {7, 1, 2}},
	{label = 'Khaki pocket pants', legs = {9, 0, 2}},
	{label = 'Beige pocket pants', legs = {9, 1, 2}},
	{label = 'Black regular suit pants', legs = {10, 0, 2}},
	{label = 'Blue regular suit pants', legs = {10, 2, 2}},
	{label = 'Black shorts', legs = {12, 0, 2}},
	{label = 'Gray shorts', legs = {12, 5, 2}},
	{label = 'Beige shorts', legs = {12, 7, 2}},
	{label = 'Gray running shorts', legs = {14, 0, 2}},
	{label = 'Black running shorts', legs = {14, 1, 2}},
	{label = 'Burgundy running shorts', legs = {14, 3, 2}},
	{label = 'Wide shorts', legs = {15, 0, 2}},
	{label = 'White pants', legs = {20, 0, 2}},
	{label = 'Black skinny pants', legs = {24, 0, 2}},
	{label = 'Gray skinny pants', legs = {24, 1, 2}},
	{label = 'White skinny pants', legs = {24, 5, 2}},
	{label = 'Black skinny jeans', legs = {26, 0, 2}},
	{label = 'Light blue skinny jeans', legs = {26, 4, 2}},
	{label = 'Red skinny jeans', legs = {26, 5, 2}},
	{label = 'Blue skinny jeans', legs = {26, 6, 2}},
	{label = 'Black skinny pants', legs = {28, 0, 2}},
	{label = 'Gray skinny pants', legs = {28, 3, 2}},
	{label = 'Light gray skinny pants', legs = {28, 8, 2}},
	{label = 'Beige skinny pants', legs = {28, 14, 2}},
	{label = 'Black jogging shorts', legs = {42, 0, 2}},
	{label = 'Grey jogging shorts', legs = {42, 1, 2}},
	{label = 'Long clear pants', legs = {48, 0, 2}},
	{label = 'Long dark pants', legs = {48, 1, 2}},
	{label = 'Clear short pants', legs = {49, 0, 2}},
	{label = 'Dark short pants', legs = {49, 1, 2}},
	{label = 'Le Chien swim shorts', legs = {54, 1, 2}},
	{label = 'Adidas jogging pants', legs = {55, 0, 2}},
	{label = 'Pants', legs = {60, 2, 2}},
	{label = 'Pants', legs = {60, 9, 2}},
	{label = 'Leather pants', legs = {71, 0, 2}},
	{label = 'Patterned jeans', legs = {75, 2, 2}},
	{label = 'Jeans with holes', legs = {76, 2, 2}},
	{label = 'Brown skinny jogging pants', legs = {78, 0, 2}},
	{label = 'Black skinny jogging pants', legs = {78, 2, 2}},
	{label = 'White skinny jogging pants', legs = {78, 4, 2}},
	{label = 'Navy blue skinny jeans', legs = {82, 0, 2}},
	{label = 'Blue skinny jeans', legs = {82, 2, 2}},
	{label = 'Green skinny jeans', legs = {82, 3, 2}},
	{label = 'Camo pants', legs = {86, 9, 2}},
	{label = 'Camo shorts', legs = {88, 9, 2}},
	{label = 'Banks camo pants', legs = {100, 9, 2}}
}

Models.mp_m_freemode_01.Shoes = {
	{label = 'EE sneakers', shoes = {0, 10, 2}},
	{label = 'Black etny sneakers', shoes = {1, 0, 2}},
	{label = 'White etny sneakers', shoes = {1, 1, 2}},
	{label = 'Red etny sneakers', shoes = {1, 3, 2}},
	{label = 'Gray sailor shoes', shoes = {3, 0, 2}},
	{label = 'Brown sailor shoes', shoes = {3, 6, 2}},
	{label = 'Blue sailor shoes', shoes = {3, 14, 2}},
	{label = 'Black Converse', shoes = {48, 0, 2}},
	{label = 'Pink Converse', shoes = {48, 1, 2}},
	{label = 'Yellow Converse', shoes = {49, 0, 2}},
	{label = 'Gray Converse', shoes = {49, 1, 2}},
	{label = 'White flip flops', shoes = {5, 0, 2}},
	{label = 'Slides and socks', shoes = {6, 0, 2}},
	{label = 'White sneakers', shoes = {7, 0, 2}},
	{label = 'Red sneakers', shoes = {7, 9, 2}},
	{label = 'Yellow sneakers', shoes = {7, 13, 2}},
	{label = 'Red sneakers', shoes = {9, 3, 2}},
	{label = 'Yellow / green sneakers', shoes = {9, 6, 2}},
	{label = 'Blue / red sneakers', shoes = {9, 7, 2}},
	{label = 'Black dress shoes', shoes = {10, 0, 2}},
	{label = 'Classic Timberland', shoes = {12, 0, 2}},
	{label = 'Blue Timberland', shoes = {12, 2, 2}},
	{label = 'Pink Timberland', shoes = {12, 13, 2}},
	{label = 'Black dress shoes', shoes = {15, 0, 2}},
	{label = 'Brown dress shoes', shoes = {15, 1, 2}},
	{label = 'Black flip flops', shoes = {16, 0, 2}},
	{label = 'Brown dress shoes', shoes = {20, 0, 2}},
	{label = 'Black rangers', shoes = {24, 0, 2}},
	{label = 'Damaged rangers', shoes = {27, 0, 2}},
	{label = 'Fashion with white peaks', shoes = {28, 0, 2}},
	{label = 'Black spiked fashion', shoes = {28, 1, 2}},
	{label = 'Fashion with red peaks', shoes = {28, 3, 2}},
	{label = 'Full red peaks fashion', shoes = {28, 2, 2}},
	{label = 'White sneakers', shoes = {31, 2, 2}},
	{label = 'Cheetah sneakers', shoes = {31, 4, 2}},
	{label = 'Brown pumps', shoes = {36, 0, 2}},
	{label = 'Black pumps', shoes = {36, 3, 2}},
	{label = 'White sneakers without lace', shoes = {42, 0, 2}},
	{label = 'Black sneakers without lace', shoes = {42, 1, 2}},
	{label = 'Three sneakers without lace', shoes = {42, 7, 2}},
	{label = 'Beige sneakers', shoes = {57, 0, 2}},
	{label = 'Brown sneakers', shoes = {57, 3, 2}},
	{label = 'Red sneakers', shoes = {57, 8, 2}},
	{label = 'White sneakers', shoes = {57, 9, 2}},
	{label = 'Black sneakers', shoes = {57, 10, 2}},
	{label = 'Pink sneakers', shoes = {57, 11, 2}},
	{label = 'White / pink high top sneakers', shoes = {75, 4, 2}},
	{label = 'Green high top sneakers', shoes = {75, 7, 2}},
	{label = 'Orange high top sneakers', shoes = {75, 8, 2}},
	{label = 'White neon sneakers', shoes = {77, 0, 2}}
}

Models.mp_m_freemode_01.Watches = {
	{label = 'Classic', watch = {0, 0}},
	{label = 'Connected', watch = {2, 0}},
	{label = 'Sport (black)', watch = {3, 0}},
	{label = 'Sport (white)', watch = {3, 2}},
	{label = 'Gold plated', watch = {4, 0}},
	{label = 'Golden', watch = {8, 0}},
	{label = 'Metallic', watch = {10, 0}}
}
