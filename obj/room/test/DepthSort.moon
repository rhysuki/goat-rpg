import colour from require 'help.graphics'
import safe_copy from require 'help.table'

Room = require 'obj.room.Room'
GameObject = require 'obj.GameObject'

circle = IMAGE\new_image('*/circle.png')
baton = require 'lib.baton'

class Circle extends GameObject
	new: (room, args = {}) =>
		args = safe_copy({
			colour: nil
		}, args)

		super(room, args)

		@is_player = args.is_player

		@colour = args.colour
		@sprite = circle
		-- the y offset between @pos.y and the "foot" of this object.
		@depth_height = 32

		@input = baton.new({
			controls: {
				left: { 'key:left', 'axis:leftx-' }
				right: { 'key:right', 'axis:leftx+' }
				up: { 'key:up', 'axis:lefty-' }
				down: { 'key:down', 'axis:lefty+' }

				interact: { 'key:z' }
			}

			pairs: {
				move: { 'left', 'right', 'up', 'down' }
			}
		})

	update: (dt) =>
		super(dt)
		@draw_depth = (@pos.y + @depth_height) / 1000

		if not @is_player then return

		if @input\down('up') then @pos.y -= dt * 60
		elseif @input\down('down') then @pos.y += dt * 60

		if @input\down('left') then @pos.x -= dt * 60
		elseif @input\down('right') then @pos.x += dt * 60

	draw: =>
		super!
		colour(@colour)
		LG.draw(@sprite, @pos.x, @pos.y)
		colour!

		@draw_depth_line!

		colour('black')
		LG.print(@draw_depth, @pos.x, @pos.y - 12)
		colour!

	--

	draw_depth_line: =>
		colour('green')

		left_x = @pos.x - 3
		right_x = @pos.x + 3
		foot_y = @pos.y + @depth_height

		LG.line(left_x, @pos.y, right_x, @pos.y)
		LG.line(@pos.x, @pos.y, @pos.x, foot_y)
		LG.line(left_x, foot_y, right_x, foot_y)

		colour!

class Overworld extends Room
	new: =>
		super!

		@background_colour = { 1, 1, 1, 1 }

		@add(Circle, { colour: 'test_red', pos: { x: 50, y: 50 }, is_player: true })
		@add(Circle, { colour: 'test_green', pos: { x: 70, y: 70 }})
		@add(Circle, { colour: 'test_blue', pos: { x: 70, y: 30 }})
		@add(Circle, { colour: 'test_red', pos: { x: 65, y: 35 }})
