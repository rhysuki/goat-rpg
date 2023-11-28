-- Hitbox without collision. constantly updates its own @cols and has
-- funcs for enter/stay/exit.

Hitbox = require 'obj.overworld.Hitbox'

class AreaTrigger extends Hitbox
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		-- goes to interaction instead of collision by default
		out.world = room.worlds[object.properties.world] or
			room.worlds.interaction

		return out

	new: (room, world) =>
		super(room, world)

		@current_others = {}
		@last_others = {}

		@filter = -> 'cross'
		@debug_colour = 'green'

	update: (dt) =>
		super(dt)

		-- what the fuck is any of this
		@last_others = { col.other, true for col in *@cols }
		_, _, @cols = @world\check(@, @x, @y, @filter)
		@current_others = { col.other, true for col in *@cols }

		for col in *@cols
			if (not @last_others[col.other]) and (@current_others[col.other])
				@on_enter(col.other)

			@on_stay(col.other)

		for other in pairs @last_others
			if not @current_others[other] then @on_exit(other)

	--

	on_enter: (other) =>

	on_stay: (other) =>

	on_exit: (other) =>
