import is from require 'help.type'
import safe_copy from require 'help.table'

Player = require 'obj.overworld.Player'
AreaTrigger = require 'obj.overworld.AreaTrigger'
Overworld = require 'obj.room.Overworld'

class Exit extends AreaTrigger
	tiled_object_to_args: (room, object) =>
		out = super(room, object)
		out.target_room_name = object.properties.target_room_name
		return out

	new: (room, args = {}) =>
		args = safe_copy({
			target_room_name: ''
		}, args)

		super(room, args)

		@target_room_name = args.target_room_name

	--

	on_enter: (other) =>
		if not other.context or not is(other.context, Player)
			return

		STAGE\goto(Overworld(@target_room_name))
