GameObject = require 'obj.GameObject'

baton = require 'lib.baton'

class DebugCommands extends GameObject
	new: (room, args = {}) =>
		super(room, args)

		@input = @room.input

		@key = {
			debug_switch_hitboxes: 'show_hitboxes'
			debug_switch_positions: 'show_positions'
			debug_switch_frame_info: 'show_frame_info'
		}

		@is_modifier_enabled = false

	update: (dt) =>
		super(dt)

		if @input\pressed('debug_modifier')
			@is_modifier_enabled = not @is_modifier_enabled

		if @is_modifier_enabled
			for input, flag in pairs @key
				if @input\pressed(input)
					DEBUG_FLAGS[flag] = not DEBUG_FLAGS[flag]
					@is_modifier_enabled = false

	draw: =>
		super!
		if @is_modifier_enabled then LG.print('?')
