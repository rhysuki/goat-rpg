Room = require 'obj.room.Room'

class extends Room
	new: (args = {}) =>
		super(args)

	draw_in_camera: =>
		super!

		LG.print("an empty room...")
