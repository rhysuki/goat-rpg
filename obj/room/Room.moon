import colour from require 'help.graphics'

LayeredManager = require 'obj.manager.LayeredManager'
State = require 'obj.state_machine.State'
CameraController = require 'obj.CameraController'
DebugCommands = require 'obj.DebugCommands'

gamera = require 'lib.gamera'

class Room extends State
	new: (args = {}) =>
		-- always passes STAGE as its owner stateMachine, and has no
		-- context.
		super(STAGE)
		@background_colour = { 0, 0, 0 }

		@members = LayeredManager!

		@camera = gamera.new(-math.huge, -math.huge, math.huge, math.huge)
		@camera_controller = @add(CameraController, @camera)

		@camera\setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

		@members\add(DebugCommands(@), 1000)

		@camera_controller.smoothing = 0.1

	update: (dt) =>
		@members\update(dt)
		nil

	draw: =>
		LG.clear(@background_colour)
		@camera\draw(-> @draw_in_camera!)
		nil

	--

	--- gets called inside @camera.draw. draw here to draw "in-world".
	-- you could put UI and stuff in @draw but that's kinda limiting.
	-- just snap elements to the camera position and use layers.
	draw_in_camera: =>
		@members\draw!

	add_transition: (transition) =>
		@members\add(transition, 100)

	--- changes to new_room when in_transition finishes.
	transition_to: (new_room, in_transition, out_transition = nil) =>
		@add_transition(in_transition)
		in_transition\set_next_room(new_room)

		if out_transition then new_room\add_transition(out_transition)

	--- quick add! doesn't work with objects that've been instantiated
	-- already. use @members\add for that
	-- @treturn obj
	add: (obj_class, ...) =>
		return @members\add(obj_class(@, ...))
