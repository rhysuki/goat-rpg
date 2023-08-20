CircleTransition = require 'obj.room.transition.CircleTransition'

{
	circle: (room, is_reversed = nil) ->
		return CircleTransition(room, {
			:is_reversed
			duration: 1.5
			target: room.player.pos
			target_offset: { x: 6, y: -1 }
		})
}
