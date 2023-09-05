-- helps control the player inside a cutscene.
-- make sure to kill this when the cutscene ends!

import safe_copy from require 'help.table'
import wait from require 'lib.bat.async'

GameObject = require 'obj.GameObject'

class PlayerCutsceneController extends GameObject
	new: (room, args = {}) =>
		args = safe_copy({
			player: nil
		}, args)

		super(room, args)

		@player = args.player
		@player.is_input_enabled = false
		@set_move('none')

	update: (dt) =>
		super(dt)

	--

	die: =>
		super!
		@player.is_input_enabled = true

	-- moves the player in the given direction. stops the player if
	-- direction is none.
	set_move: (direction) =>
		if direction == 'none'
			@player\set_move(0, 0)
			return

		@player\set_move(@player\get_direction_axis(direction))

	-- moves the player in this direction for some amount of seconds.
	move_toward: (direction, seconds) =>
		@set_move(direction)
		wait(seconds)
