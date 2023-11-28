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

	new: (room, args = {}) =>
		args = safe_copy({
			pos: {
				x: 0
				y: 0
				w: 16
				h: 16
			}

			world: nil
			filter: -> 'slide'

			context: nil
		}, args)

		super(room, args)

		@world = args.world
		@filter = args.filter
		-- the object this belongs to, if any.
		@context = args.context

		@debug_colour = 'white'
		@debug_alpha = 0.5
		@cols = {}

		@world\add(@, @pos.x, @pos.y, @pos.w, @pos.h)

	draw: =>
		if DEBUG_FLAGS.show_hitboxes
			colour(@debug_colour, @debug_alpha)
			LG.rectangle('line', @pos.x, @pos.y, @pos.w, @pos.h)
			colour!

	--

	move_to: (x, y) =>
		@pos.x, @pos.y, cols = @world\move(@, x, y, @filter)
		@cols = cols

	set_position: (x, y) =>
		@pos.x, @pos.y = x, y
		@world\update(@, @pos.x, @pos.y)

	set_dimensions: (w, h) =>
		@pos.w, @pos.h = w, h
		@world\update(@, @pos.x, @pos.y, @pos.w, @pos.h)

	die: =>
		super!
		@world\remove(@)
