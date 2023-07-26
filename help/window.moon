push = require 'lib.push'

{
	--- resizes the window to n times the underlying size.
	-- calls push.resize and love.window.setmode.
	-- CHANGES SCALE, WINDOW_WIDTH AND WINDOW_HEIGHT!!!
	resize: (n) ->
		export *
		SCALE = n

		WINDOW_WIDTH = SCREEN_WIDTH * n
		WINDOW_HEIGHT = SCREEN_HEIGHT * n

		push\resize(WINDOW_WIDTH, WINDOW_HEIGHT)
		L.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

	--- gets the mouse position, accounting for the scale.
	-- @treturn number, number
	get_mouse_position: (scale = SCALE) ->
		x, y = L.mouse.getPosition!

		return x / scale, y / scale

	--- biggest scale factor the game can fit in inside this monitor.
	-- @treturn number
	get_max_safe_scale: =>
		_, _, flags = L.window.getMode!
		w, h = L.window.getDesktopDimensions(flags.display)

		max_width_scale = math.floor(w / SCREEN_WIDTH)
		max_height_scale = math.floor(h / SCREEN_HEIGHT)

		return math.min(max_width_scale, max_height_scale)
}
