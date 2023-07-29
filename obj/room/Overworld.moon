Room = require 'obj.Room'
Hitbox = require 'obj.overworld.Hitbox'
Player = require 'obj.overworld.Player'
Map = require 'obj.overworld.Map'

goat = IMAGE\new_image('goat.png')
bump = require 'lib.bump'

class Overworld extends Room
	new: =>
		super!

		@world = bump.newWorld!


		@add(Map, @world, '*/test.lua')
		@add(Player, { world: @world })
