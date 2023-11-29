class GameObject
	-- gets called when this comes from a tiled object.
	-- @treturn obj
	from_tiled_object: (room, object) =>
		return @(room)

	new: (@room) =>
		@x = 0
		@y = 0

		@is_active = true
		@is_visible = true
		@is_dead = false
		@is_auto_draw_depth_enabled = false
		@draw_depth = 0
		-- the y offset between @y and the "foot" of this object.
		@depth_height = 0

		@time_created = L.timer.getTime!

	update: (dt) =>
		if @is_auto_draw_depth_enabled
			@draw_depth = @get_auto_draw_depth!

	draw: =>

	--

	set_position: (x = @x, y = @y) =>
		@x = x
		@y = y

	-- shuts everything off and awaits removal from @members.
	-- !! in objects with inner objects, remember to call their @Die
	-- too!
	die: =>
		@is_active = false
		@is_visible = false
		@is_dead = true

	-- @treturn number
	get_auto_draw_depth: =>
		return (@y + @depth_height) / 100
