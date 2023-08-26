-- just recursively runs every file/folder inside of spec.
import to_require_path from require 'help.string'

recursive_require = (folder) ->
	for item in *L.filesystem.getDirectoryItems(folder)
		path = folder .. '/' .. item
		info = L.filesystem.getInfo(path)

		if info.type == 'directory'
			recursive_require(path)

		elseif (info.type == 'file') and (item\sub(-4, -1) == '.lua')
			require to_require_path(path)

require('lib.lust').is_printing_enabled = false
recursive_require('spec')

-- world's hackiest code to make the divisor bar be a percentage of
-- passes vs errors
import passes, errors, error_messages from require 'lib.lust'
total = passes + errors
line_size = 25

ok_size = math.floor((passes / total) * line_size)
err_size = math.ceil(errors / total * line_size)

bar = string.rep("+", ok_size) .. string.rep("-", err_size)

print("#{bar}\nOK: #{passes}, ERR: #{errors}")

if #error_messages != 0
	print!
	print v for k,v in pairs error_messages
