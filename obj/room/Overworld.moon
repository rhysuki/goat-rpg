import safe_copy from require 'help.table'

Room = require 'obj.room.Room'
Hitbox = require 'obj.overworld.Hitbox'
Player = require 'obj.overworld.Player'
Map = require 'obj.overworld.Map'
Cutscene = require 'obj.cutscene.Cutscene'
TextBox = require 'obj.cutscene.TextBox'

bump = require 'lib.bump'
pubsub = require 'lib.bat.pubsub'
colours = require 'data.colours'
cutscenes = require 'data.cutscenes'
texts = require 'data.texts'

class Overworld extends Room
	new: (args = {}) =>
		args = safe_copy({
			map_name: ''
			transition_name: nil
			target_exit_id: nil
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

		@player = @add(Player, {
			world: @worlds.collision,
			interaction_world: @worlds.interaction

			pos: { x: 108, y: 48 }
		})
		@map = @add(Map, { world: @worlds.collision, path: args.map_name }, -1)

		with @map.cartographer
			@camera\setWorld(0, 0, @map\get_dimensions!)

		-- a transition added from the args table in new will always be
		-- reversed
		if args.transition_name then @add_transition(args.transition_name, true)
		if args.target_exit_id
			exit = @find_exit_with_id(args.target_exit_id)
			if not exit then error("couldn't find exit with id #{args.target_exit_id}.")
			exit\move_player_to_this(@player)

		@camera_controller\snap_to_destination!

	--

	-- returns the exit with this id, nil if not found.
	-- doesn't aaaacccctually search for only instances of the class Exit,
	-- but... who gaf
	-- @treturn obj | nil
	find_exit_with_id: (id) =>
		for obj in *@members.list
			if obj.exit_id == id then return obj

	-- @treturn obj
	add_cutscene: (name) =>
		@add(Cutscene, { sequence: cutscenes[name](@) })

	-- @treturn obj
	add_text_box: (text_name) =>
		return @add(TextBox, {
			texts: texts[text_name]
			is_bottom: not (@camera\toScreen(@player.pos.x, @player.pos.y) < SCREEN_HEIGHT / 2)
		}, 100)

		return @add(Textbox\from_string(text_name, @player.pos), 100)
