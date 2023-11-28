-- GameObject for inside an async kernel (like the one in Cutscene).

-- by calling stall, they can keep updating and drawing while in an idle
-- state until something triggers the @finish call.

GameObject = require 'obj.GameObject'
async = require 'lib.bat.async'

class CutsceneObject extends GameObject
	new: (room) =>
		super(room)
		@is_done = false

	--

	stall: =>
		while not @is_done do async.stall!

	finish: =>
		@is_done = true
