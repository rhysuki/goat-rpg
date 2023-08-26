{
	--- copies all the keys from source to target. modifies target.
	unpack_keys_to: (source, target, keys) ->
		for key in *keys
			target[key] = source[key]

	--- checks if a table's completely empty.
	-- @treturn bool
	is_empty: (t) ->
		return next(t) == nil

	--- returns a new table with all values of t copied over.
	-- if reference_table is provided, it won't copy values that already
	-- exist in it.
	-- do mind: values explicitly set as nil work exactly the same as
	-- non existing values.
	-- @treturn tab
	copy: (t, reference_table = {}) ->
		import is_empty, copy from require 'help.table'
		out = reference_table

		for k, v in pairs t
			reference_value = reference_table[k]

			-- skips if it already exists, unless it's a table, in which
			-- case it is the new reference_table
			if (reference_value != nil) and (type(reference_value) != 'table') then continue

			if (type(v) == 'table') and (not is_empty(v))
				-- replaces the reference to the table with a new copy of it(?)
				v = copy(v, reference_value)

			out[k] = v

		return out

	--- copy but yells at you.
	-- @treturn tab
	safe_copy: (t, reference_table) ->
		import copy from require 'help.table'

		if (not t) or (not reference_table)
			error('please pass in a 2nd table to safe_copy. idiot.')

		copy(t, reference_table)

	--- filters the table to only values that return true with fn.
	-- !!! PRESERVES ARRAY POSITIONS! a table like { 1, 2, 3, 4 }, filtered
	-- for evens, looks like { [2]: 2, [4]: 4 }. careful.
	-- returns a new table.
	-- @treturn tab
	filter: (t, fn) ->
		out = {}

		for k, v in pairs t
			if fn(v, k) then out[k] = v

		return out

	--- numerical filter. like filter, but works with arrays.
	-- instead of preserving keys, it inserts to the output array.
	-- @treturn tab
	ifilter: (t, fn) ->
		out = {}

		for i, v in ipairs t
			if fn(v, i) then INSERT(out, v)

		return out

	--- reverse iterator, ipairs but backwards.
	-- returns i, array[i] for each item in the array starting from
	-- the last and going to the first
	-- @treturn func an iterator
	r_ipairs: (array) ->
		i = #array + 1

		return ->
			i -= 1
			if array[i] then return i, array[i]
}
