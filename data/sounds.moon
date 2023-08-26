import newSource from L.audio

ripple = require 'lib.ripple'

test_tag = ripple.newTag!

{
	test: ripple.newSound(newSource('data/snd/test/lets_practice.ogg', 'stream'))
}
