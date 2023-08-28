-- an audio source that exists in 2d space. volume depends on distance
-- between it and @listener.
import safe_copy from require 'help.table'
import colour from require 'help.graphics'
import clamp, distance, smoothstep from require 'lib.bat.mathx'

GameObject = require 'obj.GameObject'

sounds = require 'data.sounds'

class Source extends GameObject
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.sound_name = object.properties.sound_name
		out.volume = object.properties.volume
		out.listener = room.player.pos
		-- ASSUMES THIS IS AN ELLIPSE TILED OBJECT
		out.pos.x = object.x + (object.width / 2)
		out.pos.y = object.y + (object.height / 2)
		out.radius = object.width / 2

		return out

	new: (room, args = {}) =>
		args = safe_copy({
			sound_name: nil
			radius: 50
			volume: 1
			-- a table with x and y, like a GameObject's @pos.
			listener: nil
		}, args)

		super(room, args)

		@sound = sounds[args.sound_name]
		@radius = args.radius
		@volume = args.volume
		@listener = args.listener

		@instance = @sound\play!
		@instance.volume = @get_volume!

	update: (dt) =>
		@instance.volume = @get_volume!

	draw: =>
		if DEBUG_FLAGS.show_positions
			colour('b_light_blue')
			LG.circle('line', @pos.x, @pos.y, @radius)
			colour('b_blue')
			LG.circle('line', @pos.x, @pos.y, 1)
			colour!

	--

	-- calculates the volume based on the distance to the listener.
	-- @treturn number
	get_volume: =>
		dist = distance(@pos.x, @pos.y, @listener.x, @listener.y)
		volume = clamp((1 - (dist / @radius)), 0, 1)
		return smoothstep(volume) * @volume