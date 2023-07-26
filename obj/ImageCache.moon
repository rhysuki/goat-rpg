-- world's shittiest image cache that used to be a module
-- if the given path starts with *, it completes it to be inside data/img:
-- "*/test.png" -> "data/img/test.png"

import asterisk_complete from require 'help.string'

class ImageCache
	new: =>
		@cache = setmetatable({}, { __mode: 'v' })

	new_image: (path, ...) =>
		path = asterisk_complete(path, 'data/img')

		if not @cache[path]
			@cache[path] = LG.newImage(path, ...)

		return @cache[path]
