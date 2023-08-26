-- an audio source with distance.
-- can be listened to by a listener?
import safe_copy from require 'help.table'
import colour from require 'help.graphics'

GameObject = require 'obj.GameObject'

sounds = require 'data.sounds'

class Source extends GameObject
	new: (room, args = {}) =>
		args = safe_copy({
			sound_name: nil
			radius: 50
		}, args)

		super(room, args)

		@sound = sounds[args.sound_name]
		@radius = args.radius
		@instance = @sound\play!

		@listeners = {}

	draw: =>
		if DEBUG_FLAGS.show_positions
			colour('b_light_blue')
			LG.circle('line', @pos.x, @pos.y, @radius)
			colour('b_blue')
			LG.circle('line', @pos.x, @pos.y, 1)
			colour!

	--

	-- add a listener to listen for this audio. must have x and y fields,
	-- like a GameObject's @pos.
	add_listener: (obj) =>
		INSERT(@listeners, obj)
