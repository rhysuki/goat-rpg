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

		@area_trigger\set_dimensions(@hitbox.pos.w, @hitbox.pos.h)

	update: (dt) =>
		super(dt)
		@input\update(dt)

		@update_facing_direction!
		@move(dt)

		@animation_state = @is_moving! and 'walk' or 'idle'
		@update_sprite!

		@check_interactibles!

	--

	move: (dt) =>
		x_move, y_move = @input\get('move')

		@pos.x += (x_move * @speed * dt * 60)
		@pos.y += (y_move * @speed * dt * 60)

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

	update_facing_direction: =>
		-- TODO: how's undertale do it? like, the first direction you
		-- press is lower priority for diagonals.
		-- eg hold left, then hold up makes frisk face up
		-- hold up, then hold left makes frisk face left
		-- ^ but... if you let go of up, left would be the held direction.
		-- lone held direction = lower priority?
		-- actually I just looked at it again and I think it's the other
		-- way around
		x_move, y_move = @input\get('move')

		if x_move > 0 then @facing_direction = 'right'
		elseif x_move < 0 then @facing_direction = 'left'
		elseif y_move < 0 then @facing_direction = 'up'
		elseif y_move > 0 then @facing_direction = 'down'
		else return

	update_sprite: =>
		@sprite\play_tag(@animation_state .. '_' .. @facing_direction)

	check_interactibles: =>
		for col in *@area_trigger.cols
			context = col.other.context
			if not context then continue
			if context.activate and @input\pressed('interact')
				context\activate!

	-- are any of the movement buttons pressed?
	-- @treturn bool
	is_moving: =>
		x_move, y_move = @input\get('move')

		if x_move != 0 or y_move != 0 then return true
		return false
