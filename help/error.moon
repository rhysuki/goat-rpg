{
	-- prints the line the error happened in and the function definition
	-- the line was inside.
	-- @treturn string
	line_info_error_handler: (err, layer = 0) ->
		success, result = pcall(->
			path, line_number, message = err\match('(.+%.lua):(%d+): (.*)')
			line_number = tonumber(line_number)
			-- traceback starting from 3 (this pcall, errhand, then xpcall)
			traceback = debug.traceback('', 3 + layer)
			-- try to find the function this line comes from
			-- (cause apparently they don't get saved well thru xpcall?)
			defining_function_line_number = tonumber(
				traceback\match("in function <#{path}:(%d+)>")
			)

			do
				success, result = pcall(L.filesystem.getInfo, path)
				if not success
					return "error in love.filesystem.getInfo. \n#{result} \n(given error: #{err})"

			i = 0
			out = ''

			for line in L.filesystem.lines(path)
				i += 1

				if i == defining_function_line_number
					out ..= "#{i} | #{line}\n...\n"

				if (i >= (line_number - 1)) and (i <= (line_number + 1))
					out ..= "#{i} | #{line}\n"

			return "\n#{err}\n\n#{out}#{traceback}\n"
		)

		if not success then result = "error in error handling: " .. result
		return result
}