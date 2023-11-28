GameObject = require 'obj.GameObject'

class Coind extends GameObject
	new: (room) =>
		super(room)
		@sprite = IMAGE\new_image('*/coind.png')

	draw: =>
		super!
		LG.draw(@sprite, @x, @y)
