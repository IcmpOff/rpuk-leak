Clothing = {}

Clothing.ClothingList = {
	lost = {
		male = {
			["lost_male_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["lost_male_vest_00"] = { -- must be unique
				["type"] = "component", -- or prop
				["label"] = "Lost MC Jacket",
				["order"] = "1",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[7] = {0, 0, 2},
				[8] = {24, 0, 2},
				[11] = {246, "grade", 2},
			},
			["lost_male_vest_01"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - Black",
				["order"] = "2",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {138, 1, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_vest_02"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - White",
				["order"] = "3",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {138, 0, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_vest_03"] = {
				["type"] = "component",
				["label"] = "Prospect Vest - Black",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {138, 1, 2},
				[11] = {179, 0, 2},
			},
			["lost_male_vest_04"] = {
				["type"] = "component",
				["label"] = "Prospect Vest - White",
				["order"] = "5",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {138, 0, 2},
				[11] = {179, 0, 2},
			},
			["lost_male_vest_05"] = { -- must be unique
				["type"] = "component", -- or prop
				["label"] = "Prospect Jacket",
				["order"] = "6",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[7] = {0, 0, 2},
				[8] = {24, 0, 2},
				[11] = {64, 0, 1},
			},
			["lost_male_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "7",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["lost_male_hat_00"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 1",
				["order"] = "8",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {39, 0, 2},
			},
			["lost_male_hat_01"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 2",
				["order"] = "9",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {69, 0, 2},
			},
			["lost_male_hat_02"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 3",
				["order"] = "10",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {84, 0, 2},
			},
			["lost_male_hat_03"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 4",
				["order"] = "11",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {85, 0, 2},
			},
			["lost_male_hat_04"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 5",
				["order"] = "12",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {86, 0, 2},
			},
			["lost_male_hat_05"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 6",
				["order"] = "13",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {87, 0, 2},
			},
			["lost_male_hat_06"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 7",
				["order"] = "14",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {88, 0, 2},
			},
			["lost_male_hat_07"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 8",
				["order"] = "15",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {89, 0, 2},
			},
			["lost_male_header_02"] = {
				["type"] = "component",
				["label"] = "--------------|Clothing|--------------",
				["order"] = "16",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["lost_male_top_00"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 1",
				["order"] = "17",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 0, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_01"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 2",
				["order"] = "18",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 1, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_02"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 3",
				["order"] = "19",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 2, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_03"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 4",
				["order"] = "20",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 3, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_04"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 5",
				["order"] = "21",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 4, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_05"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 6",
				["order"] = "22",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 5, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_06"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 7",
				["order"] = "23",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 6, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_07"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 8",
				["order"] = "24",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 7, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_08"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 9",
				["order"] = "25",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 8, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_09"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 10",
				["order"] = "26",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 9, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_10"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 11",
				["order"] = "27",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 10, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_11"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 12",
				["order"] = "28",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 11, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_12"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 13",
				["order"] = "29",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 12, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_13"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 14",
				["order"] = "30",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 13, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_14"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 15",
				["order"] = "31",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 14, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_15"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 16",
				["order"] = "32",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 15, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_16"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 17",
				["order"] = "33",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 16, 2},
				[11] = {245, "grade", 2},
			},
			["lost_male_top_17"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 18",
				["order"] = "34",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[7] = {0, 0, 2},
				[8] = {81, 17, 2},
				[11] = {245, "grade", 2},
			},
		},
		female = {
			["lost_female_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["lost_female_uniform_00"] = {
				["type"] = "component",
				["label"] = "Lost MC Jacket",
				["order"] = "1",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 0, 2},
				[11] = {8, 15, 2},
			},
			["lost_female_uniform_01"] = {
				["type"] = "component",
				["label"] = "Prospect Jacket",
				["order"] = "2",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 0, 2},
				[11] = {8, 2, 2},
			},
			["lost_female_uniform_02"] = {
				["type"] = "component",
				["label"] = "Prospect Vest",
				["order"] = "3",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 0, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["lost_female_helm_00"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 1",
				["order"] = "5",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {69, 0, 2},
			},
			["lost_female_helm_01"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 2",
				["order"] = "6",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {88, 0, 2},
			},
			["lost_female_hat_02"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 3",
				["order"] = "7",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {83, 0, 2},
			},
			["lost_female_hat_03"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 4",
				["order"] = "8",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {84, 0, 2},
			},
			["lost_female_hat_04"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 5",
				["order"] = "9",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {85, 0, 2},
			},
			["lost_female_hat_05"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 6",
				["order"] = "10",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {86, 0, 2},
			},
			["lost_female_hat_06"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 7",
				["order"] = "11",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {87, 0, 2},
			},
			["lost_female_hat_07"] = {
				["type"] = "prop",
				["label"] = "Lost MC Helmet - 8",
				["order"] = "12",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {88, 0, 2},
			},
			["lost_female_header_02"] = {
				["type"] = "component",
				["label"] = "--------------|Clothing|--------------",
				["order"] = "13",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["lost_female_top_00"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 1",
				["order"] = "14",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 0, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_01"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 2",
				["order"] = "15",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 1, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_02"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 3",
				["order"] = "16",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 2, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_03"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 4",
				["order"] = "17",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 3, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_04"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 5",
				["order"] = "18",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 4, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_05"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 6",
				["order"] = "19",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 5, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_06"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 7",
				["order"] = "20",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 6, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_07"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 8",
				["order"] = "21",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 7, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_08"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 9",
				["order"] = "22",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 8, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_09"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 10",
				["order"] = "23",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 9, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_10"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 11",
				["order"] = "24",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 10, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_11"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 12",
				["order"] = "25",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 11, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_12"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 13",
				["order"] = "26",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 12, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_13"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 14",
				["order"] = "27",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 13, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_14"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 15",
				["order"] = "28",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 14, 2},
				[11] = {181, 0, 2},
			},
			["lost_female_top_15"] = {
				["type"] = "component",
				["label"] = "Lost MC Vest - 16",
				["order"] = "29",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[7] = {0, 0, 2},
				[8] = {0, 15, 2},
				[11] = {181, 0, 2},
			},
		},
	},
	ambulance = {
		male = {
			["nhs_male_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_male_uniform_00"] = {
				["type"] = "component",
				["label"] = "Hospital Doctor Uniform (B)",
				["order"] = "1",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {10, 0, 2},
				[6] = {10, 0, 2},
				[8] = {32, 2, 2},
				[11] = {115, 0, 2},
			},
			["nhs_male_uniform_01"] = {
				["type"] = "component",
				["label"] = "Hospital Doctor Uniform (P)",
				["order"] = "2",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {23, 0, 2},
				[6] = {10, 0, 2},
				[8] = {32, 4, 2},
				[11] = {115, 0, 2},
			},
			["nhs_male_uniform_03"] = {
				["type"] = "component",
				["label"] = "HART Uniform",
				["order"] = "3",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1
				},
				[3] = {6, 0, 2},
				[4] = {46, 0, 2},
				[6] = {54, 0, 2},
				[8] = {15, 0, 2},
				[9] = {22, 1, 2},
				[11] = {248, 3, 2},
			},
			["nhs_male_uniform_04"] = {
				["type"] = "component",
				["label"] = "HEMS Uniform",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 0
				},
				[3] = {1, 0, 2},
				[4] = {113, 0, 2},
				[8] = {2, 2, 2},
				[9] = {0, 0, 2},
				[11] = {244, 25, 2},
			},
			["nhs_male_uniform_05"] = {
				["type"] = "component",
				["label"] = "Patrol Uniform",
				["order"] = "5",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 0
				},
				[3] = {11, 0, 2},
				[4] = {9, 3, 2},
				[6] = {54, 0, 2},
				[8] = {15, 0, 2},
				[11] = {278, "grade", 2},
			},
			["nhs_male_uniform_06"] = {
				["type"] = "component",
				["label"] = "Bike Patrol Uniform",
				["order"] = "6",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1
				},
				[3] = {1, 0, 2},
				[4] = {31, 0, 2},
				[6] = {24, 0, 2},
				[7] = {126, 0, 2},
				[8] = {74, 3, 2},
				[11] = {248, 2, 2},
			},
			["nhs_male_uniform_07"] = {
				["type"] = "component",
				["label"] = "Formal Uniform",
				["order"] = "7",
				["access"] = {
					jobGrade = 0,
					flagName = "special",
					flagLevel = 4
				},
				[3] = {11, 0, 2},
				[4] = {10, 0, 2},
				[6] = {10, 0, 2},
				[8] = {15, 0, 2},
				[11] = {278, 8, 2},
			},
			["nhs_male_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "8",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_male_hat_00"] = {
				["type"] = "prop",
				["label"] = "HART Motorcycle Helmet",
				["order"] = "9",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {72, 8, 2},
			},
			["nhs_male_hat_01"] = {
				["type"] = "prop",
				["label"] = "HART Helmet",
				["order"] = "10",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {40, 0, 2},
			},
			["nhs_male_hat_02"] = {
				["type"] = "prop",
				["label"] = "HART Command Helmet",
				["order"] = "11",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 2,
					useInVehicle = true
				},
				[0] = {40, 2, 2},
			},
			["nhs_male_hat_03"] = {
				["type"] = "prop",
				["label"] = "HEMS Headset",
				["order"] = "12",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 0
				},
				[0] = {19, 0, 2},
			},
			["nhs_male_hat_04"] = {
				["type"] = "prop",
				["label"] = "Motorcycle Helmet",
				["order"] = "13",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {72, 8, 2},
			},
			["nhs_male_header_02"] = {
				["type"] = "component",
				["label"] = "--------------|Clothing|--------------",
				["order"] = "14",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_male_top_00"] = {
				["type"] = "component",
				["label"] = "Patrol Shirt",
				["order"] = "15",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {11, 0, 2},
				[8] = {15, 0, 2},
				[11] = {278, "grade", 2},
			},
			["nhs_male_top_01"] = {
				["type"] = "component",
				["label"] = "Patrol HV Jacket",
				["order"] = "16",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[3] = {1, 0, 2},
				[8] = {15, 0, 2},
				[11] = {248, 2, 2},
			},
			["nhs_male_lowers_00"] = {
				["type"] = "component",
				["label"] = "Patrol Trousers",
				["order"] = "17",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 0
				},
				[4] = {9, 3, 2},
			},
			["nhs_male_shoes_00"] = {
				["type"] = "component",
				["label"] = "Patrol Boots",
				["order"] = "18",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[6] = {54, 0, 2},
			},
			["nhs_male_header_03"] = {
				["type"] = "component",
				["label"] = "--------------|Accessories|--------------",
				["order"] = "19",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_male_vest_00"] = {
				["type"] = "component",
				["label"] = "Paramedic Vest",
				["order"] = "20",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[9] = {22, 3, 2},
			},
			["nhs_male_vest_01"] = {
				["type"] = "component",
				["label"] = "Incident Command Vest",
				["order"] = "21",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 3,
					useInVehicle = true
				},
				[9] = {22, 0, 2},
			},
			["nhs_male_vest_02"] = {
				["type"] = "component",
				["label"] = "HART Vest",
				["order"] = "22",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1
				},
				[9] = {22, 1, 2},
			},
			["nhs_male_vest_03"] = {
				["type"] = "component",
				["label"] = "Training Vest",
				["order"] = "23",
				["access"] = {
					jobGrade = 0,
					flagName = "training",
					flagLevel = 1,
					useInVehicle = true
				},
				[9] = {22, 4, 2},
			},
			["nhs_male_header_04"] = {
				["type"] = "component",
				["label"] = "--------------|Masks|--------------",
				["order"] = "24",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_male_mask_00"] = {
				["type"] = "component",
				["label"] = "Service Stethoscope",
				["order"] = "25",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[7] = {126, 0, 2},
			},
		},
		female = {
			["nhs_female_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_female_uniform_00"] = {
				["type"] = "component",
				["label"] = "Hospital Doctor Uniform (B)",
				["order"] = "1",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[4] = {23, 0, 2},
				[6] = {29, 0, 2},
				[8] = {78, 1, 2},
				[11] = {107, 0, 2},
			},
			["nhs_female_uniform_01"] = {
				["type"] = "component",
				["label"] = "Hospital Doctor Uniform (R)",
				["order"] = "2",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[4] = {6, 0, 2},
				[6] = {29, 0, 2},
				[8] = {78, 3, 2},
				[11] = {107, 0, 2},
			},
			["nhs_female_uniform_03"] = {
				["type"] = "component",
				["label"] = "HART Uniform",
				["order"] = "3",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1
				},
				[3] = {3, 0, 2},
				[4] = {48, 0, 2},
				[6] = {54, 0, 2},
				[8] = {15, 0, 2},
				[9] = {22, 1, 2},
				[11] = {256, 3, 2},
			},
			["nhs_female_uniform_04"] = {
				["type"] = "component",
				["label"] = "HEMS Uniform",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 0
				},
				[3] = {1, 0, 2},
				[4] = {120, 0, 2},
				[6] = {26, 0, 2},
				[8] = {57, 1, 2},
				[9] = {0, 0, 2},
				[11] = {252, 25, 2},
			},
			["nhs_female_uniform_05"] = {
				["type"] = "component",
				["label"] = "Patrol Uniform",
				["order"] = "5",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 0
				},
				[3] = {9, 0, 2},
				[4] = {3, 14, 2},
				[6] = {26, 0, 2},
				[8] = {2, 0, 2},
				[11] = {291, "grade", 2},
			},
			["nhs_female_uniform_06"] = {
				["type"] = "component",
				["label"] = "Bike Patrol Uniform",
				["order"] = "6",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 0
				},
				[3] = {3, 0, 2},
				[4] = {30, 0, 2},
				[6] = {24, 0, 2},
				[7] = {96, 0, 2},
				[8] = {76, 3, 2},
				[11] = {256, 2, 2},
			},
			["nhs_female_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "7",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_female_hat_00"] = {
				["type"] = "prop",
				["label"] = "Motorcycle Helmet",
				["order"] = "8",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 3
				},
				[0] = {71, 8, 2},
			},
			["nhs_female_hat_01"] = {
				["type"] = "prop",
				["label"] = "HART Helmet",
				["order"] = "9",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {39, 0, 2},
			},
			["nhs_female_hat_02"] = {
				["type"] = "prop",
				["label"] = "HART Command Helmet",
				["order"] = "10",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 2,
					useInVehicle = true
				},
				[0] = {39, 2, 2},
			},
			["nhs_female_hat_03"] = {
				["type"] = "prop",
				["label"] = "HEMS Headset",
				["order"] = "11",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[0] = {19, 0, 2},
			},
			["nhs_female_header_02"] = {
				["type"] = "component",
				["label"] = "--------------|Clothing|--------------",
				["order"] = "12",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_female_top_00"] = {
				["type"] = "component",
				["label"] = "Patrol HV Jacket",
				["order"] = "13",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[3] = {1, 0, 2},
				[8] = {15, 0, 2},
				[11] = {256, 2, 2},
			},
			["nhs_female_lowers_00"] = {
				["type"] = "component",
				["label"] = "Patrol Trousers",
				["order"] = "14",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[4] = {3, 14, 2},
			},
			["nhs_female_shoes_00"] = {
				["type"] = "component",
				["label"] = "Patrol Boots",
				["order"] = "15",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[6] = {26, 0, 2},
			},
			["nhs_female_header_03"] = {
				["type"] = "component",
				["label"] = "--------------|Accessories|--------------",
				["order"] = "16",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_female_vest_00"] = {
				["type"] = "component",
				["label"] = "Paramedic Vest",
				["order"] = "17",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[9] = {22, 3, 2},
			},
			["nhs_female_vest_01"] = {
				["type"] = "component",
				["label"] = "Incident Command Vest",
				["order"] = "18",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 3,
					useInVehicle = true
				},
				[9] = {22, 0, 2},
			},
			["nhs_female_vest_02"] = {
				["type"] = "component",
				["label"] = "HART Vest",
				["order"] = "19",
				["access"] = {
					jobGrade = 0,
					flagName = "hart",
					flagLevel = 1,
					useInVehicle = true
				},
				[9] = {22, 1, 2},
			},
			["nhs_female_vest_03"] = {
				["type"] = "component",
				["label"] = "Training Vest",
				["order"] = "20",
				["access"] = {
					jobGrade = 0,
					flagName = "training",
					flagLevel = 1,
					useInVehicle = true
				},
				[9] = {22, 2, 2},
			},
			["nhs_female_header_04"] = {
				["type"] = "component",
				["label"] = "--------------|Masks|--------------",
				["order"] = "21",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["nhs_female_mask_00"] = {
				["type"] = "component",
				["label"] = "Service Stethoscope",
				["order"] = "22",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[7] = {96, 0, 2},
			},
		},
	},
	police = {
		male = {
			["police_male_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_male_uniform_00"] = {
				["type"] = "component",
				["label"] = "CT-SFO Uniform",
				["order"] = "1",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 4
				},
				[1] = {123, 1, 2},
				[3] = {96, 0, 2},
				[4] = {97, 0, 2},
				[6] = {24, 0, 2},
				[7] = {35, 1, 2},
				[8] = {15, 0, 2},	
				[9] = {23, 1, 2},
				[11] = {201, 2, 2},
			},
			["police_male_uniform_01"] = {
				["type"] = "component",
				["label"] = "SFO Uniform - 1",
				["order"] = "2",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 3
				},
				[1] = {123, 0, 2},
				[3] = {96, 0, 2},
				[4] = {97, 1, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {6, 0, 2},
				[9] = {23, 0, 2},
				[11] = {201, 1, 2},
			},
			["police_male_uniform_02"] = {
				["type"] = "component",
				["label"] = "SFO Uniform - 2",
				["order"] = "3",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 3
				},
				[1] = {123, 0, 2},
				[3] = {30, 0, 2},
				[4] = {97, 1, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {6, 0, 2},
				[9] = {23, 0, 2},
				[11] = {45, 1, 2},
			},
			["police_male_uniform_03"] = {
				["type"] = "component",
				["label"] = "AFO Uniform - 1",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2
				},
				[1] = {123, 0, 2},
				[3] = {0, 0, 2},				
				[4] = {97, 1, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {6, 0, 2},
				[9] = {19, 0, 2},								
				[11] = {45, 0, 2},
			},
			["police_male_uniform_04"] = {
				["type"] = "component",
				["label"] = "AFO Uniform - 2",
				["order"] = "5",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2
				},
				[1] = {123, 0, 2},
				[3] = {96, 0, 2},				
				[4] = {97, 1, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {6, 0, 2},
				[9] = {19, 0, 2},								
				[11] = {201, 0, 2},
			},
			["police_male_uniform_05"] = {
				["type"] = "component",
				["label"] = "MPO Uniform",
				["order"] = "6",
				["access"] = {
					jobGrade = 0,
					flagName = "boat",
					flagLevel = 1
				},
				[3] = {0, 0, 2},
				[8] = {15, 0, 2},
				[11] = {94, 1, 2},
				[4] = {31, 4, 2},
				[9] = {22, 2, 2},
				[0] = {123, 0, 2},
			},
			["police_male_uniform_06"] = {
				["type"] = "component",
				["label"] = "Wetsuit Uniform",
				["order"] = "7",
				["access"] = {
					jobGrade = 0,
					flagName = "boat",
					flagLevel = 1,
					useInVehicle = true
				},
				[1] = {122, 0, 2},
				[2] = {0, 0, 2},
				[3] = {96, 0, 2},
				[4] = {94, 0, 2},
				[6] = {67, 0, 2},
				[7] = {0, 0, 2},
				[8] = {15, 0, 2},
				[9] = {0, 0, 2},
				[11] = {243, 0, 2},
			},
			["police_male_uniform_07"] = {
				["type"] = "component",
				["label"] = "NPAS Uniform",
				["order"] = "8",
				["access"] = {
					jobGrade = 0,
					flagName = "pilot",
					flagLevel = 1
				},
				[11] = {289, 0, 2},
				[8] = {129, 0, 2},
				[3] = {1, 0, 2},
				[9] = {0, 0, 2},
				[1] = {0, 0, 2},
				[4] = {92, 18, 2},
			},
			["police_male_uniform_08"] = {
				["type"] = "component",
				["label"] = "DSU Uniform",
				["order"] = "9",
				["access"] = {
					jobGrade = 0,
					flagName = "dog",
					flagLevel = 1
				},
				[0] = {10, 0, 2},
				[1] = {121, 0, 2},
				[3] = {30, 0, 2},				
				[4] = {31, 0, 2},
				[6] = {24, 0, 2},
				[7] = {8, 0, 2},
				[8] = {6, 0, 2},
				[9] = {18, 1, 2},								
				[11] = {45, 2, 2},
			},
			["police_male_uniform_09"] = {
				["type"] = "component",
				["label"] = "Patrol Uniform",
				["order"] = "10",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[4] = {31, 0, 2},
				[6] = {24, 0, 2},
				[8] = {6, 0, 2},
				[9] = {7, 0, 2},
				[11] = {94, 0, 2},
			},
			["police_male_uniform_10"] = {
				["type"] = "component",
				["label"] = "Formal Uniform",
				["order"] = "11",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {11, 0, 2},
				[4] = {10, 0, 2},
				[6] = {54, 0, 2},
				[8] = {15, 0, 2},
				[9] = {0, 0, 2},
				[11] = {277, "grade", 2},
			},
			["police_male_uniform_11"] = {
				["type"] = "component",
				["label"] = "Bike Patrol Uniform",
				["order"] = "12",
				["access"] = {
					jobGrade = 0,
					flagName = "driving",
					flagLevel = 1
				},
				[3] = {35, 0, 2},
				[4] = {31, 0, 2},
				[6] = {24, 0, 2},
				[8] = {122, 0, 2},
				[11] = {248, 1, 2},
			},
			["police_male_uniform_12"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit - 1",
				["order"] = "13",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[3] = {1, 0, 2},
				[8] = {32, 0, 2},
				[11] = {31, 0, 2},
				[4] = {24, 0, 2},
				[6] = {20, 0, 2},
			},
			["police_male_uniform_13"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit - 2",
				["order"] = "14",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[3] = {1, 0, 2},
				[8] = {15, 0, 2},
				[11] = {322, 0, 2},
				[4] = {24, 0, 2},
				[7] = {29, 14, 2},
				[6] = {20, 0, 2},
			},
			["police_male_uniform_14"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit - 3",
				["order"] = "15",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[3] = {1, 0, 2},
				[8] = {15, 0, 2},
				[11] = {321, 0, 2},
				[4] = {24, 0, 2},
				[6] = {20, 0, 2},
			},
			["police_male_uniform_15"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit - 4",
				["order"] = "16",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[3] = {1, 0, 2},
				[8] = {31, 0, 2},
				[11] = {72, 2, 2},
				[4] = {24, 0, 2},
				[7] = {12, 2, 2},
				[6] = {20, 0, 2},
			},
			["police_male_uniform_16"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit - 5",
				["order"] = "17",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[3] = {1, 0, 2},
				[8] = {4, 0, 2},
				[11] = {142, 1, 2},
				[4] = {24, 0, 2},
				[7] = {24, 14, 2},
				[6] = {20, 0, 2},
			},
			["police_male_uniform_17"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit - 6",
				["order"] = "18",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[3] = {1, 0, 2},
				[8] = {73, 0, 2},
				[11] = {25, 4, 2},
				[4] = {24, 1, 2},
				[6] = {10, 0, 2},
			},
			["police_male_uniform_18"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit - 7",
				["order"] = "19",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[3] = {4, 0, 2},
				[11] = {348, 2, 2},
				[8] = {15, 0, 2},
				[4] = {24, 2, 2},
				[6] = {10, 0, 2},
			},
			["police_male_uniform_19"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit - 8",
				["order"] = "20",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[3] = {4, 0, 2},
				[11] = {349, 2, 2},
				[8] = {15, 0, 2},
				[4] = {24, 2, 2},
				[6] = {10, 0, 2},
				[7] = {29, 14, 2},
			},
			["police_male_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "21",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_male_hat_00"] = {
				["type"] = "prop",
				["label"] = "Police Cap",
				["order"] = "22",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[0] = {10, 0, 2},
			},
			["police_male_hat_01"] = {
				["type"] = "prop",
				["label"] = "Motorcycle Helmet",
				["order"] = "23",
				["access"] = {
					jobGrade = 0,
					flagName = "driving",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {72, 8, 2},
			},
			["police_male_hat_02"] = {
				["type"] = "prop",
				["label"] = "Frontline - Constables Hat",
				["order"] = "24",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = 0,
					useInVehicle = true
				},
				[0] = {113, 17, 1},
			},
			["police_male_hat_03"] = {
				["type"] = "prop",
				["label"] = "Traffic - Constables Hat",
				["order"] = "25",
				["access"] = {
					jobGrade = 0,
					flagName = "driving",
					flagLevel = 2,
					useInVehicle = true
				},
				[0] = {113, 18, 1},
			},
			["police_male_hat_04"] = {
				["type"] = "prop",
				["label"] = "NPAS - Helmet",
				["order"] = "26",
				["access"] = {
					jobGrade = 0,
					flagName = "pilot",
					flagLevel = 1
				},
				[0] = {134, 0, 2},
			},
			["police_male_hat_07"] = {
				["type"] = "prop",
				["label"] = "MPO Cap",
				["order"] = "27",
				["access"] = {
					jobGrade = 0,
					flagName = "boat",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {10, 1, 2},
			},
			["police_male_hat_07"] = {
				["type"] = "prop",
				["label"] = "CT-SFO Helmet",
				["order"] = "28",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 4
				},
				[0] = {129, 2, 2},
			},
			["police_male_hat_08"] = {
				["type"] = "prop",
				["label"] = "SFO Helmet",
				["order"] = "29",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 3,
					useInVehicle = true
				},
				[0] = {129, 1, 2},
			},
			["police_male_hat_09"] = {
				["type"] = "prop",
				["label"] = "AFO Helmet",
				["order"] = "30",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2,
					useInVehicle = true
				},
				[0] = {40, 1, 2},
			},
			["police_male_hat_10"] = {
				["type"] = "prop",
				["label"] = "DSU Helmet",
				["order"] = "31",
				["access"] = {
					jobGrade = 0,
					flagName = "dog",
					flagLevel = 1
				},
				[0] = {40, 1, 2},
			},
			["police_male_hat_11"] = {
				["type"] = "prop",
				["label"] = "Black Beanie",
				["order"] = "32",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {133, 0, 2},
			},
			["police_male_hat_12"] = {
				["type"] = "prop",
				["label"] = "Police Beanie (W)",
				["order"] = "33",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {133, 2, 2},
			},
			["police_male_hat_13"] = {
				["type"] = "prop",
				["label"] = "Police Beanie (G)",
				["order"] = "34",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {133, 4, 2},
			},
			["police_male_header_02"] = {
				["type"] = "component",
				["label"] = "--------------|Clothing|--------------",
				["order"] = "35",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_male_top_00"] = {
				["type"] = "component",
				["label"] = "Black Polo",
				["order"] = "36",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[8] = {15, 0, 2},
				[11] = {94, 0, 2},
			},
			["police_male_top_01"] = {
				["type"] = "component",
				["label"] = "Formal Uniform",
				["order"] = "37",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[11] = {277, "grade", 2},
				[8] = {15, 0, 2},
				[3] = {11, 0, 2},
			},
			["police_male_top_02"] = {
				["type"] = "component",
				["label"] = "Service Shell Jacket",
				["order"] = "38",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[8] = {15, 0, 2},
				[11] = {61, 0, 2},
			},
			["police_male_top_03"] = {
				["type"] = "component",
				["label"] = "Blue Pullover",
				["order"] = "39",
				["access"] = {
					jobGrade = 0,
					flagName = "boat",
					flagLevel = 1
				},
				[3] = {1, 0, 2},
				[8] = {15, 0, 2},
				[11] = {50, 3, 2},
			},
			["police_male_top_04"] = {
				["type"] = "component",
				["label"] = "HV Underjacket",
				["order"] = "40",
				["access"] = {
					jobGrade = 0,
					flagName = "driving",
					flagLevel = 1
				},
				[3] = {1, 0, 2},
				[8] = {15, 0, 2},
				[11] = {61, 2, 2},
			},
			["police_male_top_05"] = {
				["type"] = "component",
				["label"] = "Traffic - HV Roadside Jacket",
				["order"] = "41",
				["access"] = {
					jobGrade = 0,
					flagName = "driving",
					flagLevel = 1
				},
				[3] = {1, 0, 2},
				[8] = {15, 0, 2},
				[11] = {248, 1, 2},
			},
			["police_male_lowers_00"] = {
				["type"] = "component",
				["label"] = "Service Trousers",
				["order"] = "42",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[4] = {10, 0, 2},
			},
			["police_male_shoe_00"] = {
				["type"] = "component",
				["label"] = "Service Boots",
				["order"] = "43",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[6] = {54, 0, 2},
			},
			["police_male_header_03"] = {
				["type"] = "component",
				["label"] = "--------------|Accessories|--------------",
				["order"] = "44",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_male_vest_00"] = {
				["type"] = "component",
				["label"] = "Standard Vest",
				["order"] = "45",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[9] = {7, 0, 2},
			},
			["police_male_vest_01"] = {
				["type"] = "component",
				["label"] = "AFO Vest",
				["order"] = "46",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2,
					useInVehicle = true
				},
				[9] = {19, 0, 2},
			},
			["police_male_vest_02"] = {
				["type"] = "component",
				["label"] = "SFO Vest",
				["order"] = "47",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 3,
					useInVehicle = true
				},
				[9] = {23, 0, 2},
			},
			["police_male_belt_00"] = {
				["type"] = "component",
				["label"] = "Service Belt",
				["order"] = "48",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[8] = {6, 0, 2},
			},
			["police_male_belt_01"] = {
				["type"] = "component",
				["label"] = "Taser Belt",
				["order"] = "49",
				["access"] = {
					jobGrade = 0,
					flagName = "taser",
					flagLevel = 1,
					useInVehicle = true
				},
				[8] = {6, 0, 2},
				[7] = {8, 0, 2},
			},
			["police_male_belt_02"] = {
				["type"] = "component",
				["label"] = "Firearms - Leg Holster",
				["order"] = "50",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2,
					useInVehicle = true
				},
				[7] = {1, 0, 2},
			},
			["police_male_belt_03"] = {
				["type"] = "component",
				["label"] = "Shoulder Holster",
				["order"] = "51",
				["access"] = {
					jobGrade = 0,
					flagName = "covert",
					flagLevel = 1,
					useInVehicle = true
				},
				[8] = {8, 0, 2},
			},
			["police_male_belt_04"] = {
				["type"] = "component",
				["label"] = "Hip Holster + Mags",
				["order"] = "52",
				["access"] = {
					jobGrade = 0,
					flagName = "covert",
					flagLevel = 1,
					useInVehicle = true
				},
				[7] = {7, 0, 2},
			},
			["police_male_belt_05"] = {
				["type"] = "component",
				["label"] = "CID - Leg Holster",
				["order"] = "53",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[7] = {1, 0, 2},
			},
			["police_male_belt_06"] = {
				["type"] = "component",
				["label"] = "CID - Pistol Holster",
				["order"] = "54",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[7] = {4, 0, 2},
			},
			["police_male_vest_03"] = {
				["type"] = "component",
				["label"] = "CID - Ballistic Vest",
				["order"] = "55",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[9] = {18, 0, 2},
			},
			["police_male_vest_04"] = {
				["type"] = "component",
				["label"] = "CID - Stab Vest",
				["order"] = "56",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[9] = {11, 0, 2},
			},
			["police_male_header_04"] = {
				["type"] = "component",
				["label"] = "--------------|Masks|--------------",
				["order"] = "57",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_male_mask_00"] = {
				["type"] = "component",
				["label"] = "Earpiece",
				["order"] = "58",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[1] = {121, 0, 2},
			},
			["police_male_mask_01"] = {
				["type"] = "component",
				["label"] = "Firearms - Black Balaclava",
				["order"] = "59",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2,
					useInVehicle = true
				},
				[1] = {123, 0, 2},
			},
			["police_male_mask_02"] = {
				["type"] = "component",
				["label"] = "DSU - Black Balaclava",
				["order"] = "60",
				["access"] = {
					jobGrade = 0,
					flagName = "dog",
					flagLevel = 1
				},
				[1] = {123, 0, 2},
			},
		},
		female = {
			["police_female_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_female_uniform_00"] = {
				["type"] = "component",
				["label"] = "MPO Uniform",
				["order"] = "1",
				["access"] = {
					jobGrade = 0,
					flagName = "boat",
					flagLevel = 1
				},
				[3] = {14, 0, 2},
				[4] = {30, 4, 2},
				[6] = {24, 0, 2},
				[7] = {0, 0, 2},
				[8] = {15, 0, 2},
				[9] = {22, 2, 2},
				[11] = {85, 1, 2},
			},
			["police_female_uniform_01"] = {
				["type"] = "component",
				["label"] = "Wetsuit Uniform",
				["order"] = "2",
				["access"] = {
					jobGrade = 0,
					flagName = "boat",
					flagLevel = 1,
					useInVehicle = true
				},
				[1] = {122, 0, 2},
				[2] = {0, 0, 2},
				[3] = {111, 0, 2},
				[4] = {97, 0, 2},
				[6] = {70, 0, 2},
				[7] = {0, 0, 2},
				[8] = {10, 0, 2},
				[9] = {0, 0, 2},
				[11] = {251, 0, 2},
			},
			["police_female_uniform_02"] = {
				["type"] = "component",
				["label"] = "NPAS Uniform",
				["order"] = "3",
				["access"] = {
					jobGrade = 0,
					flagName = "pilot",
					flagLevel = 1
				},
				[3] = {1, 0, 2},
				[4] = {95, 18, 2},
				[6] = {24, 0, 2},
				[7] = {0, 0, 2},
				[8] = {159, 0, 2},
				[9] = {0, 0, 2},
				[11] = {302, 0, 2},
			},
			["police_female_uniform_03"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit 1",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1
				},
				[3] = {1, 0, 2},
				[4] = {23, 0, 2},
				[6] = {42, 0, 2},
				[8] = {195, 0, 2},
				[11] = {64, 0, 2},
			},
			["police_female_uniform_04"] = {
				["type"] = "component",
				["label"] = "CID - Formal Suit 2",
				["order"] = "5",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1
				},
				[3] = {1, 0, 2},
				[4] = {6, 0, 2},
				[6] = {8, 0, 2},
				[8] = {16, 0, 2},
				[11] = {7, 0, 2},
			},
			["police_female_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "6",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_female_hat_00"] = {
				["type"] = "prop",
				["label"] = "Police Cap",
				["order"] = "7",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[0] = {9, 4, 2},
			},
			["police_female_hat_01"] = {
				["type"] = "prop",
				["label"] = "Motorcycle Helmet",
				["order"] = "8",
				["access"] = {
					jobGrade = 0,
					flagName = "driving",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {71, 8, 2},
			},
			["police_female_hat_02"] = {
				["type"] = "prop",
				["label"] = "Frontline - Constables Hat",
				["order"] = "9",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[0] = {112, 17, 1},
			},
			["police_female_hat_03"] = {
				["type"] = "prop",
				["label"] = "Traffic - Constables Hat",
				["order"] = "10",
				["access"] = {
					jobGrade = 0,
					flagName = "driving",
					flagLevel = 2,
					useInVehicle = true
				},
				[0] = {112, 18, 1},
			},
			["police_female_hat_04"] = {
				["type"] = "prop",
				["label"] = "NPAS Police Helmet",
				["order"] = "11",
				["access"] = {
					jobGrade = 0,
					flagName = "pilot",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {133, 0, 2},
			},
			["police_female_hat_05"] = {
				["type"] = "prop",
				["label"] = "MPO Cap",
				["order"] = "12",
				["access"] = {
					jobGrade = 0,
					flagName = "boat",
					flagLevel = 1,
					useInVehicle = true
				},
				[0] = {9, 3, 2},
			},
			["police_female_hat_06"] = {
				["type"] = "prop",
				["label"] = "Black Beanie",
				["order"] = "13",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[0] = {132, 0, 2},
			},
			["police_female_hat_07"] = {
				["type"] = "prop",
				["label"] = "Police Beanie (w)",
				["order"] = "14",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[0] = {132, 2, 2},
			},
			["police_female_hat_08"] = {
				["type"] = "prop",
				["label"] = "Police Beanie (G)",
				["order"] = "15",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[0] = {132, 4, 2},
			},
			["police_female_header_02"] = {
				["type"] = "component",
				["label"] = "--------------|Clothing|--------------",
				["order"] = "16",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_female_top_00"] = {
				["type"] = "component",
				["label"] = "Black Polo",
				["order"] = "17",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {14, 0, 2},
				[7] = {0, 0, 2},
				[8] = {15, 0, 2},
				[11] = {85, 0, 2},
			},
			["police_female_top_01"] = {
				["type"] = "component",
				["label"] = "Formal Uniform",
				["order"] = "18",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[11] = {290, "grade", 2},
				[8] = {14, 0, 2},
				[3] = {9, 0, 2},
			},
			["police_female_top_02"] = {
				["type"] = "component",
				["label"] = "Service Shell Jacket",
				["order"] = "19",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {3, 0, 2},
				[7] = {0, 0, 2},
				[8] = {15, 0, 2},
				[11] = {54, 0, 2},
			},
			["police_female_top_03"] = {
				["type"] = "component",
				["label"] = "Blue Pullover",
				["order"] = "20",
				["access"] = {
					jobGrade = 0,
					flagName = "boat",
					flagLevel = 1,
				},
				[3] = {3, 0, 2},
				[7] = {0, 0, 2},
				[8] = {14, 0, 2},
				[11] = {43, 3, 2},
			},
			["police_female_top_04"] = {
				["type"] = "component",
				["label"] = "HV Underjacket",
				["order"] = "21",
				["access"] = {
					jobGrade = 0,
					flagName = "driving",
					flagLevel = 1,
				},
				[3] = {3, 0, 2},
				[7] = {0, 0, 2},
				[8] = {15, 0, 2},
				[11] = {54, 2, 2},
			},
			["police_female_top_05"] = {
				["type"] = "component",
				["label"] = "HV Roadside Jacket",
				["order"] = "22",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {92, 0, 2},
				[8] = {15, 0, 2},
				[11] = {256, 1, 2},
			},
			["police_female_lower_00"] = {
				["type"] = "component",
				["label"] = "Service Trousers",
				["order"] = "23",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[4] = {41, 3, 2},
			},
			["police_female_shoe_00"] = {
				["type"] = "component",
				["label"] = "Police Service Boots",
				["order"] = "24",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[6] = {72, 0, 2},
			},
			["police_female_header_03"] = {
				["type"] = "component",
				["label"] = "--------------|Accessories|--------------",
				["order"] = "25",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_female_vest_00"] = {
				["type"] = "component",
				["label"] = "Standard Vest",
				["order"] = "26",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil,
					useInVehicle = true
				},
				[9] = {24, 0, 2},
			},
			["police_female_vest_01"] = {
				["type"] = "component",
				["label"] = "Firearms Vest",
				["order"] = "27",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2,
					useInVehicle = true
				},
				[9] = {23, 0, 2},
			},
			["police_female_vest_02"] = {
				["type"] = "component",
				["label"] = "CID - Stab Vest",
				["order"] = "28",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[9] = {10, 0, 2},
			},
			["police_female_belt_00"] = {
				["type"] = "component",
				["label"] = "Service Belt",
				["order"] = "29",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[8] = {6, 0, 2},
			},
			["police_female_belt_01"] = {
				["type"] = "component",
				["label"] = "Firearms - Leg Holster",
				["order"] = "30",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2,
					useInVehicle = true
				},
				[7] = {1, 0, 2},
			},
			["police_female_belt_01"] = {
				["type"] = "component",
				["label"] = "CID - Leg Holster",
				["order"] = "31",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[7] = {1, 0, 2},
			},
			["police_female_belt_03"] = {
				["type"] = "component",
				["label"] = "CID - Pistol Holster",
				["order"] = "32",
				["access"] = {
					jobGrade = 0,
					flagName = "cid",
					flagLevel = 1,
					useInVehicle = true
				},
				[7] = {4, 0, 2},
			},
			["police_female_belt_02"] = {
				["type"] = "component",
				["label"] = "Taser Belt",
				["order"] = "33",
				["access"] = {
					jobGrade = 0,
					flagName = "taser",
					flagLevel = 1,
					useInVehicle = true
				},
				[8] = {6, 0, 2},
				[7] = {8, 0, 2},
			},
			["police_female_header_04"] = {
				["type"] = "component",
				["label"] = "--------------|Masks|--------------",
				["order"] = "34",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["police_female_mask_00"] = {
				["type"] = "component",
				["label"] = "Firearms - Black Balaclava",
				["order"] = "35",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2,
					useInVehicle = true
				},
				[1] = {169, 0, 2},
			},
			["police_male_mask_01"] = {
				["type"] = "component",
				["label"] = "DSU - Black Balaclava",
				["order"] = "36",
				["access"] = {
					jobGrade = 0,
					flagName = "firearms",
					flagLevel = 2,
					useInVehicle = true
				},
				[1] = {169, 0, 2},
			},
		},
	},
	weazel = {
		male = {
			["weazel_male_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["weazel_male_hat_00"] = {
				["type"] = "prop",
				["label"] = "Weazel News Cap",
				["order"] = "1",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {10, 3, 2},
			},
			["weazel_male_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Accessories|--------------",
				["order"] = "2",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["weazel_male_vest_00"] = {
				["type"] = "component",
				["label"] = "Weazel News Vest",
				["order"] = "3",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[9] = {24, 0, 2},
			},
			["weazel_male_vest_01"] = {
				["type"] = "component",
				["label"] = "Weazel Press Vest",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[9] = {11, 2, 2},
			},
		},
		female = {
			["weazel_female_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["weazel_female_hat_00"] = {
				["type"] = "prop",
				["label"] = "Weazel News Cap",
				["order"] = "1",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {9, 7, 2},
			},
			["weazel_female_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Accessories|--------------",
				["order"] = "2",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["weazel_female_vest_00"] = {
				["type"] = "component",
				["label"] = "Weazel News Vest",
				["order"] = "3",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[9] = {25, 0, 2},
			},
			["weazel_female_vest_01"] = {
				["type"] = "component",
				["label"] = "Weazel Press Vest",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[9] = {10, 2, 2},
			},
		},
	},
	gruppe6 = {
		male = {
			["gruppe6_male_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_male_uniform_00"] = {
				["type"] = "component",
				["label"] = "Prison Uniform - 1",
				["order"] = "1",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {10, 0, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {154, 0, 2},
				[9] = {17, 0, 2},
				[11] = {198, 0, 2},
			},
			["gruppe6_male_uniform_01"] = {
				["type"] = "component",
				["label"] = "Prison Uniform - 2",
				["order"] = "2",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[4] = {10, 0, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {154, 0, 2},
				[9] = {17, 0, 2},
				[11] = {199, 0, 2},
			},
			["gruppe6_male_uniform_02"] = {
				["type"] = "component",
				["label"] = "Security Uniform - 1",
				["order"] = "3",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {10, 0, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {154, 0, 2},
				[9] = {17, 0, 2},
				[11] = {198, 2, 2},
			},
			["gruppe6_male_uniform_03"] = {
				["type"] = "component",
				["label"] = "Security Uniform - 2",
				["order"] = "4",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[4] = {10, 0, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {154, 0, 2},
				[9] = {17, 0, 2},
				[11] = {199, 2, 2},
			},
			["gruppe6_male_uniform_04"] = {
				["type"] = "component",
				["label"] = "Sentry Uniform - 1",
				["order"] = "5",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {10, 0, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {154, 0, 2},
				[9] = {17, 0, 2},
				[11] = {198, 3, 2},
			},
			["gruppe6_male_uniform_05"] = {
				["type"] = "component",
				["label"] = "Sentry Uniform - 2",
				["order"] = "6",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[4] = {10, 0, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {154, 0, 2},
				[9] = {17, 0, 2},
				[11] = {199, 3, 2},
			},
			["gruppe6_male_uniform_06"] = {
				["type"] = "component",
				["label"] = "Command Uniform - 1",
				["order"] = "7",
				["access"] = {
					jobGrade = 3,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {10, 0, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {154, 0, 2},
				[9] = {17, 0, 2},
				[11] = {198, 1, 2},
			},
			["gruppe6_male_uniform_07"] = {
				["type"] = "component",
				["label"] = "Command Uniform - 2",
				["order"] = "8",
				["access"] = {
					jobGrade = 3,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {0, 0, 2},
				[4] = {10, 0, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {154, 0, 2},
				[9] = {17, 0, 2},
				[11] = {199, 1, 2},
			},
			["gruppe6_male_uniform_08"] = {
				["type"] = "component",
				["label"] = "Formal Suit - 1",
				["order"] = "9",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[1] = {121, 0, 2},
				[3] = {1, 0, 2},
				[4] = {24, 0, 2},
				[6] = {10, 0, 2},
				[7] = {26, 2, 2},
				[8] = {33, 0, 2},
				[9] = {0, 0, 2},
				[11] = {29, 0, 2},
			},
			["gruppe6_male_uniform_09"] = {
				["type"] = "component",
				["label"] = "Formal Suit - 2",
				["order"] = "10",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[1] = {121, 0, 2},
				[3] = {1, 0, 2},
				[4] = {24, 0, 2},
				[6] = {10, 0, 2},
				[7] = {27, 2, 2},   
				[8] = {158, 0, 2},
				[9] = {0, 0, 2},
				[11] = {11, 0, 2},
			},
			["gruppe6_male_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "11",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_male_hat_00"] = {
				["type"] = "prop",
				["label"] = "Cap",
				["order"] = "12",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {58, 2, 2},
			},
			["gruppe6_male_hat_01"] = {
				["type"] = "prop",
				["label"] = "Helmet",
				["order"] = "13",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {126, 0, 2},
			},
			["gruppe6_male_hat_02"] = {
				["type"] = "prop",
				["label"] = "G6 Beanie (B)",
				["order"] = "14",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {133, 6, 2},
			},
			["gruppe6_male_hat_03"] = {
				["type"] = "prop",
				["label"] = "G6 Beanie (G)",
				["order"] = "15",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {133, 7, 2},
			},
			["gruppe6_male_header_02"] = {
				["type"] = "component",
				["label"] = "--------------|Clothing|--------------",
				["order"] = "16",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["grupp6_male_lowers_00"] = {
				["type"] = "component",
				["label"] = "Service Trousers",
				["order"] = "17",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[4] = {10, 0, 2},
			},
			["gruppe6_male_shoe_00"] = {
				["type"] = "component",
				["label"] = "Heavy Duty Boots",
				["order"] = "18",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[6] = {24, 0, 2},
			},
			["gruppe6_male_header_03"] = {
				["type"] = "component",
				["label"] = "--------------|Accessories|--------------",
				["order"] = "19",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_male_belt_00"] = {
				["type"] = "component",
				["label"] = "Leg Holster",
				["order"] = "20",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[7] = {1, 0, 2},
			},
			["gruppe6_male_belt_01"] = {
				["type"] = "component",
				["label"] = "Pistol Holster",
				["order"] = "21",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[7] = {4, 0, 2},
			},
			["gruppe6_male_belt_02"] = {
				["type"] = "component",
				["label"] = "Service Belt",
				["order"] = "22",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[8] = {154, 0, 2},
			},
			["gruppe6_male_vest_00"] = {
				["type"] = "component",
				["label"] = "G6 Vest",
				["order"] = "23",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[9] = {17, 0, 2},
			},
			["gruppe6_male_header_04"] = {
				["type"] = "component",
				["label"] = "--------------|Masks|--------------",
				["order"] = "24",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_male_mask_00"] = {
				["type"] = "component",
				["label"] = "Earpiece",
				["order"] = "25",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[1] = {121, 0, 2},
			},
		},
		female ={
			["gruppe6_female_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_female_uniform_00"] = {
				["type"] = "component",
				["label"] = "Prison Uniform - 1",
				["order"] = "1",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {3, 0, 2},
				[4] = {41, 3, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {190, 0, 2},
				[9] = {19, 0, 2},
				[11] = {201, 0, 2},
			},
			["gruppe6_female_uniform_01"] = {
				["type"] = "component",
				["label"] = "Prison Uniform - 2",
				["order"] = "2",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {14, 0, 2},
				[4] = {41, 3, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {190, 0, 2},
				[9] = {19, 0, 2},
				[11] = {200, 0, 2},
			},
			["gruppe6_female_uniform_02"] = {
				["type"] = "component",
				["label"] = "Security Uniform - 1",
				["order"] = "3",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {3, 0, 2},
				[4] = {41, 3, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {190, 0, 2},
				[9] = {19, 0, 2},
				[11] = {201, 2, 2},
			},
			["gruppe6_female_uniform_03"] = {
				["type"] = "component",
				["label"] = "Security Uniform - 2",
				["order"] = "4",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {14, 0, 2},
				[4] = {41, 3, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {190, 0, 2},
				[9] = {19, 0, 2},
				[11] = {200, 2, 2},
			},
			["gruppe6_female_uniform_04"] = {
				["type"] = "component",
				["label"] = "Sentry Uniform - 1",
				["order"] = "5",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {3, 0, 2},
				[4] = {41, 3, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {190, 0, 2},
				[9] = {19, 0, 2},
				[11] = {201, 3, 2},
			},
			["gruppe6_female_uniform_05"] = {
				["type"] = "component",
				["label"] = "Sentry Uniform - 2",
				["order"] = "6",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {14, 0, 2},
				[4] = {41, 3, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {190, 0, 2},
				[9] = {19, 0, 2},
				[11] = {200, 3, 2},
			},
			["gruppe6_female_uniform_06"] = {
				["type"] = "component",
				["label"] = "Command Uniform - 1",
				["order"] = "7",
				["access"] = {
					jobGrade = 3,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {3, 0, 2},
				[4] = {41, 3, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {190, 0, 2},
				[9] = {19, 0, 2},
				[11] = {201, 1, 2},
			},
			["gruppe6_female_uniform_07"] = {
				["type"] = "component",
				["label"] = "Command Uniform - 2",
				["order"] = "8",
				["access"] = {
					jobGrade = 3,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {14, 0, 2},
				[4] = {41, 3, 2},
				[6] = {24, 0, 2},
				[7] = {1, 0, 2},
				[8] = {190, 0, 2},
				[9] = {19, 0, 2},
				[11] = {200, 1, 2},
			},
			["gruppe6_female_uniform_08"] = {
				["type"] = "component",
				["label"] = "Formal Suit - 1",
				["order"] = "9",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[1] = {121, 0, 2},
				[3] = {1, 0, 2},
				[4] = {37, 0, 2},
				[6] = {29, 0, 2},
				[7] = {27, 2, 2},
				[8] = {41, 2, 2},
				[9] = {0, 0, 2},
				[11] = {7, 0, 2},
			},
			["gruppe6_female_uniform_09"] = {
				["type"] = "component",
				["label"] = "Formal Suit - 2",
				["order"] = "10",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[1] = {121, 0, 2},
				[3] = {1, 0, 2},
				[4] = {37, 0, 2},
				[6] = {29, 0, 2},
				[7] = {23, 0, 2},
				[8] = {194, 0, 2},
				[9] = {0, 0, 2},
				[11] = {334, 0, 2},
			},
			["gruppe6_female_header_01"] = {
				["type"] = "component",
				["label"] = "--------------|Hats|--------------",
				["order"] = "11",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_female_hat_00"] = {
				["type"] = "prop",
				["label"] = "Cap",
				["order"] = "12",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {58, 2, 2},
			},
			["gruppe6_female_hat_01"] = {
				["type"] = "prop",
				["label"] = "Helmet",
				["order"] = "13",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {125, 0, 2},
			},
			["gruppe6_female_hat_02"] = {
				["type"] = "prop",
				["label"] = "G6 Beanie (B)",
				["order"] = "14",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {132, 6, 2},
			},
			["gruppe6_female_hat_03"] = {
				["type"] = "prop",
				["label"] = "G6 Beanie (G)",
				["order"] = "15",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[0] = {132, 7, 2},
			},
			["gruppe6_female_header_02"] = {
				["type"] = "component",
				["label"] = "--------------|Clothing|--------------",
				["order"] = "16",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_female_lower_00"] = {
				["type"] = "component",
				["label"] = "Gruppe6 Service Trousers",
				["order"] = "17",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[4] = {41, 3, 2},
			},
			["gruppe6_female_shoe_00"] = {
				["type"] = "component",
				["label"] = "Heavy Duty Boots",
				["order"] = "18",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[6] = {24, 0, 2},
			},
			["gruppe6_female_header_03"] = {
				["type"] = "component",
				["label"] = "--------------|Accessories|--------------",
				["order"] = "19",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_female_belt_00"] = {
				["type"] = "component",
				["label"] = "Leg Holster",
				["order"] = "20",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[7] = {1, 0, 2},
			},
			["gruppe6_female_belt_01"] = {
				["type"] = "component",
				["label"] = "Pistol Holster",
				["order"] = "21",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[7] = {4, 0, 2},
			},
			["gruppe6_female_belt_02"] = {
				["type"] = "component",
				["label"] = "Service Belt",
				["order"] = "22",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[8] = {190, 0, 2},
			},
			["gruppe6_female_vest_00"] = {
				["type"] = "component",
				["label"] = "Gruppe6 Vest",
				["order"] = "23",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[9] = {19, 0, 2},
			},
			["gruppe6_female_header_04"] = {
				["type"] = "component",
				["label"] = "--------------|Masks|--------------",
				["order"] = "24",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["gruppe6_female_mask_00"] = {
				["type"] = "component",
				["label"] = "Earpeice",
				["order"] = "25",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[1] = {121, 0, 2},
			},
		},
	},
	callaghan = {
		male = {
			["callaghan_male_top_06"] = {
				["type"] = "component",
				["label"] = "Pinstripe Jacket Blue",
				["order"] = "1",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[11] = {20, 1, 2},
				[8] = {13, 0, 2},
				[3] = {1, 0, 2},
			},
			["callaghan_male_top_01"] = {
				["type"] = "component",
				["label"] = "Pinstripe Jacket Black",
				["order"] = "2",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[11] = {20, 2, 2},
				[8] = {13, 0, 2},
				[3] = {1, 0, 2},
			},
			["callaghan_male_lower_00"] = {
				["type"] = "component",
				["label"] = "Pinstripe Trousers Blue",
				["order"] = "3",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[4] = {20, 1, 2},
			},
			["callaghan_male_lower_01"] = {
				["type"] = "component",
				["label"] = "Pinstripe Trousers Black",
				["order"] = "4",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[4] = {20, 2, 2},
			},
			["callaghan_male_acce_00"] = {
				["type"] = "component",
				["label"] = "Blue Tie",
				["order"] = "5",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[7] = {23, 0, 2},
			},
			["callaghan_male_acce_01"] = {
				["type"] = "component",
				["label"] = "Red Tie",
				["order"] = "6",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[7] = {23, 2, 2},
			},
			["callaghan_male_acce_02"] = {
				["type"] = "component",
				["label"] = "Black Tie",
				["order"] = "7",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[7] = {23, 1, 2},
			},
			["callaghan_male_gloves_00"] = {
				["type"] = "component",
				["label"] = "Gloves",
				["order"] = "8",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {35, 0, 2},
			},
		},
	},
	court = {
		male = {
			["judge_male_header_00"] = {
				["type"] = "component",
				["label"] = "--------------|Uniforms|--------------",
				["order"] = "0",
				["access"] = {
					jobGrade = 0,
					flagName = nil,
					flagLevel = nil
				},
			},
			["judge_male_uniform_00"] = {
				["type"] = "component",
				["label"] = "Gray Suit",
				["order"] = "1",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {24, 1, 2},
				[6] = {10, 0, 2},
				[7] = {26, 12, 2},
				[8] = {33, 1, 2},
				[11] = {29, 1, 2},			
			},
			["judge_male_uniform_01"] = {
				["type"] = "component",
				["label"] = "Blue Suit",
				["order"] = "2",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {52, 1, 2},
				[8] = {32, 0, 2},
				[6] = {10, 0, 2},
				[11] = {102, 1, 2},
			},
			["judge_male_uniform_02"] = {
				["type"] = "component",
				["label"] = "Smoking Jacket Suit",
				["order"] = "3",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {52, 2, 2},
				[6] = {3, 12, 2},
				[7] = {20, 2, 2},
				[8] = {31, 2, 2},
				[11] = {145, 6, 2},
			},
			["judge_male_uniform_03"] = {
				["type"] = "component",
				["label"] = "Suit no Jacket",
				["order"] = "4",
				["access"] = {
					jobGrade = 2,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {28, 3, 2},
				[6] = {20, 5, 2},
				[7] = {26, 15, 2},
				[8] = {22, 1, 2},
				[11] = {21, 2, 2},
			},
			["solicitor_male_uniform_00"] = {
				["type"] = "component",
				["label"] = "Gray Suit",
				["order"] = "5",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {4, 0, 2},
				[4] = {24, 1, 2},
				[6] = {20, 0, 2},
				[7] = {12, 1, 2},
				[8] = {31, 1, 2},
				[11] = {294, 2, 2},
			},
			["solicitor_male_uniform_01"] = {
				["type"] = "component",
				["label"] = "Gray Suit No Jacket",
				["order"] = "6",
				["access"] = {
					jobGrade = 1,
					flagName = nil,
					flagLevel = nil
				},
				[3] = {1, 0, 2},
				[4] = {24, 1, 2},
				[6] = {40, 2, 2},
				[7] = {24, 1, 2},
				[8] = {158, 0, 2},
				[11] = {11, 0, 2},
			},
		},
	},
}