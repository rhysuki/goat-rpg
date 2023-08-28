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
		}, args)

		super(room, args)

		@texts = args.texts
		@corner_roundness = args.corner_roundness
		@input = @room.input
		@timer = timer!

		@text = ''

		@go_to_next_text!

	update: (dt) =>
		super(dt)
		@timer\update(dt)

		if @input\pressed('interact')
			@go_to_next_text!
			if not @text then @finish!

	draw: =>
		super!

		colour('b_white')
		LG.rectangle('fill', @pos.x, @pos.y, @pos.w, @pos.h, @corner_roundness, @corner_roundness)
		colour('b_pink')
		LG.setLineWidth(2)
		LG.rectangle('line', @pos.x, @pos.y, @pos.w, @pos.h, @corner_roundness, @corner_roundness)
		LG.setLineWidth(1)
		LG.print(@text, @pos.x + 5, @pos.y)
		colour!

	--

	finish: =>
		super!
		@die!

	go_to_next_text: =>
		@text = table.remove(@texts, 1)
