CircleTransition = require 'obj.room.transition.CircleTransition'

{
	circle_out: (room) =>
		return CircleTransition(@, { is_reversed: true })
}
