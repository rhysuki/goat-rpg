import safe_copy from require 'help.table'

Hitbox = require 'obj.overworld.Hitbox'
AreaTrigger = require 'obj.overworld.AreaTrigger'

class Interactible extends Hitbox
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.interaction_world = room.worlds[object.properties.interaction_world] or
			room.worlds.interaction

		out.pubsub = room.pubsubs[object.properties.pubsub]
		out.pubsub_event = object.properties.pubsub_event

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			interaction_world: nil
			area_trigger_extrude_size: 4

			pubsub: nil
			pubsub_event: 'empty'
		}, args)

		super(room, args)

		@pubsub = args.pubsub
		@pubsub_event = args.pubsub_event

		es = args.area_trigger_extrude_size

		@area_trigger = @room\add(AreaTrigger, {
			pos: {
				x: @pos.x - es
				y: @pos.y - es
				w: @pos.w + (es * 2)
				h: @pos.h + (es * 2)
			}

			world: args.interaction_world
		})

		-- TODO: should this be an official feature of hitbox?
		@area_trigger.context = @

	--

	activate: =>
		@pubsub\publish(@pubsub_event, @)

	die: =>
		super!
		@area_trigger\die!
