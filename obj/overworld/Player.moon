import safe_copy from require 'help.table'

Hitbox = require 'obj.overworld.Hitbox'

baton = require 'lib.baton'

class Player extends Hitbox
	new: (room, args = {}) =>
		args = safe_copy({
			pos: { w: 15, h: 15 }
		}, args)
		super(room, args)

		-- how many pixels to move per frame
		@speed = 1
		@facing_direction = 'down'
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

		@arrow = IMAGE\new_image('*/arrow.png')

	update: (dt) =>
		super(dt)
		@input\update!

		@update_facing_direction!
		@move(dt)

	draw: =>
		super!
		offset = 8
		r = switch @facing_direction
			when 'down' then 0
			when 'left' then math.pi * 0.5
			when 'up' then math.pi
			when 'right' then math.pi * 1.5

		LG.draw(@arrow, @pos.x + offset, @pos.y + offset, r, 1, 1, offset, offset)

	--

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
