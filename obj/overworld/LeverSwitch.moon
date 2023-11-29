Interactible = require 'obj.overworld.Interactible'

class LeverSwitch extends Interactible
	new: (room, pubsub, pubsub_event) =>
		super(room, pubsub, pubsub_event)

		@is_on = false
		@sprite.is_looping = false

	--

	activate: =>
		super!

		@is_on = not @is_on

		if @is_on then @sprite\queue_tags('turn_on', 'on')
		else @sprite\queue_tags('turn_off', 'off')
