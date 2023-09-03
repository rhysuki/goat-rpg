import colour from require 'help.graphics'
import clamp, distance, smoothstep from require 'lib.bat.mathx'

Room = require 'obj.room.Room'
Source = require 'obj.audio.Source'

baton = require 'lib.baton'
ripple = require 'lib.ripple'

class extends Room
	new: (args = {}) =>
		super(args)

	update: (dt) =>
		super(dt)

	draw_in_camera: =>
		super!

		LG.print("an empty room...")
