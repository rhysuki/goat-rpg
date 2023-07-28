Room = require 'obj.Room'

goat = IMAGE\new_image('goat.png')
bump = require 'lib.bump'

class Overworld extends Room
	new: =>
		super!

		@world = bump.newWorld!

	draw_in_camera: =>
		super!
		LG.print("hello world!", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
		LG.draw(goat, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 16)
