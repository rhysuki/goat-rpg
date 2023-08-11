Room = require 'obj.Room'
Hitbox = require 'obj.overworld.Hitbox'
Player = require 'obj.overworld.Player'
Map = require 'obj.overworld.Map'

bump = require 'lib.bump'
colours = require 'data.colours'
pubsub = require 'lib.bat.pubsub'

class Overworld extends Room
	new: (map_name) =>
		super!

		@background_colour = colours.b_black

		@worlds = {
			collision: bump.newWorld!
			interaction: bump.newWorld!
		}

		@pubsubs = {
			test: pubsub!
		}

		@add(Map, @worlds.collision, map_name)
		@add(Player, {
			world: @worlds.collision,
			interaction_world: @worlds.interaction

			pos: { x: 148, y: 48 }
		})

		with @map.cartographer
			@camera\setWorld(0, 0, .width * .tilewidth, .height * .tileheight)
