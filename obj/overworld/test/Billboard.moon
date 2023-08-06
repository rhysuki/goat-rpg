import safe_copy from require 'help.table'
import colour from require 'help.graphics'

GameObject = require 'obj.GameObject'

class Billboard extends GameObject
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.pubsub = room.pubsubs.test
		out.pubsub_event = object.properties.pubsub_event

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			pubsub: nil
			pubsub_event: ''
		}, args)

		super(room, args)

		@pubsub = args.pubsub
		@pubsub_event = args.pubsub_event
		@is_on = false

		@pubsub\subscribe(@pubsub_event, -> @is_on = not @is_on)

	draw: =>
		if @is_on then colour('b_green')
		else colour('b_red')
		LG.print("I AM #{@is_on and 'ON' or 'OFF'}!", @pos.x, @pos.y)
		colour!
