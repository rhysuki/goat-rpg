import safe_copy from require 'help.table'

Hitbox = require 'obj.overworld.Hitbox'
Peachy = require 'obj.Peachy'

baton = require 'lib.baton'

class Player extends Hitbox
	new: (room, args = {}) =>
		args = safe_copy({
			pos: { w: 12, h: 15 }
		}, args)
		super(room, args)

		-- how many pixels to move per frame
		@speed = 1
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

		@sprite = @room\add(Peachy, { path: '*/goat', initial_tag: 'idle_down' })

	update: (dt) =>
		super(dt)
		@input\update(dt)

		@update_facing_direction!
		@move(dt)

		@animation_state = @is_moving! and 'walk' or 'idle'
		@sprite\play_tag(@animation_state .. '_' .. @facing_direction)

		@sprite.pos.x = @pos.x - 2
		@sprite.pos.y = @pos.y - 1

	draw: =>
		super!

	--

	die: =>
		super!
		@sprite\die!

	move: (dt) =>
		x_move, y_move = @input\get('move')

		@move_to(
			@pos.x + (x_move * @speed * dt * 60)
			@pos.y + (y_move * @speed * dt * 60)
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

	-- are any of the movement buttons pressed?
	-- @treturn bool
	is_moving: =>
		x_move, y_move = @input\get('move')

		if x_move != 0 or y_move != 0 then return true
		return false
