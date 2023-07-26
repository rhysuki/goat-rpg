colours = require 'data.colours'

{
	-- like lg.setColor, but takes from data.colours if passed a string.
	-- if passed a string, the 2nd arg is the alpha applied to the
	-- respective data.colours colour.
	-- if passed no args, it defaults to (1, 1, 1, 1).
	-- mind the U
	colour: (...) ->
		first = select(1, ...)

		switch type(first)
			when 'nil'
				LG.setColor(1, 1, 1, 1)
			when 'string'
				{ r, g, b } = colours[first]
				-- use the passed alpha if it exists or 1 by default
				a = select(2, ...) or 1
				LG.setColor(r, g, b, a)
			else
				LG.setColor(...)
}