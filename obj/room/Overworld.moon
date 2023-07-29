Room = require 'obj.Room'
Hitbox = require 'obj.overworld.Hitbox'
Player = require 'obj.overworld.Player'
Map = require 'obj.overworld.Map'

goat = IMAGE\new_image('goat.png')
bump = require 'lib.bump'

class Overworld extends Room
	new: =>
		super!


		@worlds = {
			collision: bump.newWorld!
		}

		@add(Map, @worlds.collision, '*/test.lua')
		@add(Player, { world: @worlds.collision, pos: { x: 148, y: 48 }})
