{
	--- checks if given_class is or extends target_class.
	-- can be given an object instance.
	-- @treturn bool
	is: (given_class, target_class) ->
		if (type(given_class) != 'table') or (type(target_class) != 'table')
			error("expected table/table, got #{type(given_class)}/#{type(target_class)}")

		-- was given an instance
		if not given_class.__base
			given_class = given_class.__class

		if not target_class.__base
			target_class = target_class.__class

		while true
			if given_class == target_class
				return true

			if given_class.__parent
				given_class = given_class.__parent
				continue

			return false
}