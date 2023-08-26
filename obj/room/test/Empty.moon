import colour from require 'help.graphics'
import clamp, distance, smoothstep from require 'lib.bat.mathx'

Room = require 'obj.room.Room'
Source = require 'obj.audio.Source'

baton = require 'lib.baton'
ripple = require 'lib.ripple'

class extends Room
	new: (args = {}) =>
		super(args)

		@input = baton.new({
			controls: {
				left: { 'key:left', 'axis:leftx-' }
				right: { 'key:right', 'axis:leftx+' }
				up: { 'key:up', 'axis:lefty-' }
				down: { 'key:down', 'axis:lefty+' }

				interact: { 'key:z' }
			}

			pairs: {
				move: { 'left', 'right', 'up', 'down' }
			}
		})

	update: (dt) =>
		super(dt)

	draw_in_camera: =>
		super!

		LG.print("an empty room...")
