import safe_copy from require 'help.table'

Hitbox = require 'obj.overworld.Hitbox'
Peachy = require 'obj.Peachy'

class LeverSwitch extends Hitbox
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.initial_tag = object.properties.initial_tag
		out.sprite_path = object.properties.sprite_path

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			initial_tag: nil
			sprite_path: nil
		}, args)

		super(room, args)

		@sprite = @room\add(Peachy, {
			initial_tag: args.initial_tag
			path: args.sprite_path
		})

		@is_on = false

		@room.pubsubs.test\subscribe('test', -> @switch!)

	update: (dt) =>
		super(dt)
		@sprite.pos.x = @pos.x
		@sprite.pos.y = @pos.y


	switch: =>
		@is_on = not @is_on

		if @is_on then @sprite\play_tag('on')
		else @sprite\play_tag('off')
