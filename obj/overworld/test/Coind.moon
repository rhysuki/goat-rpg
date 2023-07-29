GameObject = require 'obj.GameObject'

class Coind extends GameObject
	from_tiled_object: (room, object) =>
		return @(room, { pos: { x: object.x, y: object.y }})

	new: (room, args = {}) =>
		super(room, args)

		@sprite = IMAGE\new_image('*/coind.png')

	draw: =>
		super!
		LG.draw(@sprite, @pos.x, @pos.y)
