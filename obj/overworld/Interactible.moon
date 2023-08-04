-- an AreaTrigger that emits an event when interacted with.

import safe_copy from require 'help.table'

Hitbox = require 'obj.overworld.Hitbox'
AreaTrigger = require 'obj.overworld.AreaTrigger'

class Interactible extends AreaTrigger
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.world = room.worlds[object.properties.world] or
			room.worlds.interaction

		out.pubsub = room.pubsubs[object.properties.pubsub]
		out.pubsub_event = object.properties.pubsub_event

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			pubsub: nil
			pubsub_event: 'empty'
		}, args)

		super(room, args)

		@pubsub = args.pubsub
		@pubsub_event = args.pubsub_event

	--

	activate: =>
		@pubsub\publish(@pubsub_event, @)

	die: =>
		super!
		@area_trigger\die!
