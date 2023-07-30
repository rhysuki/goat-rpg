-- Hitbox without collision. constantly updates its own @cols and has
-- funcs for enter/stay/exit.

Hitbox = require 'obj.Hitbox'

class AreaTrigger extends Hitbox
	new: (room, world, args = {}) =>
		super(room, world, args)

		@current_others = {}
		@last_others = {}

		@filter = -> 'cross'
		@debug_colour = 'green'

	update: (dt) =>
		super(dt)

		-- what the fuck is any of this
		@last_others = { col.other, true for col in *@cols }
		_, _, @cols = @world\check(@, @pos.x, @pos.y, @filter)
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
