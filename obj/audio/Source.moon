-- an audio source that exists in 2d space. volume depends on distance
-- between it and @listener.
import colour from require 'help.graphics'
import clamp, distance, smoothstep from require 'lib.bat.mathx'

GameObject = require 'obj.GameObject'

sounds = require 'data.sounds'

class Source extends GameObject
	-- ONLY WORKS WITH AN ELLIPSE TILED OBJECT
	from_tiled_object: (room, object) =>
		with object.properties
			obj = @(room, .sound_name, room.player)
			obj.volume = .volume
			obj.radius = object.width / 2

			return obj

	-- @listener is a table with x and y, like a GameObject
	new: (room, @sound_name, @listener) =>
		super(room)

		@sound = sounds[@sound_name]
		@radius = 50
		@volume = 1

		@instance = @sound\play!
		@instance.volume = @get_volume!

	update: (dt) =>
		@instance.volume = @get_volume!

	draw: =>
		if DEBUG_FLAGS.show_positions
			colour('b_light_blue')
			LG.circle('line', @x, @y, @radius)
			colour('b_blue')
			LG.circle('line', @x, @y, 1)
			colour!

	--

	-- calculates the volume based on the distance to the listener.
	-- @treturn number
	get_volume: =>
		dist = distance(@x, @y, @listener.x, @listener.y)
		volume = clamp((1 - (dist / @radius)), 0, 1)
		return smoothstep(volume) * @volume
