-- a base state for a StateMachine.
-- all states keep a ref to the state machine they belong to, and to
-- the object their state machine belongs to (the "context").

-- see obj.state_machine.StateMachine

class State
	new: (state_machine) =>
		@state_machine = state_machine
		@context = @state_machine.context

		if @context
			@room = @context.room
			@members = @context.members
			@input = @context.input

	update: (dt) =>

	draw: =>

	--

	enter: =>

	exit: =>

	--

	goto: (state) =>
		@state_machine\goto(state)