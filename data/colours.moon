-- these colours have 1 as their default alpha to be able to be used
-- straight with setColor/unpack

{
	white: { 1, 1, 1, 1 }
	black: { 0, 0, 0, 1 }
	grey: { 0.5, 0.5, 0.5, 1 }

	red: { 1, 0, 0, 1 }
	green: { 0, 1, 0, 1 }
	blue: { 0, 0, 1, 1 }

	yellow: { 1, 1, 0, 1 }
	cyan: { 0, 1, 1, 1 }
	magenta: { 1, 0, 1, 1 }

	test_red: { 1, 0.5, 0.5, 1 }
	test_green: { 0.5, 1, 0.5, 1 }
	test_blue: { 0.5, 0.5, 1, 1 }

	-- bubblegum16 palette
	b_black: { L.math.colorFromBytes(22, 23, 26, 255) }
	b_maroon: { L.math.colorFromBytes(127, 6, 34, 255) }
	b_red: { L.math.colorFromBytes(214, 36, 17, 255) }
	b_orange: { L.math.colorFromBytes(255, 132, 38, 255) }
	b_yellow: { L.math.colorFromBytes(255, 209, 0, 255) }
	b_white: { L.math.colorFromBytes(250, 253, 255, 255) }
	b_peach: { L.math.colorFromBytes(255, 128, 164, 255) }
	b_pink: { L.math.colorFromBytes(255, 38, 116, 255) }
	b_wine: { L.math.colorFromBytes(148, 33, 106, 255) }
	b_purple: { L.math.colorFromBytes(67, 0, 103, 255) }
	b_navy: { L.math.colorFromBytes(35, 73, 117, 255) }
	b_light_blue: { L.math.colorFromBytes(104, 174, 212, 255) }
	b_lime: { L.math.colorFromBytes(191, 255, 60, 255) }
	b_green: { L.math.colorFromBytes(16, 210, 117, 255) }
	b_blue: { L.math.colorFromBytes(0, 120, 153, 255) }
	b_dark_blue: { L.math.colorFromBytes(0, 40, 89, 255) }
}
