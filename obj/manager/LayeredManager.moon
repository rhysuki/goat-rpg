-- GenericManager but with draw layers
-- the higher the depth of an object, the more in front it gets drawn.
-- if same depth, checks time_created instead

-- depth values don't have to be integers
-- !! but be wary of imprecisions!

import r_ipairs from require 'help.table'
GenericManager = require 'obj.manager.GenericManager'

class LayeredManager extends GenericManager
	new: =>
		super!
		@sorted_objects = {}

	update: (dt) =>
		super(dt)

	draw: =>
		table.sort(@sorted_objects, @layer_sort)

		for obj in *@sorted_objects
			if @check_for_draw(obj) then obj\draw!

	--

	add: (obj, depth = 0) =>
		obj.draw_depth = depth
		INSERT(@sorted_objects, obj)
		return super(obj)

	remove_dead_items: =>
		super!

		for i, obj in r_ipairs(@sorted_objects)
			if obj.is_dead then table.remove(@sorted_objects, i)

	-- do note this is NOT a self function
	layer_sort: (a, b) ->
		if a.draw_depth == b.draw_depth
			return a.time_created < b.time_created

		return a.draw_depth < b.draw_depth