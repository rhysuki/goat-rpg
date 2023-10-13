import colour from require 'help.graphics'
import n_sin from require 'help.math'

Actor = require 'obj.overworld.Actor'
Room = require 'obj.room.Room'

bump = require 'lib.bump'
actors = require 'data.actors'

class ActorExplorer extends Room
	new: (args = {}) =>
		super(args)

		@pos_info_alpha = 0

		@actor_names = [k for k in pairs actors]
		table.sort(@actor_names)

		@actor_origin = { x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT - 20 }

		@worlds = {
			physical: bump.newWorld!
			interaction: bump.newWorld!
		}

		@save_path = 'test_actor_explorer_actor_number.goat'
		@actor_number = @load_actor_number!

		@refresh_current_actor!

		DEBUG_FLAGS.show_positions = false

	update: (dt) =>
		super(dt)

		@move_actor_number!
		-- wrap around from 1 to #@actor_names
		@actor_number = ((@actor_number - 1) % #@actor_names) + 1
		@check_refresh_current_actor!
		@pos_info_alpha += 1

	draw_in_camera: =>
		@draw_actor_origin!
		super!
		@draw_actor_list!
		@draw_position!

	--

	move_actor_number: =>
		if @input\pressed('move_down') or @input\pressed('move_right')
			@actor_number += 1
		elseif @input\pressed('move_up') or @input\pressed('move_left')
			@actor_number -= 1

	check_refresh_current_actor: =>
		if @input\pressed('move_down') or
			@input\pressed('move_up') or
			@input\pressed('move_left') or
			@input\pressed('move_right')
			@refresh_current_actor!

	refresh_current_actor: =>
		if @current_actor then @current_actor\die!

		@current_actor = @add(Actor, {
			actor_name: @actor_names[@actor_number]
			world: @worlds.physical
			interaction_world: @worlds.interaction
		})

		with @current_actor
			.pos.x = math.floor(@actor_origin.x - (.hitbox.pos.w / 2))
			.pos.y = math.floor(@actor_origin.y - .hitbox.pos.h)

		@current_actor\update(0.016)

		@save_actor_number!

	draw_actor_origin: =>
		with @actor_origin
			colour('b_pink', 0.2)
			LG.circle('line', .x, .y, 16)
			LG.circle('line', .x, .y, 4)

			colour('b_blue', 0.5)
			LG.line(.x - 8, .y, .x + 8, .y)
			LG.line(.x, .y - 8, .x, .y + 8)
			colour!

	draw_actor_list: =>
		for i, actor_name in ipairs @actor_names
			y = (SCREEN_HEIGHT / 2) + (i - 1) * 10
			is_selected = i == @actor_number

			if is_selected then actor_name = "" .. actor_name
			else colour('white', 0.35)

			LG.print(actor_name, 5, y - (@actor_number * 10))

			colour!

	draw_position: =>
		if @current_actor
			x = @current_actor.pos.x
			y = @current_actor.pos.y
			alpha = n_sin(@pos_info_alpha, 0.1)

			colour('b_pink', alpha * 0.7)
			LG.circle('line', x, y, 4)
			LG.line(x - 8, y, x + 8, y)
			LG.line(x, y - 8, x, y + 8)
			colour('b_green', alpha)
			LG.points(x, y)
			colour!

	-- @treturn number
	load_actor_number: =>
		if L.filesystem.getInfo(@save_path)
			-- catch it here to discard extra arguments
			data = L.filesystem.read(@save_path)
			return tonumber(data)

		return 1

	-- @treturn number
	save_actor_number: =>
		assert(L.filesystem.write(@save_path, tostring(@actor_number)))
