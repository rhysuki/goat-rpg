-- mainly, an object with a hitbox and sprite that exists in the map.
import safe_copy from require 'help.table'

GameObject = require 'obj.GameObject'
Peachy = require 'obj.Peachy'
Hitbox = require 'obj.overworld.Hitbox'
AreaTrigger = require 'obj.overworld.AreaTrigger'

actors = require 'data.actors'

class Actor extends GameObject
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.actor_name = object.properties.actor_name
		out.world = room.worlds[object.properties.world] or
			room.worlds.collision

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			actor_name: ''
			world: nil
			interaction_world: nil
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
				context: @
			})

			@area_trigger = @room\add(AreaTrigger, {
				pos: {
					x: @hitbox.pos.x - 3
					y: @hitbox.pos.y - 3
					w: @hitbox.pos.w + 6
					h: @hitbox.pos.h + 6
				}
				world: args.interaction_world
				context: @
			})

		@update_hitbox!
		@update_area_trigger!

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

	update_hitbox: =>
		@hitbox.world\update(@hitbox, @pos.x, @pos.y)

	update_area_trigger: =>
		@area_trigger.world\update(
			@area_trigger
			@hitbox.pos.x - 3
			@hitbox.pos.y - 3
		)


	move_hitbox: =>
		@hitbox\move_to(@pos.x, @pos.y)

	move_area_trigger: =>
		@area_trigger\move_to(@hitbox.pos.x - 3, @hitbox.pos.y - 3)

	-- the sprite's attached to the middle of the bottom of the hitbox.
	move_sprite: =>
		x, y, w, h = @sprite\get_size!

		@sprite.pos.x = @hitbox.pos.x + (@hitbox.pos.w / 2) - (w / 2)
		@sprite.pos.y = @hitbox.pos.y + @hitbox.pos.h - h
