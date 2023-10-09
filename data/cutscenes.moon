-- ummmmmm
-- right. I guess it IS a function that returns a function that gets
-- wrapped around a function in the Cutscene call. but. oh well.
import wait from require 'lib.bat.async'

TextBox = require 'obj.cutscene.TextBox'
PlayerCutsceneController = require 'obj.overworld.PlayerCutsceneController'

text = require 'data.texts'

{
	test: =>
		return ->
			player_controller = @add(PlayerCutsceneController, { player: @player })

			@add_text_box('test1')\stall!

			with player_controller
				\move_and_stop('up', 0.2)
				wait(1)
				\move_and_stop('left', 0.2)
				wait(0.5)
				\move_and_stop('right', 0.4)
				wait(1)
				\move_toward('left', 0.2)
				\move_and_stop('down', 0.1)

			@add_text_box('test2')\stall!

			player_controller\die!
}
