import colour from require 'help.graphics'
import tiny from require 'data.fonts'

GameObject = require 'obj.GameObject'

colours = require 'data.colours'
timer = require 'lib.timer'

class Billboard extends GameObject
	tiled_object_to_args: (room, object) =>
		out = super(room, object)

		out.pubsub = room.pubsubs.test
		out.pubsub_event = object.properties.pubsub_event

		return out

	new: (room, @pubsub, @pubsub_event = '') =>
		super(room)

		@is_on = false
		@width = 16 * 4
		@height = (16 * 2) - 4
		@colour = @copy_colour('b_black')

		@timer = timer!

		@pubsub\subscribe(@pubsub_event, -> @switch!)

	update: (dt) =>
		super(dt)
		@timer\update(dt)

	draw: =>
		colour('b_white')
		LG.rectangle('fill', @x - 1, @y - 1, @width + 2, @height + 2, 5, 5)
		LG.setColor(@colour)
		LG.rectangle('fill', @x, @y, @width, @height, 5, 5)

		-- if @is_on then colour('b_green')
		-- else colour('b_red')
		-- LG.print("I AM #{@is_on and 'ON' or 'OFF'}!", @pos.x, @pos.y)
		colour!
		texts = { "billboard here.", "i am:", (@is_on and "on" or "off") }
		widths = [tiny\getWidth(text) for text in *texts]

		LG.print(
			texts[1]
			@x + (@width / 2) - (widths[1] / 2)
			@y - 2
		)

		LG.print(
			texts[2]
			@x + (@width / 2) - (widths[2] / 2)
			@y + 6
		)

		colour(@is_on and 'b_green' or 'b_red')
		LG.print(
			texts[3]
			@x + (@width / 2) - (widths[3] / 2)
			@y + 14
		)
		colour!

	--

	copy_colour: (name) =>
		return { unpack(colours[name]) }

	switch: =>
		@is_on = not @is_on

		@colour = @copy_colour('b_white')
		@timer\tween('colour', 0.5, @colour, @copy_colour('b_black'), 'out-cubic')
