-- an audio source that exists in 2d space. volume depends on distance
-- between it and @listener.
import safe_copy from require 'help.table'
import colour from require 'help.graphics'
import clamp, distance, smoothstep from require 'lib.bat.mathx'

GameObject = require 'obj.GameObject'

sounds = require 'data.sounds'

class Source extends GameObject
	new: (room, args = {}) =>
		args = safe_copy({
			sound_name: nil
			radius: 50
			-- a table with x and y, like a GameObject's @pos.
			listener: nil
		}, args)

		super(room, args)

		@sound = sounds[args.sound_name]
		@radius = args.radius
		@listener = args.listener

		@instance = @sound\play!

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
		return smoothstep(volume)
