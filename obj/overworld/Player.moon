Hitbox = require 'obj.overworld.Hitbox'

class Player extends Hitbox
	new: (room, args = {}) =>
		super(room, args)

	update: (dt) =>
		super(dt)

	draw: =>
		super!
		LG.print(':3', @pos.x, @pos.y)
