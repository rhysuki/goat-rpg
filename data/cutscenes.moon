-- ummmmmm
-- right. I guess it IS a function that returns a function that gets
-- wrapped around a function in the Cutscene call. but. oh well.
TextBox = require 'obj.cutscene.TextBox'

text = require 'data.texts'

{
	test: =>
		return ->
			@player.is_input_enabled = false
			@player\set_move(0, 0)

			@add(TextBox, {
				texts: text.test
				is_bottom: not (@camera\toScreen(@player.pos.x, @player.pos.y) < SCREEN_HEIGHT / 2)
			}, 100)\stall!

			@player.is_input_enabled = true
}
