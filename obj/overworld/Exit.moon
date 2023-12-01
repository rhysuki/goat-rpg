import is from require 'help.type'

Overworld = require 'obj.room.Overworld'
EmptyRoom = require 'obj.room.test.Empty'
CircleTransition = require 'obj.room.transition.CircleTransition'
Player = require 'obj.overworld.Player'
Hitbox = require 'obj.overworld.Hitbox'

-- TODO: walking animation and right positioning
class Exit extends Hitbox
	from_tiled_object: (room, object) =>
		with object.properties
			return @(
				room
				room.worlds.interaction
				.exit_id
				.target_exit_id
				.target_room_name
				.direction
				.transition_name
			)

	new: (room, world, @exit_id, @target_exit_id, @target_room_name, @direction, @transition_name) =>
		super(room, world)
		@is_exit_enabled = true

	--

	on_enter: (other) =>
		super(other)

		if not other.context or not is(other.context, Player) or not @is_exit_enabled
			return

		player = other.context
		player.is_input_enabled = false
		player\set_move(player\get_direction_axis(@direction))

		next_room = Overworld({
			map_name: @target_room_name
			transition_name: @transition_name
			target_exit_id: @target_exit_id
		})

		transition = @room\add_transition('circle')
		transition.next_room = next_room

	on_exit: (other) =>
		super(other)

		if not other.context or not is(other.context, Player)
			return

		-- if the player's coming out of this exit, reenable it and
		-- the player's input.
		-- something interesting: since this is on_exit and not on_enter,
		-- the player can teeeechnically start outside this exit, walk
		-- until they enter, then keep walking until they exit again (and
		-- THEN this code triggers).
		if not @is_exit_enabled
			@is_exit_enabled = true

			player = other.context
			player.is_input_enabled = true

	move_player_to_this: (player) =>
		-- player walks in the direction opposite to @direction.
		x, y = player\get_direction_axis(player\get_opposite_direction(@direction))

		player.is_input_enabled = false
		player\set_move(x, y)
		player\set_position(@get_player_exit_pos!)

		@is_exit_enabled = false

	-- get the pos corresponding with the edge the player will cross when
	-- they're exiting.
	-- @treturn number, number
	get_player_exit_pos: (dir = @direction) =>
		offset = 50
		center_x = @x + (@width / 2) - 6
		center_y = @y + (@height / 2)

		switch dir
			when 'right' then return @x + offset, center_y
			when 'left' then return @x + @width - offset, center_y
			when 'down' then return center_x, @y + offset
			when 'up' then return center_x, @y + @height - offset
