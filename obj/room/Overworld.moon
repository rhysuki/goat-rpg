Room = require 'obj.room.Room'
Hitbox = require 'obj.overworld.Hitbox'
Player = require 'obj.overworld.Player'
Map = require 'obj.overworld.Map'

bump = require 'lib.bump'
colours = require 'data.colours'
pubsub = require 'lib.bat.pubsub'

class Overworld extends Room
	new: (args = {}) =>
		super!

		@background_colour = colours.b_black

		@worlds = {
			collision: bump.newWorld!
			interaction: bump.newWorld!
		}

		@pubsubs = {
			test: pubsub!
		}

		@map = @add(Map, { world: @worlds.collision, path: args.map_name })
		@player = @add(Player, {
			world: @worlds.collision,
			interaction_world: @worlds.interaction

			pos: { x: 108, y: 48 }
		})

		with @map.cartographer
			@camera\setWorld(0, 0, @map\get_dimensions!)

		@camera_controller\snap_to_destination!
	--

	add_transition: (name, is_reversed = false) =>
		transition = transitions[name]
		if not transition then error("couldn't find transition #{name}.")
		@members\add(transition(@, is_reversed), 1000)
