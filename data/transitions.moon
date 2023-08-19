CircleTransition = require 'obj.room.transition.CircleTransition'

{
	circle: (room, is_reversed = nil) ->
		return CircleTransition(room, { :is_reversed })
}
