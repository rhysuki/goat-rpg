-- AreaTrigger that goes inside an Actor.
import safe_copy from require 'help.table'

AreaTrigger = require 'obj.overworld.AreaTrigger'

class ActorAreaTrigger extends AreaTrigger
	new: (room, args = {}) =>
		args = safe_copy({
			parent: nil
		}, args)

		super(room, args)

		@parent = args.parent

	on_enter: (other) =>
		super(other)
		@parent\on_area_trigger_enter(other)

	on_stay: (other) =>
		super(other)
		@parent\on_area_trigger_stay(other)

	on_exit: (other) =>
		super(other)
		@parent\on_area_trigger_exit(other)
