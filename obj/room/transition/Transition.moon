-- object that goes to @next_room when the timer ends.
import safe_copy from require 'help.table'

GameObject = require 'obj.GameObject'

timer = require 'lib.timer'
assert = require 'lib.bat.assert'

class Transition extends GameObject
	new: (room, args = {}) =>
		args = safe_copy({
			next_room: nil

			is_reversed: false
			duration: 1
			colour: 'black'
		}, args)

		super(room, args)

		@next_room = assert(args.next_room, "no room provided for this transition.")
		@is_reversed = args.is_reversed
		@duration = args.duration
		@colour = args.colour

		@timer = timer!

		@timer\after(@duration, -> @finish!)

	update: (dt) =>
		super(dt)
		@timer\update(dt)

	--

	finish: =>
		if @next_room then STAGE\goto(@next_room)
