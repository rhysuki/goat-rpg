-- a peachy instance, but it's a gameobject.
import asterisk_complete from require 'help.string'
import colour from require 'help.graphics'

GameObject = require 'obj.GameObject'

peachy = require 'lib.peachy'

-- TODO: replace Animation's innards with an instance of this
-- TODO: make @activate! toggle this state
-- TODO: link this to a pubsub
class Peachy extends GameObject
	from_tiled_object: (room, object) =>
		with object.properties
			return @(room, .path, .initial_tag)

	-- path is without extensions!!
	new: (room, path, initial_tag) =>
		super(room)

		json_path, image_path = @get_paths(path)
		@peachy = peachy.new(json_path, IMAGE\new_image(image_path), initial_tag)

		@is_looping = true
		@is_auto_draw_depth_enabled = true
		@tag_queue = {}

		@peachy\onLoop(-> @on_loop!)

	update: (dt) =>
		super(dt)
		@peachy\update(dt)
		if @is_auto_draw_depth_enabled
			_, _, _, quad_height = @peachy.frame.quad\getViewport!
			@depth_height = quad_height

	draw: =>
		@peachy\draw(@x, @y, 0, 1, 1, 0, 0)

		if DEBUG_FLAGS.show_positions
			colour('b_green')
			LG.print(@draw_depth, @x - 3, @y - 12)
			colour!

	--

	on_loop: =>
		if #@tag_queue > 0
			@pop_tag_queue!
			return

		if not @is_looping then @peachy\stop(true)

	play_tag: (name) =>
		@set_tag(name)
		@peachy\play!

	set_tag: (name) =>
		@peachy\setTag(name)

	set_frame: (frame_index) =>
		@peachy\setFrame(frame_index)

	-- plays the given tags in sequence one after another.
	queue_tags: (...) =>
		-- for i = 1, select('#', ...)
		-- 	INSERT(@tag_queue, select(i, ...)

		tags = { ... }

		for tag in *tags
			INSERT(@tag_queue, tag)

		@pop_tag_queue!

	pop_tag_queue: =>
		-- print table.remove(@tag_queue, 1)
		@play_tag(table.remove(@tag_queue, 1))

	--- pass in a path without extensions, eg 'path/to/example'
	-- @treturn string, string
	get_paths: (path) =>
		path = asterisk_complete(path, 'data/img')
		return path .. '.json', path .. '.png'

	-- @treturn int
	get_frame: =>
		return @peachy.frameIndex

	-- size of the current frame. or um, I guess all frames?
	-- @treturn int, int, int, int
	get_size: =>
		return @peachy.frame.quad\getViewport!
