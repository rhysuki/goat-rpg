-- loads and holds:
-- * a cartographer instance
-- * the shapes and objects from it

-- for the sake of this class, an "object" is a class instance and a
-- "tiled object" is what tiled calls an "object": a thing placed on
-- the map with some properties.

import colour from require 'help.graphics'
import to_file_path, asterisk_complete from require 'help.string'

GameObject = require 'obj.GameObject'

cartographer = require 'lib.cartographer'
assert = require 'lib.bat.assert'

class Map extends GameObject
	new: (room, @world, path) =>
		super(room)

		@path = asterisk_complete(path, 'data/tiled/maps')

		assert(L.filesystem.getInfo(@path), "couldn't find map #{@path}.")

		@cartographer = cartographer.load(@path)

		@valid_layers = @get_valid_layers!

		@shapes = @get_shapes!
		@objects = @get_objects!

		@add_shapes!
		@add_objects!

	update: (dt) =>
		super(dt)

	draw: =>
		super!

		@cartographer\draw!

		if DEBUG_FLAGS.show_hitboxes
			colour(0, 0, 1, 0.5)
			for { :x, :y, :w, :h } in *@shapes
				LG.rectangle('line', x, y, w, h)
			colour!

	--

	--- adds all the shapes in @shapes to @world.
	add_shapes: =>
		for shape in *@shapes
			{ :x, :y, :w, :h } = shape
			@world\add(shape, x, y, w, h)

	--- gets a list of shapes within valid collision layers.
	-- @treturn tab
	get_shapes: =>
		out = {}

		for layer in *@valid_layers.collision
			for id, gid, grid_x, grid_y, pos_x, pos_y in layer\getTiles!
				tile = @get_tile_safely(gid, grid_x, grid_y, layer)
				shape = @get_shape_table(gid, grid_x, grid_y, pos_x, pos_y, tile)

				INSERT(out, shape)

		return out

	-- gets the tile at (grid_x, grid_y), but throws an useful message if
	-- it doesn't exist.
	-- @treturn tab
	get_tile_safely: (gid, grid_x, grid_y, layer) =>
		tile = assert(
			@cartographer\getTile(gid)
			"tile not found in layer #{layer.name} at #{grid_x}, #{grid_y} (gid #{gid}. no collision attached maybe?"
		)

		return tile

	--- makes a properly arranged table off the given tile.
	-- @treturn tab
	get_shape_table: (gid, grid_x, grid_y, pos_x, pos_y, tile) =>
		collision = tile.objectGroup.objects[1]
		{ x: shape_x, y: shape_y, width: w, height: h } = collision

		return {
			x: pos_x + shape_x
			y: pos_y + shape_y
			:w
			:h

			:grid_x
			:grid_y

			:gid
			:tile
			:collision

			is_solid: true
		}

	--- adds all the objects in @objects to @members.
	add_objects: =>
		for object in *@objects
			@room.members\add(object)

	-- like @get_tiled_objects, but instantiated.
	-- @treturn tab
	get_objects: =>
		return [@instantiate(object) for object in *@get_tiled_objects!]

	--- instantiates the given tiled object. its "type" attribute should
	-- be a string that's a require path (like "obj.GameObject").
	-- its associated class MUST have a static from_tiled_object method.
	-- @treturn GameObject
	instantiate: (object) =>
		path = object.type
		ok, obj_class = pcall(require, path)

		assert(ok, "class not found:\n#{path}\nat #{object.x}, #{object.y}")
		assert(
			obj_class.from_tiled_object
			"#{obj_class.__name} doesn't have a from_tiled_object method"
		)

		obj = with obj_class\from_tiled_object(@room, object)
			\set_position(object.x, object.y)

		return obj

	--- returns the dimensions, in pixels, of @cartographer.
	-- @treturn int, int
	get_dimensions: =>
		with @cartographer
			return .width * .tilewidth, .height * .tileheight

	--- gets all tiled objects in the map.
	-- @treturn tab
	get_tiled_objects: =>
		out = {}

		for layer in *@valid_layers.object
			for object in *layer.objects
				INSERT(out, object)

		return out

	--- gets the layers of the map who should be used (those whose names
	-- don't start with //).
	-- @treturn tab
	get_valid_layers: =>
		out = {
			collision: {}
			object: {}
		}

		for layer in *@cartographer.layers
			if layer.name\sub(1, 2) == '//' then continue

			switch layer.type
				when 'tilelayer' then INSERT(out.collision, layer)
				when 'objectgroup' then INSERT(out.object, layer)

		return out
