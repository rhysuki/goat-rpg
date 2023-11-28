import colour from require 'help.graphics'

CutsceneObject = require 'obj.cutscene.CutsceneObject'

timer = require 'lib.timer'

class TextBox extends CutsceneObject
	new: (room, @texts) =>
		super(room)

		@width = SCREEN_WIDTH - 20
		@height = 60

		@corner_roundness = 6
		@foreground_colour = 'b_pink'
		@background_colour = 'b_white'
		@is_triangle_down = false
		@text_number = 0

		@text = ''
		@text_alpha = 0

		@input = @room.input
		@timer = timer!

		@timer\every(0.5, (-> @is_triangle_down = not @is_triangle_down))

		@go_to_next_text!

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
			triangle_x = x + @width - 12
			triangle_y = y + @height - 10 + (@is_triangle_down and 1 or 0)
			@draw_triangle(triangle_x, triangle_y)

		colour(@foreground_colour, @text_alpha)
		LG.printf(@text, x + 5, y, @width - 10, 'left')
		colour!

	--

	finish: =>
		super!
		@die!

	go_to_next_text: =>
		@text_number += 1
		@text = @texts[@text_number]

		@text_alpha = 0
		@timer\tween('text_alpha', 0.5, @, { text_alpha: 1 }, 'out-cubic')

	draw_triangle: (x, y) =>
		LG.polygon('fill', x, y, x + 5, y, x + 3, y + 3)

	-- @treturn number, number, number, number, number, number
	get_rect: =>
		return @x, @y, @width, @height, @corner_roundness, @corner_roundness
