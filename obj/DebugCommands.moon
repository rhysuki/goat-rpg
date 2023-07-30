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

		@is_modifier_enabled = false

	update: (dt) =>
		super(dt)
		@input\update(dt)

		if @input\pressed('modifier')
			@is_modifier_enabled = not @is_modifier_enabled

		if @is_modifier_enabled
			if @input\pressed('switch_hitboxes')
				DEBUG_FLAGS.show_hitboxes = not DEBUG_FLAGS.show_hitboxes
				@is_modifier_enabled = false
			if @input\pressed('switch_positions')
				DEBUG_FLAGS.show_positions = not DEBUG_FLAGS.show_positions
				@is_modifier_enabled = false
			if @input\pressed('switch_frame_info')
				DEBUG_FLAGS.show_frame_info = not DEBUG_FLAGS.show_frame_info
				@is_modifier_enabled = false

	draw: =>
		super!
		if @is_modifier_enabled then LG.print('?')
