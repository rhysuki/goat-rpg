import colour from require 'help.graphics'

CutsceneObject = require 'obj.cutscene.CutsceneObject'

timer = require 'lib.timer'

class ZPrompt extends CutsceneObject
	new: (room, args = {}) =>
		super(room, args)

		@input = @room.input
		@timer = timer!
		@alpha = 1

	update: (dt) =>
		super(dt)
		@timer\update(dt)
		if @input\pressed('interact') then @finish!

	draw: =>
		super!

		colour((@is_done and 'b_green' or 'b_red'), @alpha)
		LG.print("press Z!", @pos.x, @pos.y)
		colour!

	--

	finish: =>
		super!
		@timer\tween(1, @, { alpha: 0 }, 'linear', -> @die!)
