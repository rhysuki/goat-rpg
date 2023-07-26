{
	--- rounds n to the nearest integer. 0.5 rounds to 1.
	-- @treturn number
	round: (n) -> math.floor(n + 0.5)

	--- clamps n to be between min and max.
	-- @tparam number max
	clamp: (n, min, max) -> math.max(min, math.min(max, n))

	--- normalised sine.
	-- @treturn number
	n_sin: (n, speed = 1) ->
		return (math.sin(n * speed) + 1) / 2

	--- normalised cosine.
	-- @see NSin
	n_cos: (n, speed = 1) ->
		return (math.cos(n * speed) + 1) / 2

	--- truncates n to precision decimal points.
	-- @treturn number
	truncate: (n, precision = 0) ->
		decimals = 10 ^ precision
		return math.floor(n * decimals) / decimals
}