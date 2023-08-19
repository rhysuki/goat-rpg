CircleTransition = require 'obj.room.transition.CircleTransition'

{
	circle: (room, is_reversed = false) ->
		return CircleTransition(room, { :is_reversed })
}
