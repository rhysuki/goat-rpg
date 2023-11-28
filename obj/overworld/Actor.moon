-- mainly, an object with a hitbox and sprite that exists in the map.
GameObject = require 'obj.GameObject'

class Actor extends GameObject
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		with object.properties
			out.actor_name = .actor_name
			out.world = room.worlds[.world] or room.worlds.collision
			out.interaction_world = room.worlds[.interaction_world] or
				room.worlds.interaction

		return out

	new: (room, @sprite, @hitbox, @area_trigger) =>
		super(room)

		@area_trigger\set_dimensions(@hitbox.width + 6, @hitbox.height + 6)

		@hitbox\set_position(@x, @y)
		@area_trigger\set_position(@x - 3, @y - 3)
		@move_sprite!

	update: (dt) =>
		super(dt)
		@move_hitbox!
		@move_area_trigger!
		@move_sprite!

	--

	die: =>
		super!
		@sprite\die!
		@hitbox\die!
		@area_trigger\die!

	-- snaps position to x, y without checking collisions.
	set_position: (x, y) =>
		super(x, y)

		@hitbox\set_position(@x, @y)
		@move_area_trigger!
		@move_sprite!

	move_hitbox: =>
		@hitbox\move_to(@x, @y)

	move_area_trigger: =>
		@area_trigger\move_to(@x - 3, @y - 3)

	-- the sprite is attached to the middle of the bottom of the hitbox.
	move_sprite: =>
		x, y, w, h = @sprite\get_size!

		@sprite.x = @hitbox.x + (@hitbox.width / 2) - (w / 2)
		@sprite.y = @hitbox.y + @hitbox.height - h
