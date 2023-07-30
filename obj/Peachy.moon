-- a peachy instance, but it's a gameobject.

import safe_copy from require 'help.table'
import asterisk_complete from require 'help.string'

GameObject = require 'obj.GameObject'

peachy = require 'lib.peachy'

-- TODO: replace Animation's innards with an instance of this
-- TODO: make @activate! toggle this state
-- TODO: link this to a pubsub
class Peachy extends GameObject
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.path = object.properties.path
		out.initial_tag = object.properties.initial_tag

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			-- path without extensions!
			path: nil
			initial_tag: nil

			pos: {
				x: 0
				y: 0
				r: 0
				sx: 1
				sy: 1
				ox: 0
				oy: 0
			}
		}, args)

		super(room, args)

		json_path, image_path = @get_paths(args.path)
		@peachy = peachy.new(json_path, IMAGE\new_image(image_path), args.initial_tag)

		@is_looping = true

		@peachy\onLoop(-> @on_loop!)

	update: (dt) =>
		super(dt)
		@peachy\update(dt)

	draw: =>
		with @pos
			@peachy\draw(.x, .y, .r, .sx, .sy, .ox, .oy)

	--

	on_loop: =>
		if not @is_looping then @peachy\stop(true)

	play_tag: (name) =>
		@set_tag(name)
		@peachy\play!

	set_tag: (name) =>
		@peachy\setTag(name)

	set_frame: (frame_index) =>
		@peachy\setFrame(frame_index)

	--- pass in a path without extensions, eg 'path/to/example'
	-- @treturn string, string
	get_paths: (path) =>
		path = asterisk_complete(path, 'data/img')
		return path .. '.json', path .. '.png'

	-- @treturn int
	get_frame: =>
		return @peachy.frameIndex
