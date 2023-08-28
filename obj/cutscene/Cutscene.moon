--  a sequence of CutsceneObjects that get created one after another.
import safe_copy from require 'help.table'

CutsceneObject = require 'obj.cutscene.CutsceneObject'

async = require 'lib.bat.async'

class Cutscene extends CutsceneObject
	stall_all: (...) =>
		for obj in *{ ... }
			obj\stall!

	new: (room, args = {}) =>
		args = safe_copy({
			sequence: ->
		}, args)

		super(room, args)

		@kernel = async!
		@base_function = @wrap(args.sequence)

		@kernel\call(@base_function)

	update: (dt) =>
		super(dt)
		@kernel\update(dt)

	--

	-- @treturn func
	wrap: (fn) =>
		return ->
			fn!
			@is_done = true
