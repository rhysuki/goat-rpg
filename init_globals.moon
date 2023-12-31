-- overview:
-- SCREEN_WIDTH/SCREEN_HEIGHT: size of the virtual game world screen before scaling
-- WINDOW_WIDTH/WINDOW_HEIGHT: size of the real computer window after scaling
-- DEBUG_FLAGS: various debug-related flags, see the declaration for a list.
--
-- INSERT: quick insert function (quicker than table.insert at least)
-- INSPECT: delegate for lib.inspect (remember to print the result!)
--
-- CAMERA: global gamera, as it gets confused with multiple instances
-- STAGE: stateMachine, to be used with rooms.

-- vars

export L = love
export LG = love.graphics

export SCALE = 1
export SCREEN_WIDTH, SCREEN_HEIGHT = 256, 192
export WINDOW_WIDTH, WINDOW_HEIGHT = SCREEN_WIDTH, SCREEN_HEIGHT

export DEBUG_FLAGS = {
	numbers_to_resize: true
	ctrl_to_debug: true
	escape_to_reset: true

	show_hitboxes: true
	show_positions: true
	show_frame_info: false

	-- for things like debug.debug
	limit_dt: true
}

-- funcs

--- quick insert value into table
export INSERT = (table, value) ->
	table[#table + 1] = value
	return value

export INSPECT = require 'lib.inspect'

--

StateMachine = require 'obj.state_machine.StateMachine'
ImageCache = require 'obj.ImageCache'
baton = require 'lib.baton'

export STAGE = StateMachine!
export IMAGE = ImageCache!

-- TODO: maybe move this to its own func?
export INPUT = baton.new({
	controls: {
		move_left: { 'key:left', 'axis:leftx-' }
		move_right: { 'key:right', 'axis:leftx+' }
		move_up: { 'key:up', 'axis:lefty-' }
		move_down: { 'key:down', 'axis:lefty+' }

		interact: { 'key:z' }

		debug_modifier: { 'key:f' }
		debug_switch_hitboxes: { 'key:q' }
		debug_switch_positions: { 'key:w' }
		debug_switch_frame_info: { 'key:e' }
	}

	pairs: {
		move: { 'move_left', 'move_right', 'move_up', 'move_down' }
	}
})
