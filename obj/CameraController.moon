-- takes care of making the camera look at things.
-- keep hold of the table returned by add_target!

import copy from require 'help.table'
import colour from require 'help.graphics'
import lerp, round, clamp from require 'lib.bat.mathx'

GameObject = require 'obj.GameObject'

class CameraController extends GameObject
	new: (room, camera = CAMERA, args = {}) =>
		args = copy({
			smoothing: 0.3
		}, args)

		super(room, args)

		@camera = camera
		@targets = {}
		@smoothing = args.smoothing

	update: (dt) =>
		super(dt)

		mean_x, mean_y = @get_mean_target_position!
		cam_x, cam_y = @camera\getPosition!

		cam_x = lerp(cam_x, mean_x, @smoothing)
		cam_y = lerp(cam_y, mean_y, @smoothing)

		@camera\setPosition(cam_x, cam_y)

	draw: =>
		super!
		if not DEBUG_FLAGS.show_positions then return

		for { :x, :y, :is_active } in *@targets
			colour('magenta', (is_active and 0.85 or 0.3))
			LG.circle('fill', x, y, 5)
			LG.circle('line', x, y, 9)

		colour!

	--

	--- skip lerping.
	snap_to_destination: =>
		@camera\setPosition(@get_mean_target_position!)

	-- @treturn number, number
	get_mean_target_position: =>
		if #@targets == 0 then return @camera\getPosition!

		sum_x = 0
		sum_y = 0
		active_targets = [t for t in *@targets when t.is_active]

		for { :x, :y } in *active_targets
			x_min = @camera.w / 2
			x_max = @camera.ww - (@camera.w / 2)
			y_min = @camera.h / 2
			y_max = @camera.wh - (@camera.h / 2)

			x = clamp(x, x_min, x_max)
			y = clamp(y, y_min, y_max)

			sum_x += x
			sum_y += y

		return sum_x / #active_targets, sum_y / #active_targets

	--- adds a target to keep track of. catch the return value somewhere.
	-- @treturn tab
	add_target: (x, y, is_active = true) =>
		return INSERT(@targets, { :x, :y, :is_active, controller: @ })

	--- searches for the given table in @targets and removes it.
	-- returns the removed target, if found.
	-- @treturn tab
	remove_target: (t) =>
		for i, target in ipairs @targets
			if target == t
				return table.remove(@targets, i)
