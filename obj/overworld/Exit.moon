import is from require 'help.type'
import safe_copy from require 'help.table'

EmptyRoom = require 'obj.room.test.Empty'
Player = require 'obj.overworld.Player'
AreaTrigger = require 'obj.overworld.AreaTrigger'
Overworld = require 'obj.room.Overworld'
CircleTransition = require 'obj.room.transition.CircleTransition'

class Exit extends AreaTrigger
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.target_room_name = object.properties.target_room_name
		out.transition_name = object.properties.transition_name
		out.direction = object.properties.direction
		out.exit_id = object.properties.exit_id
		out.target_exit_id = object.properties.target_exit_id

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			target_room_name: ''
			transition_name: ''
			direction: ''

			exit_id: nil
			target_exit_id: nil
		}, args)

		super(room, args)

		@target_room_name = args.target_room_name
		@transition_name = args.transition_name
		@direction = args.direction
		@exit_id = args.exit_id
		@target_exit_id = args.target_exit_id

	--

	on_enter: (other) =>
		if not other.context or not is(other.context, Player)
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

	move_player_to_this: (player) =>
		-- x, y = player\get_direction_axis(player\get_opposite_direction(@direction))
		player\set_position(@pos.x - 16, @pos.y)
