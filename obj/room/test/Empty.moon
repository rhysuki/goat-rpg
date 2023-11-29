import colour from require 'help.graphics'
import clamp, distance, smoothstep from require 'lib.bat.mathx'

Room = require 'obj.room.Room'
Source = require 'obj.audio.Source'

baton = require 'lib.baton'
bump = require 'lib.bump'
pubsub = require 'lib.bat.pubsub'
ripple = require 'lib.ripple'

class extends Room
	new: =>
		super!

	update: (dt) =>
		super(dt)

	draw_in_camera: =>
		super!

		LG.print("an empty room...")
