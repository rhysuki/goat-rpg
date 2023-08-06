-- an AreaTrigger that emits an event when interacted with.

import safe_copy from require 'help.table'

Actor = require 'obj.overworld.Actor'
AreaTrigger = require 'obj.overworld.AreaTrigger'

class Interactible extends Actor
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.interaction_world = room.worlds[object.properties.world] or
			room.worlds.interaction

		out.pubsub = room.pubsubs[object.properties.pubsub]
		out.pubsub_event = object.properties.pubsub_event

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			interaction_world: nil

			pubsub: nil
			pubsub_event: ''
		}, args)

		super(room, args)

		@pubsub = args.pubsub
		@pubsub_event = args.pubsub_event

		@area_trigger = @room\add(AreaTrigger, {
			pos: { w: @hitbox.pos.w + 6, h: @hitbox.pos.h + 6 }
			world: args.interaction_world
		})

		@area_trigger.world\update(@area_trigger, @pos.x - 3, @pos.y - 3)

		@area_trigger.context = @

	update: (dt) =>
		super(dt)
		@area_trigger\move_to(@pos.x - 3, @pos.y - 3)

	--

	die: =>
		super!
		@area_trigger\die!

	activate: =>
		@pubsub\publish(@pubsub_event, @)

