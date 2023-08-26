import colour from require 'help.graphics'
import clamp, distance, smoothstep from require 'lib.bat.mathx'

Room = require 'obj.room.Room'

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

		@source = L.audio.newSource('data/snd/test/shake_it_bololo.ogg', 'stream')
		@sound = ripple.newSound(@source)
		@instance = @sound\play!
		@instance.volume = 0

		@x = 0
		@y = 0
		@r = 50

		@sound_x = SCREEN_WIDTH / 2
		@sound_y = SCREEN_HEIGHT / 2
		@sound_r = 100
		@sound_volume = 0.5

	update: (dt) =>
		super(dt)
		@input\update(dt)

		move_x, move_y = @input\get('move')
		@x += move_x
		@y += move_y

		volume = clamp((1 - (distance(@x, @y, @sound_x, @sound_y) / @sound_r)), 0, 1)
		@instance.volume = smoothstep(volume) * @sound_volume

	draw_in_camera: =>
		super!

		colour('b_pink')
		LG.circle('line', @sound_x, @sound_y, @sound_r)
		LG.circle('line', @sound_x, @sound_y, 3)
		colour!

		LG.print("an empty room...")
		LG.circle('line', @x, @y, 5)
