Hitbox = require 'obj.overworld.Hitbox'

baton = require 'lib.baton'

class Player extends Hitbox
	new: (room, args = {}) =>
		super(room, args)

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

	draw: =>
		super!
		LG.print(':3', @pos.x, @pos.y)
