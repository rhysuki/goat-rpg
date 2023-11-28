Peachy = require 'obj.Peachy'
Hitbox = require 'obj.overworld.Hitbox'

actors = require 'data.actors'

{
	-- @treturn obj, obj, obj
	create_actor_instances: (room, actor_name, hitbox_world, area_trigger_world) ->
		with actors[actor_name]
			sprite = room\add(Peachy, .sprite.path, .sprite.initial_tag)
			hitbox = room\add(Hitbox, hitbox_world)
			area_trigger = with room\add(Hitbox, area_trigger_world)
				\set_filter('cross')

			return sprite, hitbox, area_trigger
}
