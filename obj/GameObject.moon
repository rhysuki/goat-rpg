class GameObject
	-- gets called when this comes from a tiled object.
	-- @treturn obj
	from_tiled_object: (room, object) =>
		return @(room, @tiled_object_to_args(room, object))

	-- extend this to change how arg tables are generated, like so:
	-- 		out = super(room, object)
	-- 		out.new_key = new_value
	-- 		return out
	-- @treturn tab
	tiled_object_to_args: (room, object) =>
		return { pos: { x: object.x, y: object.y }}

	new: (room, args = {}) =>
		@room = room
		@members = room.members
		@input = room.input

		@pos = @pos or args.pos or { x: 0, y: 0 }

		@is_active = true
		@is_visible = true
		@is_dead = false
		@is_auto_draw_depth_enabled = false
		-- the y offset between @pos.y and the "foot" of this object.
		@depth_height = 0

		@time_created = L.timer.getTime!

	update: (dt) =>
		if @is_auto_draw_depth_enabled
			@draw_depth = @get_auto_draw_depth!

	draw: =>

	--

	-- shuts everything off and awaits removal from @members.
	-- !! in objects with inner objects, remember to call their @Die
	-- too!
	die: =>
		@is_active = false
		@is_visible = false
		@is_dead = true

	-- @treturn number
	get_auto_draw_depth: =>
		return (@pos.y + @depth_height) / 100
