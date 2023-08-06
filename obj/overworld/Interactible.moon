-- an AreaTrigger that emits an event when interacted with.

import safe_copy from require 'help.table'

Actor = require 'obj.overworld.Actor'

class Interactible extends Actor
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.pubsub = room.pubsubs[object.properties.pubsub]
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

	--

	activate: =>
		@pubsub\publish(@pubsub_event, @)
