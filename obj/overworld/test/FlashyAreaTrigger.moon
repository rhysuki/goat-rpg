AreaTrigger = require 'obj.overworld.AreaTrigger'

timer = require 'lib.timer'
colours = require 'data.colours'

class FlashyAreaTrigger extends AreaTrigger
	new: (room) =>
		super(room)
		@timer = timer!
		@colour = @get_colour('b_purple')

	update: (dt) =>
		super(dt)
		@timer\update(dt)

	draw: =>
		LG.setColor(@colour)
		LG.rectangle('fill', @x - 4, @y - 4, @width + 6, @height + 6, 5, 5)
		LG.setColor(1, 1, 1, 1)

		super!

	--

	on_enter: (other) =>
		super(other)

		@colour = @get_colour('b_white')
		@timer\tween('colour', 0.5, @, { colour: @get_colour('b_green') }, 'out-cubic')

	on_exit: (other) =>
		super(other)

		@colour = @get_colour('b_red')
		@timer\tween('colour', 0.5, @, { colour: @get_colour('b_purple')}, 'out-cubic')

	--

	get_colour: (name) =>
		return { unpack(colours[name]) }
