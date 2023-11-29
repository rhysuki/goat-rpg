-- object that goes to @next_room when the timer ends.
GameObject = require 'obj.GameObject'

timer = require 'lib.timer'
assert = require 'lib.bat.assert'

class Transition extends GameObject
	new: (
		room,
		@next_room
		@duration = 1,
		@is_reversed = false,
		@colour = 'black'
	) =>
		super(room)

		@timer = timer!

		@timer\after(@duration, -> @finish!)

	update: (dt) =>
		super(dt)
		@timer\update(dt)

	--

	finish: =>
		if @next_room then STAGE\goto(@next_room)
