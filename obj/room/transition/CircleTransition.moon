import colour from require 'help.graphics'
import distance from require 'lib.bat.mathx'

Transition = require 'obj.room.transition.Transition'

class CircleTransition extends Transition
	new: (room, args = {}) =>
		super(room, args)

		@r = distance(0, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

		@timer\tween(@duration - 0.1, @, { r: 0 }, 'in-sine')

	draw: =>
		super!

		with @room.camera
			LG.stencil(-> LG.circle('fill', .x, .y, @r))
			LG.setStencilTest('less', 1)

			colour(@colour)
			LG.circle('fill', .x, .y, 1000)
			colour!

			LG.setStencilTest!
