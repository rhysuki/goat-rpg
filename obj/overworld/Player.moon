Hitbox = require 'obj.overworld.Hitbox'

baton = require 'lib.baton'

class Player extends Hitbox
	new: (room, args = {}) =>
		super(room, args)

		-- how many pixels to move per frame
		@speed = 1

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
		@input\update!

		x_move, y_move = @input\get('move')

		@move_to(
			@pos.x + (x_move * @speed * dt * 60)
			@pos.y + (y_move * @speed * dt * 60)
		)

	draw: =>
		super!
		LG.print(':3', @pos.x, @pos.y)
