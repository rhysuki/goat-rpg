{
	-- @treturn string
	starts: (str, search) ->
		if type(search) == 'table'
			error("argument #2 must be a string, got #{type search}")

		return str\sub(1, #search) == search

	--- turns a require path into a regular path.
	-- 'data.help' -> 'data/help.lua'
	-- @treturn string
	to_file_path: (require_path) ->
		return require_path\gsub('%.', '/') .. '.lua'

	--- turns a regular path into a require path.
	-- 'data/help.lua' -> 'data.help'
	-- @treturn string
	to_require_path: (file_path) ->
		if file_path\find('%.')
			file_path = file_path\sub(1, file_path\find('%.') - 1)

		return file_path\gsub('%/', '.')

	--- if the string starts with a *, replaces it with the given default.
	-- @treturn string
	asterisk_complete: (str, default) ->
		if not default then error("default replacement required")
		import starts from require 'help.string'

		if starts(str, '*')
			str = default .. str\sub(2, -1)

		return str
}
