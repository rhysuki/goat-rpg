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
				pos: { w: .hitbox.w, h: .hitbox.h }
				world: args.world
			})
