import safe_copy from require 'help.table'
import colour from require 'help.graphics'

CutsceneObject = require 'obj.cutscene.CutsceneObject'

timer = require 'lib.timer'

class TextBox extends CutsceneObject
	new: (room, args = {}) =>
		args = safe_copy({
			pos: {
				x: 10
				y: 10
				w: SCREEN_WIDTH - 20
				h: 60
			}

			-- table of strings
			texts: nil
			corner_roundness: 6

			foreground_colour: 'b_pink'
			background_colour: 'b_white'
		}, args)

		super(room, args)

		@texts = args.texts
		@corner_roundness = args.corner_roundness
		@foreground_colour = args.foreground_colour
		@background_colour = args.background_colour

		@input = @room.input
		@timer = timer!

		@text = ''
		@text_alpha = 0

		@go_to_next_text!

	update: (dt) =>
		super(dt)
		@timer\update(dt)

		if @input\pressed('interact')
			@go_to_next_text!
			if not @text then @finish!

	draw: =>
		super!

		colour(@background_colour)
		LG.rectangle('fill', @get_rect!)

		colour(@foreground_colour)
		LG.setLineWidth(2)
		LG.rectangle('line', @get_rect!)
		LG.setLineWidth(1)

		colour(@foreground_colour, @text_alpha)
		LG.printf(@text, @pos.x + 5, @pos.y, @pos.w - 10, 'left')
		colour!

	--

	finish: =>
		super!
		@die!

	go_to_next_text: =>
		@text = table.remove(@texts, 1)

		@text_alpha = 0
		@timer\tween('text_alpha', 0.5, @, { text_alpha: 1 }, 'out-cubic')

	-- @treturn number, number, number, number, number, number
	get_rect: =>
		return @pos.x, @pos.y, @pos.w, @pos.h, @corner_roundness, @corner_roundness
