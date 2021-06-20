Locations = {}

Locations.JobInteraction = {
	Vespucci = CircleZone:Create(vector3(-1095.69, -846.71, 37.7), 66.0, {
		useZ=true,
		--debugPoly=true
	}),
	Sandy = CircleZone:Create(vector3(1837.63, 3685.86, 33.86), 32.5, {
		useZ=true,
		--debugPoly=true
	}),
	Paleto = CircleZone:Create(vector3(-445.65, 6005.5, 31.72), 20.0, {
		useZ=true,
		--debugPoly=true
	}),
	PaletoHosp = CircleZone:Create(vector3(-252.93, 6321.13, 32.43), 40.0, {
		useZ=true,
		--debugPoly=true
	}),
	TaticalDepolyment = CircleZone:Create(vector3(-745.86, -1468.19, 5.0), 74.0, {
		useZ=true,
		--debugPoly=true
	}),
	CityHall = BoxZone:Create(vector3(-550.57, -194.61, 52.2), 21.8, 18.4, {
		heading=35,
		-- debugPoly=true
	}),
	Pillbox = CircleZone:Create(vector3(318.41, -582.14, 28.88), 88.5, {
		useZ=true,
		-- debugPoly=true
	}),
	SanChianski = CircleZone:Create(vector3(3871.7, 4459.07, 2.72), 26.0, {
		useZ=true,
		--debugPoly=true
	}),
	PaletoCove = CircleZone:Create(vector3(-1597.21, 5262.21, 2.08), 10.0, {
		useZ=true,
		--debugPoly=true
	}),
	CayoPerico = CircleZone:Create(vector3(5115.01, -4655.2, 1.79), 52.0, {
		useZ=true,
		--debugPoly=true
	}),
	LostLS = CircleZone:Create(vector3(977.56, -116.21, 74.29), 36.0, {
		useZ=true,
		--debugPoly=true
	}),
	NCARedactedZone = CircleZone:Create(vector3(120.46, -100.69, 46.7), 41.0, {
		useZ=true,
		--debugPoly=true
	}),
	Gruppe6Office = CircleZone:Create(vector3(37.56, -897.69, 30.21), 50.0, {
		useZ=true,
		--debugPoly=true
	}),
	Gruppe6Prison = CircleZone:Create(vector3(1691.07, 2604.95, 45.56), 750.0, {
		useZ=true,
		--debugPoly=true
	}),
	WeazelOffice = CircleZone:Create(vector3(-572.63, -907.73, 28.16), 50.5, {
		useZ=true,
		--debugPoly=true
	}),
}



Locations.PolyPoints = {
	["police"] = {
		ClockIn = {
			PolyZone = {
				Vespucci = BoxZone:Create(vector3(-1098.38, -840.65, 19.0), 3.6, 5.0, {
					heading=310,
					--debugPoly=true,
					minZ=16.6,
					maxZ=20.2
				}),
				Sandy = CircleZone:Create(vector3(1853.7, 3688.52, 34.26), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Paleto = CircleZone:Create(vector3(-447.75, 6013.24, 31.72), 1.5, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = CircleZone:Create(vector3(441.36, -982.02, 30.69), 1.0, {
					useZ=true,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = false,
			}
		},
		ClockOut = {
			PolyZone = {
				Vespucci = BoxZone:Create(vector3(-1098.38, -840.65, 19.0), 3.6, 5.0, {
					heading=310,
					--debugPoly=true,
					minZ=16.6,
					maxZ=20.2
				}),
				Sandy = CircleZone:Create(vector3(1853.7, 3688.52, 34.26), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Paleto = CircleZone:Create(vector3(-447.75, 6013.24, 31.72), 1.5, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = CircleZone:Create(vector3(441.36, -982.02, 30.69), 1.0, {
					useZ=true,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = false
			}
		},
		LockerRoom = {
			PolyZone = {
				Vespucci = BoxZone:Create(vector3(-1096.2, -832.07, 14.28), 6.0, 6.2, {
					heading=35,
					--debugPoly=true,
					minZ=12.08,
					maxZ=16.08
				}),
				Sandy = CircleZone:Create(vector3(1849.32, 3696.26, 34.26), 2.5, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = BoxZone:Create(vector3(461.83, -997.8, 30.69), 5.2, 4.6, {
					heading=180,
					--debugPoly=true,
					minZ=29.69,
					maxZ=33.69
				}),
				Paleto = CircleZone:Create(vector3(-437.92, 5988.65, 31.72), 1.5, {
					useZ=true,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			}
		},
		Armory = {
			PolyZone = {
				Vespucci = BoxZone:Create(vector3(-1098.81, -826.25, 14.28), 1.4, 3.6, {
					heading=40,
					--debugPoly=true,
					minZ=11.68,
					maxZ=15.68
				}),
				Sandy = CircleZone:Create(vector3(1841.67, 3691.64, 34.26), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Paleto = CircleZone:Create(vector3(-437.92, 5988.65, 31.72), 1.5, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = BoxZone:Create(vector3(483.49, -997.33, 30.69), 5.2, 10.0, {
					heading=0,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			}
		},
		Attachments = {
			PolyZone = {
				Vespucci = BoxZone:Create(vector3(-1098.81, -826.25, 14.28), 1.4, 3.6, {
					heading=40,
					--debugPoly=true,
					minZ=11.68,
					maxZ=15.68
				}),
				Sandy = CircleZone:Create(vector3(1841.67, 3691.64, 34.26), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Paleto = CircleZone:Create(vector3(-437.92, 5988.65, 31.72), 1.5, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = BoxZone:Create(vector3(483.49, -997.33, 30.69), 5.2, 10.0, {
					heading=0,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			}
		},
		VehicleRental = {
			PolyZone = {
				Vespucci = BoxZone:Create(vector3(-1060.63, -861.79, 4.76), 61.6, 32.6, {
					heading=310,
					--debugPoly=true,
					minZ=3.76,
					maxZ=7.76,
					name = "car"
				}),
				VespucciAir = BoxZone:Create(vector3(-1096.88, -833.48, 37.7), 16.0, 16.4, {
					heading=37,
					--debugPoly=true,
					minZ=35.5,
					maxZ=39.5,
					name = "air"
				}),
				Sandy = PolyZone:Create({
					vector2(1815.9787597656, 3656.6467285156),
					vector2(1868.4096679688, 3686.9748535156),
					vector2(1872.0925292969, 3680.1157226562),
					vector2(1819.8826904297, 3649.9819335938)
				}, {
					name="car",
					--minZ = 33.599998474121,
					--maxZ = 34.191120147705
				}),
				PaletoAir = CircleZone:Create(vector3(-475.58, 5989.27, 31.34), 9.5, {
					useZ=true,
					--debugPoly=true
					name = "air"
				}),
				PaletoCar = BoxZone:Create(vector3(-456.51, 6000.91, 31.3), 12.8, 30.2, {
					heading=315,
					--debugPoly=true,
					minZ=29.3,
					maxZ=33.3,
					name = "car"
				}),
				TaticalDepolymentBoat = CircleZone:Create(vector3(-793.49, -1500.35, 2.03), 21.5, {
					useZ=true,
					-- debugPoly=true
					name = "boat"
				}),
				TaticalDepolymentAir = CircleZone:Create(vector3(-732.82, -1454.3, 5.0), 36.0, {
					name="air",
					useZ=true,
					--debugPoly=true
				}),
				SanChianski = CircleZone:Create(vector3(3871.7, 4459.07, 2.72), 26.0, {
					useZ=true,
					name = "boat"
					--debugPoly=true
				}),
				PaletoCove = CircleZone:Create(vector3(-1597.21, 5262.21, 2.08), 10.0, {
					useZ=true,
					--debugPoly=true,
					name = "boat"
				}),
				CayoPerico = CircleZone:Create(vector3(5115.01, -4655.2, 1.79), 52.0, {
					useZ=true,
					--debugPoly=true
					name = "boat"
				}),
				MissionRow = BoxZone:Create(vector3(442.24, -986.31, 25.7), 27.0, 38.8, {
					name="car",
					heading=0,
					--debugPoly=true,
					minZ=24.7,
					maxZ=28.7
				}),
				MissionRowAir = BoxZone:Create(vector3(449.67, -981.37, 43.69), 13.8, 13.4, {
					name="air",
					heading=359,
					--debugPoly=true,
					minZ=42.29,
					maxZ=46.29
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			}
		},
		VehicleDelete = {
			PolyZone = {
				Vespucci = BoxZone:Create(vector3(-1078.05, -844.99, 4.88), 14.8, 12.8, {
					heading=35,
					--debugPoly=true
				}),
				VespucciAir = CircleZone:Create(vector3(-1100.47, -836.77, 37.7), 12.5, {
					useZ=true,
					-- debugPoly=true
				}),
				Sandy = PolyZone:Create({
					vector2(1815.9787597656, 3656.6467285156),
					vector2(1868.4096679688, 3686.9748535156),
					vector2(1872.0925292969, 3680.1157226562),
					vector2(1819.8826904297, 3649.9819335938)
				}, {
					--minZ = 33.599998474121,
					--maxZ = 34.191120147705
				}),
				PaletoAir = CircleZone:Create(vector3(-475.58, 5989.27, 31.34), 9.5, {
					useZ=true,
					--debugPoly=true
				}),
				PaletoCar = BoxZone:Create(vector3(-456.51, 6000.91, 31.3), 12.8, 30.2, {
					heading=315,
					--debugPoly=true,
					minZ=29.3,
					maxZ=33.3,
				}),
				TaticalDepolymentAir = CircleZone:Create(vector3(-732.82, -1454.3, 5.0), 36.0, {
					useZ=true,
					--debugPoly=true
				}),
				TaticalDepolymentBoat = CircleZone:Create(vector3(-793.49, -1500.35, 2.03), 21.5, {
					useZ=true,
					-- debugPoly=true
				}),
				SanChianski = CircleZone:Create(vector3(3871.7, 4459.07, 2.72), 26.0, {
					useZ=true,
					--debugPoly=true
				}),
				PaletoCove = CircleZone:Create(vector3(-1597.21, 5262.21, 2.08), 10.0, {
					useZ=true,
					--debugPoly=true,
				}),
				CayoPerico = CircleZone:Create(vector3(5115.01, -4655.2, 1.79), 52.0, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = BoxZone:Create(vector3(442.24, -986.31, 25.7), 27.0, 38.8, {
					heading=0,
					--debugPoly=true,
					minZ=24.7,
					maxZ=28.7
				}),
				MissionRowAir = BoxZone:Create(vector3(449.67, -981.37, 43.69), 13.8, 13.4, {
					heading=359,
					--debugPoly=true,
					minZ=42.29,
					maxZ=46.29
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			}
		},
		Management = {
			PolyZone = {
				Vespucci = CircleZone:Create(vector3(-1113.73, -831.81, 30.76), 2.0, {
					useZ=true,
					-- debugPoly=true
				}),
				Sandy = CircleZone:Create(vector3(1849.32, 3696.26, 34.26), 2.5, {
					useZ=true,
					--debugPoly=true
				}),
				Paleto = CircleZone:Create(vector3(-438.04, 6000.8, 31.72), 3.5, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = CircleZone:Create(vector3(461.64, -986.81, 30.69), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.police,
				requriedToClockIn = true
			}
		},
		ViewFund = {
			PolyZone = {
				Vespucci = CircleZone:Create(vector3(-1113.73, -831.81, 30.76), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Sandy = CircleZone:Create(vector3(1849.32, 3696.26, 34.26), 2.5, {
					useZ=true,
					--debugPoly=true
				}),
				Paleto = CircleZone:Create(vector3(-438.04, 6000.8, 31.72), 3.5, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = CircleZone:Create(vector3(461.64, -986.81, 30.69), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.fundAccess.police.View,
				requriedToClockIn = true
			}
		},
		FundManagement = {
			PolyZone = {
				Vespucci = CircleZone:Create(vector3(-1113.73, -831.81, 30.76), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Sandy = CircleZone:Create(vector3(1849.32, 3696.26, 34.26), 2.5, {
					useZ=true,
					--debugPoly=true
				}),
				Paleto = CircleZone:Create(vector3(-438.04, 6000.8, 31.72), 3.5, {
					useZ=true,
					--debugPoly=true
				}),
				MissionRow = CircleZone:Create(vector3(461.64, -986.81, 30.69), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.fundAccess.police.Admin,
				requriedToClockIn = true
			}
		},
		JobInfo = {
			type = "job",
			name = "police",
			targetIndex = "police_level"
		}
	},
	["ambulance"] = {
		ClockIn = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(305.58, -599.92, 43.28), 3.0, {
					useZ=true,
					--debugPoly=true
				}),
				SandyShores = CircleZone:Create(vector3(1830.44, 3676.14, 34.27), 3.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = false
			}
		},
		ClockOut = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(305.58, -599.92, 43.28), 3.0, {
					useZ=true,
					--debugPoly=true
				}),
				SandyShores = CircleZone:Create(vector3(1830.44, 3676.14, 34.27), 3.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = false
			}
		},
		LockerRoom = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(300.63, -598.14, 43.28), 3.0, {
					useZ=true,
					--debugPoly=true
				}),
				Sandy = CircleZone:Create(vector3(1825.36, 3674.62, 34.27), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			},
		},
		Armory = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(300.63, -598.14, 43.28), 3.0, {
					useZ=true,
					--debugPoly=true
				}),
				Sandy = CircleZone:Create(vector3(1825.36, 3674.62, 34.27), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			},
		},
		VehicleRental = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(326.99, -546.48, 28.74), 16.0, {
					useZ=true,
					-- debugPoly=true,
					name = "car"
				}),
				Pillbox2 = BoxZone:Create(vector3(328.62, -575.96, 28.8), 32.0, 34.8, {
					heading=339,
					--debugPoly=true,
					minZ=28.0,
					maxZ=32.0,
					name = "car"
				}),
				Sandy = PolyZone:Create({
					vector2(1815.9787597656, 3656.6467285156),
					vector2(1868.4096679688, 3686.9748535156),
					vector2(1872.0925292969, 3680.1157226562),
					vector2(1819.8826904297, 3649.9819335938)
				}, {
					name="car",
					--minZ = 33.599998474121,
					--maxZ = 34.191120147705
				}),
				PaletoAir = CircleZone:Create(vector3(-252.88, 6321.08, 39.66), 10.0, {
					useZ=true,
					--debugPoly=true
					name = "air"
				}),
				PillboxAir = CircleZone:Create(vector3(350.49, -588.99, 74.16), 13.0, {
					name="air",
					useZ=true,
					--debugPoly=true
				}),
				CayoPerico = CircleZone:Create(vector3(5115.01, -4655.2, 1.79), 52.0, {
					useZ=true,
					--debugPoly=true
					name = "boat"
				}),
				TaticalDepolymentBoat = CircleZone:Create(vector3(-793.49, -1500.35, 2.03), 21.5, {
					useZ=true,
					-- debugPoly=true
					name = "boat"
				}),
				TaticalDepolymentAir = CircleZone:Create(vector3(-732.82, -1454.3, 5.0), 36.0, {
					name="air",
					useZ=true,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			},
		},
		VehicleDelete = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(326.99, -546.48, 28.74), 16.0, {
					useZ=true,
					--debugPoly=true
				}),
				Pillbox2 = BoxZone:Create(vector3(328.62, -575.96, 28.8), 32.0, 34.8, {
					heading=339,
					--debugPoly=true,
					minZ=28.0,
					maxZ=32.0,
				}),
				Sandy = PolyZone:Create({
					vector2(1815.9787597656, 3656.6467285156),
					vector2(1868.4096679688, 3686.9748535156),
					vector2(1872.0925292969, 3680.1157226562),
					vector2(1819.8826904297, 3649.9819335938)
				}, {
					--minZ = 33.599998474121,
					--maxZ = 34.191120147705
				}),
				PaletoAir = CircleZone:Create(vector3(-252.88, 6321.08, 39.66), 10.0, {
					useZ=true,
					--debugPoly=true
				}),
				PillboxAir = CircleZone:Create(vector3(350.49, -588.99, 74.16), 13.0, {
					useZ=true,
					--debugPoly=true
				}),
				CayoPerico = CircleZone:Create(vector3(5115.01, -4655.2, 1.79), 52.0, {
					useZ=true,
					--debugPoly=true
				}),
				TaticalDepolymentBoat = CircleZone:Create(vector3(-793.49, -1500.35, 2.03), 21.5, {
					useZ=true,
					-- debugPoly=true
				}),
				TaticalDepolymentAir = CircleZone:Create(vector3(-732.82, -1454.3, 5.0), 36.0, {
					useZ=true,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			},
		},
		Management = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(359.27, -600.46, 43.28), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Sandy = CircleZone:Create(vector3(1840.67, 3685.82, 34.27), 2.5, {
					useZ=true,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = Config.Management.ambulance,
				requriedToClockIn = true
			}
		},
		ViewFund = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(359.27, -600.46, 43.28), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Sandy = CircleZone:Create(vector3(1840.67, 3685.82, 34.27), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.ambulance,
				requriedToClockIn = true
			}
		},
		FundManagement = {
			PolyZone = {
				Pillbox = CircleZone:Create(vector3(359.27, -600.46, 43.28), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Sandy = CircleZone:Create(vector3(1840.67, 3685.82, 34.27), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.ambulance,
				requriedToClockIn = true
			},
		},
		JobInfo = {
			type = "job",
			name = "ambulance",
			targetIndex = "nhs_level"
		}
	},
	["lost"] = {
		ClockIn = {
			PolyZone = {
				LosSantos = CircleZone:Create(vector3(954.46, -114.97, 75.01), 1.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = false
			},
		},
		ClockOut = {
			PolyZone = {
				LosSantos = CircleZone:Create(vector3(954.46, -114.97, 75.01), 1.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = false
			},
		},
		LockerRoom = {
			PolyZone = {
				LosSantos = BoxZone:Create(vector3(985.1, -92.48, 74.85), 4.8, 4.0, {
					heading=43,
					--debugPoly=true,
					minZ=73.85,
					maxZ=77.85
				})
			},
			Restriction = {
				rankRequried = 0,
				requriedToClockIn = true
			},
		},
		Management = {
			PolyZone = {
				LosSantos = CircleZone:Create(vector3(989.98, -136.08, 74.07), 2.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.lost,
				requriedToClockIn = true
			},
		},
		ViewFund = {
			PolyZone = {
				LosSantos = CircleZone:Create(vector3(989.98, -136.08, 74.07), 2.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.fundAccess.lost.View,
				requriedToClockIn = true
			},
		},
		FundManagement = {
			PolyZone = {
				LosSantos = CircleZone:Create(vector3(989.98, -136.08, 74.07), 2.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.fundAccess.lost.Admin,
				requriedToClockIn = true
			},
		},
		JobInfo = {
			type = "job",
			name = "lost",
			targetIndex = "lost_level"
		}
	},
	["gruppe6"] = {
		ClockIn = {
			PolyZone = {
				Office = CircleZone:Create(vector3(25.18, -905.47, 29.98), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = false
			},
		},
		ClockOut = {
			PolyZone = {
				Office = CircleZone:Create(vector3(25.18, -905.47, 29.98), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = false
			},
		},
		LockerRoom = {
			PolyZone = {
				Office = CircleZone:Create(vector3(18.05, -909.51, 29.98), 5.5, {
					useZ=true,
					--debugPoly=true
				}),
				Prison = CircleZone:Create(vector3(1778.5, 2547.94, 45.8), 3.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		Armory = {
			PolyZone = {
				Office = CircleZone:Create(vector3(27.72, -902.72, 33.44), 6.0, {
					useZ=true,
					--debugPoly=true
				}),
				Prison = CircleZone:Create(vector3(1778.04, 2542.8, 45.8), 3.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		VehicleRental = {
			PolyZone = {
				Office = PolyZone:Create({
					vector2(46.954196929932, -905.62951660156),
					vector2(12.159664154053, -892.82708740234),
					vector2(24.381391525269, -858.89617919922),
					vector2(60.869853973389, -872.17706298828)
				}, {
					name="car",
					--minZ = 29.962642669678,
					--maxZ = 30.705888748169
				}),
				Prison = CircleZone:Create(vector3(1749.79, 2606.26, 45.56), 16.5, {
					name="car",
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		VehicleDelete = {
			PolyZone = {
				Office = PolyZone:Create({
					vector2(46.954196929932, -905.62951660156),
					vector2(12.159664154053, -892.82708740234),
					vector2(24.381391525269, -858.89617919922),
					vector2(60.869853973389, -872.17706298828)
				}, {
					--minZ = 29.962642669678,
					--maxZ = 30.705888748169
				}),
				Prison = CircleZone:Create(vector3(1749.79, 2606.26, 45.56), 16.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1
			},
		},
		Management = {
			PolyZone = {
				Office = CircleZone:Create(vector3(24.86, -911.24, 29.99), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Prison = CircleZone:Create(vector3(1789.53, 2548.74, 45.8), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.gruppe6,
				requriedToClockIn = true
			},
		},
		ViewFund = {
			PolyZone = {
				Office = CircleZone:Create(vector3(24.86, -911.24, 29.99), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Prison = CircleZone:Create(vector3(1789.53, 2548.74, 45.8), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.gruppe6,
				requriedToClockIn = true
			},
		},
		FundManagement = {
			PolyZone = {
				Office = CircleZone:Create(vector3(24.86, -911.24, 29.99), 2.0, {
					useZ=true,
					--debugPoly=true
				}),
				Prison = CircleZone:Create(vector3(1789.53, 2548.74, 45.8), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.gruppe6,
				requriedToClockIn = true
			},
		},
		JobInfo = {
			type = "mutex",
			name = "gruppe6",
			targetIndex = "gruppe6"
		}
	},
	["weazel"] = {
		ClockIn = {
			PolyZone = {
				Office = CircleZone:Create(vector3(-593.72, -929.89, 23.87), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = false
			},
		},
		ClockOut = {
			PolyZone = {
				Office = CircleZone:Create(vector3(-593.72, -929.89, 23.87), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = false
			},
		},
		LockerRoom = {
			PolyZone = {
				Office = CircleZone:Create(vector3(-586.95, -917.82, 23.87), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		Armory = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		VehicleRental = {
			PolyZone = {
				OfficeCar = CircleZone:Create(vector3(-559.63, -899.38, 24.22), 13.0, {
					name="car",
					useZ=true,
					--debugPoly=true
				}),
				OfficeAir = CircleZone:Create(vector3(-580.45, -926.76, 36.83), 13.0, {
					name="air",
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		VehicleDelete = {
			PolyZone = {
				OfficeCar = CircleZone:Create(vector3(-559.63, -899.38, 24.22), 13.0, {
					useZ=true,
					--debugPoly=true
				}),
				OfficeAir = CircleZone:Create(vector3(-580.45, -926.76, 36.83), 13.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		Management = {
			PolyZone = {
				Office = CircleZone:Create(vector3(-583.65, -930.15, 28.16), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.weazel,
				requriedToClockIn = true
			},
		},
		ViewFund = {
			PolyZone = {
				Office = CircleZone:Create(vector3(-583.65, -930.15, 28.16), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.weazel,
				requriedToClockIn = true
			},
		},
		FundManagement = {
			PolyZone = {
				Office = CircleZone:Create(vector3(-583.65, -930.15, 28.16), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.weazel,
				requriedToClockIn = true
			},
		},
		JobInfo = {
			type = "mutex",
			name = "weazel",
			targetIndex = "weazel"
		}
	},
	["court"] = {
		ClockIn = {
			PolyZone = {
				CityHall = CircleZone:Create(vector3(-547.76, -198.7, 38.22), 90.0, {
					useZ=true,
					-- debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = false
			},
		},
		ClockOut = {
			PolyZone = {
				CityHall = CircleZone:Create(vector3(-547.76, -198.7, 38.22), 90.0, {
					useZ=true,
					-- debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = false
			},
		},
		LockerRoom = {
			PolyZone = {
				CityHallFloor1 = CircleZone:Create(vector3(-558.04, -192.27, 56.29), 2.0, {
					useZ=true,
					-- debugPoly=true
				}),
				CityHallFloor2 = CircleZone:Create(vector3(-557.94, -192.49, 60.91), 2.0, {
					useZ=true,
					-- debugPoly=true
				}),
				CityHallFloor3 = CircleZone:Create(vector3(-557.54, -192.76, 65.45), 2.5, {
					useZ=true,
					-- debugPoly=true
				}),
				CityHallFloor4 = CircleZone:Create(vector3(-558.16, -192.14, 69.97), 2.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		Armory = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		VehicleRental = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		VehicleDelete = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		Management = {
			PolyZone = {
				CityHall = CircleZone:Create(vector3(-545.45, -196.24, 69.97), 8.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management.court,
				requriedToClockIn = true
			},
		},
		ViewFund = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		FundManagement = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		JobInfo = {
			type = "mutex",
			name = "court",
			targetIndex = "court"
		}
	},
	["city"] = {
		ClockIn = {
			PolyZone = {
				CityHall = CircleZone:Create(vector3(-536.42, -180.37, 38.22), 2.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = false
			},
		},
		ClockOut = {
			PolyZone = {
				CityHall = CircleZone:Create(vector3(-536.42, -180.37, 38.22), 2.0, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = false
			},
		},
		LockerRoom = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		Armory = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		VehicleRental = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		VehicleDelete = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		Management = {
			PolyZone = {
				CityHall = CircleZone:Create(vector3(-547.88, -184.11, 38.22), 2.5, {
					useZ=true,
					--debugPoly=true
				})
			},
			Restriction = {
				rankRequried = Config.Management["city"],
				requriedToClockIn = true
			},
		},
		ViewFund = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		FundManagement = {
			PolyZone = {
			},
			Restriction = {
				rankRequried = 1,
				requriedToClockIn = true
			},
		},
		JobInfo = {
			type = "mutex",
			name = "city",
			targetIndex = "city"
		}
	},
}