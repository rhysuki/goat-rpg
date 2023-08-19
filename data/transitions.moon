CircleTransition = require 'obj.room.transition.CircleTransition'

{
	circle: (room, is_reversed = false) =>
		return CircleTransition(@, { :is_reversed })
}
