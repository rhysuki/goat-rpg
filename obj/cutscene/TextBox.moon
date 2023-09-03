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
		@is_triangle_down = false

		@input = @room.input
		@timer = timer!

		@text = ''
		@text_alpha = 0

		@go_to_next_text!

		@timer\every(0.5, (-> @is_triangle_down = not @is_triangle_down))

	update: (dt) =>
		super(dt)
		@timer\update(dt)

		if @input\pressed('interact')
			@go_to_next_text!
			if not @text then @finish!

	draw: =>
		super!

		cam_x = @room.camera.x - @room.camera.w2
		cam_y = @room.camera.y - @room.camera.h2
		x, y, w, h, r, r = @get_rect!
		x += cam_x
		y += cam_y

		colour(@background_colour)
		LG.rectangle('fill', x, y, w, h, r, r)

		colour(@foreground_colour)
		LG.setLineWidth(4)
		LG.rectangle('line', x, y, w, h, r, r)
		LG.setLineWidth(1)

		do
			triangle_x = x + @pos.w - 12
			triangle_y = y + @pos.h - 10 + (@is_triangle_down and 1 or 0)
			@draw_triangle(triangle_x, triangle_y)

		colour(@foreground_colour, @text_alpha)
		LG.printf(@text, x + 5, y, @pos.w - 10, 'left')
		colour!

	--

	finish: =>
		super!
		@die!

	go_to_next_text: =>
		@text = table.remove(@texts, 1)

		@text_alpha = 0
		@timer\tween('text_alpha', 0.5, @, { text_alpha: 1 }, 'out-cubic')

	draw_triangle: (x, y) =>
		LG.polygon('fill', x, y, x + 5, y, x + 3, y + 3)

	-- @treturn number, number, number, number, number, number
	get_rect: =>
		return @pos.x, @pos.y, @pos.w, @pos.h, @corner_roundness, @corner_roundness
