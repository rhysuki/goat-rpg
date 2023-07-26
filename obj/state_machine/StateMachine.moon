-- yay for FSM
-- to be used with obj.state_machine.State.
-- every state machine keeps a ref to the object it belongs to (its "context").

class StateMachine
	new: (context = nil) =>
		@context = context

		if @context
			@room = @context.room
			@members = @context.members
			@input = @context.input

		@current = nil
		@stack = {}

	update: (dt) =>
		if @current and @current.update then @current\update(dt)

	draw: =>
		if @current and @current.draw then @current\draw!

	--

	goto: (state) =>
		if @current
			@current\exit!

		@current = state

		if @current.enter then @current\enter!

	--- pushes @current to @stack and switches to the given state.
	push: (state) =>
		INSERT(@stack, @current)
		@goto(state)

	--- returns to the topmost state in the stack.
	-- @treturn State
	pop: =>
		if #@stack == 0
			error("tried to pop an empty stack")

		popped = @current
		@goto(table.remove(@stack))

		return popped
