import safe_copy from require 'help.table'

Interactible = require 'obj.overworld.Interactible'

class LeverSwitch extends Interactible
	new: (room, args = {}) =>
		super(room, args)

		@is_on = false

		-- TODO: player doesn't seem to need to touch area_triggers
		-- to activate this?

	update: (dt) =>
		super(dt)
		-- print #@area_trigger.cols

	--

	activate: =>
		super!

		@is_on = not @is_on

		if @is_on then @sprite\play_tag('on')
		else @sprite\play_tag('off')
