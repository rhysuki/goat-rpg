class GameObject
	new: (room, args = {}) =>
		@room = room
		@members = room.members
		@input = room.input

		@pos = @pos or args.pos or { x: 0, y: 0 }

		@is_active = true
		@is_visible = true
		@is_dead = false

		@time_created = L.timer.getTime!

	update: (dt) =>

	draw: =>

	--

	-- shuts everything off and awaits removal from @members.
	-- !! in objects with inner objects, remember to call their @Die
	-- too!
	die: =>
		@is_active = false
		@is_visible = false
		@is_dead = true