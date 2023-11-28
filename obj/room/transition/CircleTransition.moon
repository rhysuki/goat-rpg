import colour from require 'help.graphics'
import clamp, distance from require 'lib.bat.mathx'

Transition = require 'obj.room.transition.Transition'

class CircleTransition extends Transition
	new: (
		room,
		@target,
		@target_offset = { x: 0, y: 0 },
		next_room,
		duration = 1,
		is_reversed = false,
		colour = 'black'
	) =>
		-- args = safe_copy({
		-- 	-- a table with x and y fields. can be a pos?
		-- 	target: room.camera
		-- 	target_offset: { x: 0, y: 0 }
		-- }, args)
		super(room, next_room, duration, is_reversed, colour)

		-- assuming the target is on screen, the radius'll never have to
		-- be bigger than this
		max_r = distance(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

		target_r = @is_reversed and max_r or 0
		@r = @is_reversed and 0 or max_r

		@timer\tween(@duration - 0.1, @, { r: target_r }, 'in-out-cubic')

	draw: =>
		super!

		-- limit x and y to within the camera view
		cam = @room.camera
		x = clamp(@target.x + @target_offset.x, cam.x - cam.w2, cam.x + cam.w2)
		y = clamp(@target.y + @target_offset.y, cam.y - cam.h2, cam.y + cam.h2)

		LG.stencil(-> LG.circle('fill', x, y, @r))
		LG.setStencilTest('less', 1)

		colour(@colour)
		LG.circle('fill', x, y, 1000)
		colour!

		LG.setStencilTest!
