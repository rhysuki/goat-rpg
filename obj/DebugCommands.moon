GameObject = require 'obj.GameObject'

baton = require 'lib.baton'

class DebugCommands extends GameObject
	new: (room, args = {}) =>
		super(room, args)

		@input = baton.new({
			controls: {
				modifier: { 'key:f' }

				switch_hitboxes: { 'key:q' }
				switch_positions: { 'key:w' }
				switch_frame_info: { 'key:e' }
			}
		})

		@key = {
			switch_hitboxes: 'show_hitboxes'
			switch_positions: 'show_positions'
			switch_frame_info: 'show_frame_info'
		}

		@is_modifier_enabled = false

	update: (dt) =>
		super(dt)
		@input\update(dt)

		if @input\pressed('modifier')
			@is_modifier_enabled = not @is_modifier_enabled

		if @is_modifier_enabled
			for input, flag in pairs @key
				if @input\pressed(input)
					DEBUG_FLAGS[flag] = not DEBUG_FLAGS[flag]
					@is_modifier_enabled = false

	draw: =>
		super!
		if @is_modifier_enabled then LG.print('?')
