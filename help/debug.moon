{
	--- silly coroutine to measure how long something takes.
	-- call once to start, again to end. 2nd call returns how long it's
	-- been since the 1st call, in miliseconds.
	-- @treturn number
	measure_ms: coroutine.wrap(->
		while true
			time = L.timer.getTime!
			coroutine.yield!
			coroutine.yield((L.timer.getTime! - time) * 1000)
	)

	--- like measure_ms, but for garbage count in kb.
	-- does a full garbage collection round after every 2nd call, unless
	-- you pass false to it.
	--
	-- it might seem weird to catch the value for the 2nd call on the 1st
	-- yield, but the 1st ever call starts the coroutine until it stops
	-- at the 1st yield. then the 1st yield returns the value from the 2nd call.
	-- so it's like, offset by 1.
	-- @treturn number
	measure_kb: coroutine.wrap(->
		while true
			kb = collectgarbage('count')
			do_cleanup = coroutine.yield!
			kb_delta = collectgarbage('count') - kb

			if do_cleanup or (do_cleanup == nil)
				collectgarbage!
				collectgarbage!
				collectgarbage! -- idk

			coroutine.yield(kb_delta)
	)
}