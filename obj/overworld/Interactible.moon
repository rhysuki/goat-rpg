import safe_copy from require 'help.table'

Hitbox = require 'obj.overworld.Hitbox'
AreaTrigger = require 'obj.overworld.AreaTrigger'

class Interactible extends Hitbox
	new: (room, args = {}) =>
		args = safe_copy({
			interaction_world: nil
			area_trigger_extrude_size: 4
		}, args)

		super(room, args)

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

	--

	die: =>
		super!
		@area_trigger\die!
