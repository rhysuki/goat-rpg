import colour from require 'help.graphics'
import distance from require 'lib.bat.mathx'
import safe_copy from require 'help.table'

Transition = require 'obj.room.transition.Transition'

class CircleTransition extends Transition
	new: (room, args = {}) =>
		args = safe_copy({
			-- a table with x and y fields. can be a pos?
			target: room.camera
		}, args)
		super(room, args)

		@target = args.target

		max_r = distance(0, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

		target_r = @is_reversed and max_r or 0
		@r = @is_reversed and 0 or max_r
		@tween = @is_reversed and 'out-sine' or 'in-sine'

		@timer\tween(@duration - 0.1, @, { r: target_r }, @tween)

	draw: =>
		super!

		with @target
			LG.stencil(-> LG.circle('fill', .x, .y, @r))
			LG.setStencilTest('less', 1)

			colour(@colour)
			LG.circle('fill', .x, .y, 1000)
			colour!

			LG.setStencilTest!
