Room = require 'obj.Room'
Hitbox = require 'obj.overworld.Hitbox'
Player = require 'obj.overworld.Player'
Map = require 'obj.overworld.Map'

bump = require 'lib.bump'
colours = require 'data.colours'
pubsub = require 'lib.bat.pubsub'

class Overworld extends Room
	new: =>
		super!

		@background_colour = colours.b_black

		@worlds = {
			collision: bump.newWorld!
			interaction: bump.newWorld!
		}

		@pubsubs = {
			test: pubsub!
		}

		@add(Map, @worlds.collision, '*/test.lua')
		@add(Player, {
			world: @worlds.collision,
			interaction_world: @worlds.interaction

			pos: { x: 148, y: 48 }
		})
