import colour from require 'help.graphics'

Room = require 'obj.room.Room'
GameObject = require 'obj.GameObject'

circle = IMAGE\new_image('*/circle.png')
baton = require 'lib.baton'

class Circle extends GameObject
	new: (room, @colour) =>
		super(room)

		@is_player = args.is_player

		@sprite = circle
		-- the y offset between @y and the "foot" of this object.
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
		@draw_depth = (@y + @depth_height) / 1000

		if not @is_player then return

		if @input\down('up') then @y -= dt * 60
		elseif @input\down('down') then @y += dt * 60

		if @input\down('left') then @x -= dt * 60
		elseif @input\down('right') then @x += dt * 60

	draw: =>
		super!
		colour(@colour)
		LG.draw(@sprite, @x, @y)
		colour!

		@draw_depth_line!

		colour('black')
		LG.print(@draw_depth, @x, @y - 12)
		colour!

	--

	draw_depth_line: =>
		colour('green')

		left_x = @x - 3
		right_x = @x + 3
		foot_y = @y + @depth_height

		LG.line(left_x, @y, right_x, @y)
		LG.line(@x, @y, @x, foot_y)
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
