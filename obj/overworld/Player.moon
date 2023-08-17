import safe_copy from require 'help.table'
import is from require 'help.type'

Actor = require 'obj.overworld.Actor'
Hitbox = require 'obj.overworld.Hitbox'
AreaTrigger = require 'obj.overworld.AreaTrigger'
Peachy = require 'obj.Peachy'
Interactible = require 'obj.overworld.Interactible'

baton = require 'lib.baton'

class Player extends Actor
	new: (room, args = {}) =>
		args = safe_copy({
			interaction_world: nil
			actor_name: 'goat'
		}, args)

		super(room, args)

		@is_input_enabled = true
		-- the actual values used for movement logic. they don't reset
		-- to 0 if is_input_enabled is off.
		@move_x = 0
		@move_y = 0
		-- how many pixels to move per frame
		@speed = 1.2
		@facing_direction = 'down'
		@animation_state = 'idle'
		@debug_colour = 'b_pink'

		@input = baton.new({
			controls: {
				left: { 'key:left', 'axis:leftx-' }
				right: { 'key:right', 'axis:leftx+' }
				up: { 'key:up', 'axis:lefty-' }
				down: { 'key:down', 'axis:lefty+' }

				interact: { 'key:z' }
			}

			pairs: {
				move: { 'left', 'right', 'up', 'down' }
			}
		})

		@camera_target = @room.camera_controller\add_target(@pos.x, @pos.y)

		@area_trigger\set_dimensions(@hitbox.pos.w, @hitbox.pos.h)

	update: (dt) =>
		super(dt)
		@input\update(dt)

		if @is_input_enabled
			@set_move(@get_move_axis!)

		@update_facing_direction!
		@move(dt)
		@update_animation_state!
		@update_sprite!

		@check_interactibles!

		@camera_target.x, @camera_target.y = @pos.x, @pos.y

	--
	set_move: (x, y) =>
		@move_x, @move_y = x, y

	move: (dt) =>
		@pos.x += (@move_x * @speed * dt * 60)
		@pos.y += (@move_y * @speed * dt * 60)

		@hitbox\move_to(@pos.x, @pos.y)

		@pos.x = @hitbox.pos.x
		@pos.y = @hitbox.pos.y

	move_area_trigger: =>
		super!

		-- place the area trigger at the foot of this hitbox
		@area_trigger\move_to(
			@hitbox.pos.x
			@hitbox.pos.y + @hitbox.pos.h - @area_trigger.pos.h
		)

	update_animation_state: =>
		@animation_state = @is_moving! and 'walk' or 'idle'

	update_facing_direction: =>
		-- TODO: how's undertale do it? like, the first direction you
		-- press is lower priority for diagonals.
		-- eg hold left, then hold up makes frisk face up
		-- hold up, then hold left makes frisk face left
		-- ^ but... if you let go of up, left would be the held direction.
		-- lone held direction = lower priority?
		-- actually I just looked at it again and I think it's the other
		-- way around
		if @move_x > 0 then @facing_direction = 'right'
		elseif @move_x < 0 then @facing_direction = 'left'
		elseif @move_y < 0 then @facing_direction = 'up'
		elseif @move_y > 0 then @facing_direction = 'down'
		else return

	update_sprite: =>
		@sprite\play_tag(@animation_state .. '_' .. @facing_direction)

	check_interactibles: =>
		for col in *@area_trigger.cols
			context = col.other.context
			if not context then continue
			if context.activate and @is_facing(context) and @input\pressed('interact')
				context\activate!

	-- @treturn number, number
	get_move_axis: =>
		return @input\get('move')

	-- @treturn number, number
	get_direction_axis: (direction) =>
		switch direction
			when 'right' then return 1, 0
			when 'left' then return -1, 0
			when 'down' then return 0, 1
			when 'up' then return 0, -1

		error("#{direction} is not a valid direction?")

	-- are any of the movement buttons pressed?
	-- @treturn bool
	is_moving: =>
		if @move_x != 0 or @move_y != 0 then return true
		return false

	-- TODO: use actor instead of obj
	-- is this player facing the given object?
	-- @treturn bool
	is_facing: (obj) =>
		this = @hitbox.pos
		other = obj.hitbox.pos
		dir = @facing_direction

		if (((this.x + this.w - 1) < other.x) and dir == 'right') or
			((this.x > (other.x + other.w - 1)) and dir == 'left') or
			(((this.y + this.h - 1) < other.y) and dir == 'down') or
			((this.y > (other.y + other.h - 1)) and dir == 'up')
			return true

		return false
