import safe_copy from require 'help.table'

Room = require 'obj.room.Room'
Hitbox = require 'obj.overworld.Hitbox'
Player = require 'obj.overworld.Player'
Map = require 'obj.overworld.Map'

bump = require 'lib.bump'
pubsub = require 'lib.bat.pubsub'
colours = require 'data.colours'
transitions = require 'data.transitions'

class Overworld extends Room
	new: (args = {}) =>
		args = safe_copy({
			map_name: ''
			transition_name: nil
		}, args)

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

		-- a transition added from the args table in new will always be
		-- reversed
		if args.transition_name then @add_transition(args.transition_name, true)

	--

	add_transition: (name, is_reversed = false) =>
		transition_func = transitions[name]
		if not transition_func then error("couldn't find transition #{name}.")
		return @members\add(transition_func(@, is_reversed), 1000)
