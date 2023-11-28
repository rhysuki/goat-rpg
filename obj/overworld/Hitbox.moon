import colour from require 'help.graphics'

GameObject = require 'obj.GameObject'

class Hitbox extends GameObject
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.pos.w = object.width
		out.pos.h = object.height

		out.world = room.worlds[object.properties.world] or
			room.worlds.collision

		return out

	new: (room, @world) =>
		super(room)

		@width = 16
		@height = 16

		@filter = -> 'slide'
		@debug_colour = 'white'
		@debug_alpha = 0.5
		@cols = {}

		@current_others = {}
		@last_others = {}

		@world\add(@, @x, @y, @width, @height)

	update: (dt) =>
		@last_others = { col.other, true for col in *@cols }
		@cols = @check_collisions!
		@current_others = { col.other, true for col in *@cols }

		for col in *@cols
			if (not @last_others[col.other]) and (@current_others[col.other])
				@on_enter(col.other)

			@on_stay(col.other)

		for other in pairs @last_others
			if not @current_others[other] then @on_exit(other)

	draw: =>
		if DEBUG_FLAGS.show_hitboxes
			colour(@debug_colour, @debug_alpha)
			LG.rectangle('line', @world\getRect(@))
			colour!

	--

	on_enter: (other) =>

	on_stay: (other) =>

	on_exit: (other) =>

	set_position: (x, y) =>
		super(x, y)
		@world\update(@, @x, @y)

	set_dimensions: (w, h) =>
		@width, @height = w, h
		@world\update(@, @x, @y, @width, @height)

	move_to: (x, y) =>
		@x, @y, cols = @world\move(@, x, y, @filter)
		@cols = cols

	die: =>
		super!
		@world\remove(@)

	set_filter: (str) =>
		@filter = -> str

	-- @treturn tab
	check_collisions: =>
		_, _, cols = @world\check(@, @x, @y, @filter)
		return cols
