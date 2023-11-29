--- very generic class that calls update and draw on added members.

import r_ipairs from require 'help.table'

class GenericManager
	new: (room) =>
		@room = room
		@list = {}

	update: (dt) =>
		for obj in *@list
			if @check_for_update(obj) then obj\update(dt)

		@remove_dead_items!

	draw: =>
		for obj in *@list
			if @check_for_draw(obj) then obj\draw!

	--

	-- @treturn obj
	add: (obj) =>
		INSERT(@list, obj)
		return obj

	-- @treturn boolean
	check_for_update: (obj) =>
		if not obj.update then return false
		if obj.is_dead then return false
		-- explicitly checking for false, not just !nil
		if obj.is_active == false then return false

		return true

	-- @treturn boolean
	check_for_draw: (obj) =>
		if not obj.draw then return false
		if obj.is_dead then return false
		if obj.is_visible == false then return false

		return true

	remove_dead_items: =>
		for i, obj in r_ipairs @list
			if obj.is_dead then table.remove(@list, i)
