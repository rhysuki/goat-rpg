-- mainly, an object with a hitbox and sprite that exists in the map.
import safe_copy from require 'help.table'

GameObject = require 'obj.GameObject'
Peachy = require 'obj.Peachy'
Hitbox = require 'obj.overworld.Hitbox'

actors = require 'data.actors'

class Actor extends GameObject
	new: (room, args = {}) =>
		args = safe_copy({
			actor_name: ''
			world: nil
		}, args)

		super(room, args)

		with actors[args.actor_name]
			@sprite = @room\add(Peachy, {
				path: .sprite.path
				initial_tag: .sprite.initial_tag
			})

			@hitbox = @room\add(Hitbox, {
				pos: { w: .hitbox.pos.w, h: .hitbox.pos.h }
				world: args.world
			})

	update: (dt) =>
		super(dt)
		@move_hitbox!
		@move_sprite!

	--

	move_hitbox: =>
		@hitbox\move_to(@pos.x, @pos.y)

	-- the sprite's attached to the middle of the bottom of the hitbox.
	move_sprite: =>
		x, y, w, h = @sprite\get_size!

		@sprite.pos.x = @hitbox.pos.x + (@hitbox.pos.w / 2) - (w / 2)
		@sprite.pos.y = @hitbox.pos.y + @hitbox.pos.h - h
