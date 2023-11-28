-- an audio source that exists in 2d space. volume depends on distance
-- between it and @listener.
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
