import newSource from L.audio
import newSound from require 'lib.ripple'

{
	test: newSound(newSource('data/snd/test/lets_practice.ogg', 'stream'))

	sprint: newSound(newSource('data/snd/test/sprint.ogg', 'static'))
	cannon: newSound(newSource('data/snd/test/cannon.ogg', 'static'))
}
