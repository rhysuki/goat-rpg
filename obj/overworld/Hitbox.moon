import safe_copy from require 'help.table'
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

		@debug_colour = 'white'
		@debug_alpha = 0.5
		@cols = {}

		@world\add(@, @x, @y, @width, @height)

	draw: =>
		if DEBUG_FLAGS.show_hitboxes
			colour(@debug_colour, @debug_alpha)
			LG.rectangle('line', @world\getRect(@))
			colour!

	--

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

	-- @treturn tab
	check_collisions: =>
		_, _, cols = @world\check(@, @x, @y)
		return cols
