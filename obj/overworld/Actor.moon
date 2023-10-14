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

		with object.properties
			out.actor_name = .actor_name
			out.world = room.worlds[.world] or room.worlds.collision
			out.interaction_world = room.worlds[.interaction_world] or
				room.worlds.interaction

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			actor_name: ''
			world: nil
			interaction_world: nil
		}, args)

		super(room, args)

		@filter = (other) ->
			if @hitbox\has_tag('furniture') and other.context.hitbox\has_tag('furniture')
				return 'cross'

			return 'slide'

		with actors[args.actor_name]
			@sprite = @room\add(Peachy, {
				path: .sprite.path
				initial_tag: .sprite.initial_tag
			})

			@hitbox = @room\add(Hitbox, {
				pos: { w: .hitbox.pos.w, h: .hitbox.pos.h }
				world: args.world
				context: @
				filter: @filter
				tags: .tags
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

		@hitbox\set_position(@pos.x, @pos.y)
		@area_trigger\set_position(@pos.x - 3, @pos.y - 3)
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
		@pos.x, @pos.y = x, y

		@hitbox\set_position(@pos.x, @pos.y)
		@move_area_trigger!
		@move_sprite!

	move_hitbox: =>
		@hitbox\move_to(@pos.x, @pos.y)

	move_area_trigger: =>
		@area_trigger\move_to(@hitbox.pos.x - 3, @hitbox.pos.y - 3)

	-- the sprite's attached to the middle of the bottom of the hitbox.
	move_sprite: =>
		x, y, w, h = @sprite\get_size!

		@sprite.pos.x = @hitbox.pos.x + (@hitbox.pos.w / 2) - (w / 2)
		@sprite.pos.y = @hitbox.pos.y + @hitbox.pos.h - h
