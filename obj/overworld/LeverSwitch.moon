import safe_copy from require 'help.table'

Interactible = require 'obj.overworld.Interactible'

class LeverSwitch extends Interactible
	new: (room, args = {}) =>
		super(room, args)

		@is_on = false
		@sprite.is_looping = false

	--

	activate: =>
		super!

		@is_on = not @is_on

		if @is_on then @sprite\queue_tags('turn_on', 'on')
		else @sprite\queue_tags('turn_off', 'off')
