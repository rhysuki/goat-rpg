import newSource from L.audio

ripple = require 'lib.ripple'

test_tag = ripple.newTag!

{
	test: ripple.newSound(newSource('data/snd/test/dragonfoda.ogg', 'stream'))
}
