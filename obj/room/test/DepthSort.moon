import colour from require 'help.graphics'
import safe_copy from require 'help.table'

Room = require 'obj.Room'
GameObject = require 'obj.GameObject'

circle = IMAGE\new_image('*/circle.png')

class Circle extends GameObject
	new: (room, args = {}) =>
		args = safe_copy({
			colour: nil
		}, args)

		super(room, args)

		@colour = args.colour
		@sprite = circle
		-- the y offset between @pos.y and the "foot" of this object.
		@depth_height = 32

	draw: =>
		super!
		colour(@colour)
		LG.draw(@sprite, @pos.x, @pos.y)
		colour!

class Overworld extends Room
	new: =>
		super!

		@add(Circle, { colour: 'red', pos: { x: 50, y: 50 }})
