import resize from require 'help.window'

push = require 'lib.push'

-- this has to be here since this global NEEDS to exist before jprof
-- gets required, so it can't go into init_globals which gets run later
export PROF_CAPTURE = false
prof = require 'lib.jprof'

love.load = ->
	-- set filter before everything cause it might impact instantiation
	love.graphics.setDefaultFilter('nearest')
	love.graphics.setLineStyle('rough')

	require 'init_globals'

	push\setupScreen(
		SCREEN_WIDTH
		SCREEN_HEIGHT
		SCREEN_WIDTH
		SCREEN_HEIGHT
		{
			resizable: false
			pixelperfect: true
			-- pavizi
			canvas: true
		}
	)

	print("=======================================================")

	LG.setFont(require('data.fonts').tiny)
	STAGE\goto(require('obj.room.Overworld')({ map_name: '*/test.lua', target_exit_id: 1 }))
	resize(2)

love.update = (dt) ->
	prof.push('frame')
	if DEBUG_FLAGS.limit_dt then dt = math.min(dt, 0.2)

	STAGE\update(dt)
	nil

love.draw = ->
	push\start!

	STAGE\draw!

	prof.pop('frame')

	if DEBUG_FLAGS.show_frame_info
		import deindent from require 'lib.bat.stringx'
		import truncate from require 'help.math'
		import colour from require 'help.graphics'
		import tiny from require 'data.fonts'

		stats = LG.getStats!
		fps = L.timer.getFPS!
		memory = collectgarbage('count')

		colour(1, 0.6, 0.2, 1)
		LG.print(
			deindent("
				%d fps
				%d kb

				images: %d
				canvases: %d
				fonts: %d

				drawcalls: %d
				(batched: %d)
			")\format(
				fps
				memory
				stats.images
				stats.canvases
				stats.fonts
				stats.drawcalls
				stats.drawcallsbatched
			)
			tiny
			60, 0
		)
		colour!

	push\finish!
	nil

love.keypressed = (k) ->
	if DEBUG_FLAGS.numbers_to_resize
		if tonumber(k) then resize(k)

	if DEBUG_FLAGS.ctrl_to_debug
		if k == 'lctrl' then debug.debug!

	if DEBUG_FLAGS.escape_to_reset
		if k == 'escape' then L.event.quit('restart')

love.quit = ->
	prof.write('default_prof_out.kprof')
