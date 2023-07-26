Room = require 'obj.Room'

class Overworld extends Room
	draw_in_camera: =>
		super!
		LG.print("hello world!", SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
