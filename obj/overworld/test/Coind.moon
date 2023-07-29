GameObject = require 'obj.GameObject'

class Coind extends GameObject
	new: (room, args = {}) =>
		super(room, args)

		@sprite = IMAGE\new_image('*/coind.png')

	draw: =>
		super!
		LG.draw(@sprite, @pos.x, @pos.y)
